//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Normalizador
// Description: Selecciona entre suma y multiplicación para mostrar el resultado correspondiente.
//////////////////////////////////////////////////////////////////////////////////

module Normalizador (
    input OP_input,        // 0: suma, 1: multiplicación
    input Signo_mul,       // Signo para multiplicación
    input Signo_sum,       // Signo para suma
    input [7:0] Exp_comun, // Exponente para suma
    input [8:0] Exp_resul, // Exponente para multiplicación 
    input [47:0] Producto, // Resultado de multiplicación 
    input [26:0] Suma_resul, // Resultado de suma
    output [31:0] Resultado // Resultado final normalizado
);

reg [22:0] mantissa_final;
reg [7:0] exponente_final;
reg signo_final;

// Variables para redondeo y detectar overflow
reg guard_bit, round_bit, sticky_bit;
reg [23:0] mantissa_red; 

// Variables para encontrar el bit más significativo
reg [5:0] cont_zeros;
reg [47:0] shifted_mul;
reg [26:0] shifted_sum;
reg signed [9:0] exp_temp;

// Resultado final
assign Resultado = {signo_final, exponente_final, mantissa_final};

always @(*) begin
    // Se selecciona el signo según la operación 
    signo_final = OP_input ? Signo_mul : Signo_sum;
    
    guard_bit = 1'b0;
    round_bit = 1'b0;
    sticky_bit = 1'b0;
    mantissa_red = 24'b0;
    
    if (OP_input) begin // Multiplicación
        // Revisar si el resultado es cero
        if (Producto == 0) begin
            exponente_final = 8'b0;
            mantissa_final = 23'b0;
        end
        else begin
            exp_temp = $signed({1'b0, Exp_resul});

            if (Producto[47]) begin // Detectar overflow (hay que hacer shift a la derecha)
                mantissa_red = {1'b1, Producto[46:24]}; 
                guard_bit = Producto[23];
                round_bit = Producto[22];
                sticky_bit = |Producto[21:0]; // OR de todos los demás bits 
                exp_temp = exp_temp + 1; // Se le suma 1 al exponente por el shift
            end
            else if (Producto[46]) begin // No hay overflow (no hay que hacer shift y el exponente se mantiene igual)
                mantissa_red = {1'b1, Producto[45:23]};
                guard_bit = Producto[22];
                round_bit = Producto[21];
                sticky_bit = |Producto[20:0];
            end
            else begin // Detectar underflow (hay que hacer shift a la izquierda)
                cont_zeros = 0;
                shifted_mul = Producto;
                // Revisar por partes para encontrar el bit más significativo
                if (Producto[45:40] == 6'b0) begin 
                    cont_zeros = cont_zeros + 6; shifted_mul = shifted_mul << 6; 
                    end
                if (shifted_mul[47:44] == 4'b0) begin 
                    cont_zeros = cont_zeros + 4; shifted_mul = shifted_mul << 4; 
                    end
                if (shifted_mul[47:46] == 2'b0) begin 
                    cont_zeros = cont_zeros + 2; shifted_mul = shifted_mul << 2; 
                    end
                if (shifted_mul[47] == 1'b0) begin 
                    cont_zeros = cont_zeros + 1; shifted_mul = shifted_mul << 1; 
                    end
                
                mantissa_red = {1'b1, shifted_mul[46:24]};
                guard_bit = shifted_mul[23];
                round_bit = shifted_mul[22];
                sticky_bit = |shifted_mul[21:0];
                exp_temp = exp_temp - cont_zeros; // Se restan la cantidad de ceros por la cantidad de shifts que se hicieron
            end
            
            // Redondeo
            if (guard_bit && (round_bit || sticky_bit || mantissa_red[0])) begin
                mantissa_red = mantissa_red + 1;
                
                // Se revisa si hay overflow en la mantissa redondeada
                if (mantissa_red[24]) begin
                    mantissa_red = 24'h800000; // Si hay overflow se normaliza
                    exp_temp = exp_temp + 1; 
                end
            end
            
            if (exp_temp >= 10'd255) begin // Si el exponente es mayor que 255 se establece como 11111111 y la mantisa en 0000...
                exponente_final = 8'hFF;
                mantissa_final = 23'b0;
            end
            else if (exp_temp <= 10'd0) begin // Si el exponente es menor que 255 se establece como 00000000 y la mantisa en 0000...
                exponente_final = 8'b0;
                mantissa_final = 23'b0;
            end
            else begin 
                exponente_final = exp_temp[7:0]; // Si el exponente está en un rango válido se convierte a 8 bits
                mantissa_final = mantissa_red[22:0]; // Se quita el bit implícito para tener una mantissa de 23 bits
            end
        end
    end
    else begin // Suma    
        // Revisar si el resultado es cero
        if (Suma_resul == 0) begin
            exponente_final = 8'b0;
            mantissa_final = 23'b0;
            signo_final = 1'b0; 
        end
        else begin
            exp_temp = $signed({2'b00, Exp_comun}); 
            
            if (Suma_resul[26]) begin // Detectar overflow (hay que hacer shift a la derecha)
                mantissa_red = {1'b1, Suma_resul[25:3]}; 
                guard_bit = Suma_resul[2];
                round_bit = Suma_resul[1];
                sticky_bit = Suma_resul[0];
                exp_temp = exp_temp + 1;
            end
            else if (Suma_resul[25]) begin // No hay overflow (no hay que hacer shift y el exponente se mantiene igual)
                mantissa_red = {1'b1, Suma_resul[24:2]}; 
                guard_bit = Suma_resul[1];
                round_bit = Suma_resul[0];
                sticky_bit = 1'b0; 
            end
            else begin // Detectar underflow (hay que hacer shift a la izquierda)
                cont_zeros = 0;
                shifted_sum = Suma_resul;
                
                // Buscar el bit 1 más significativo por medio de un while para recorrer toda la suma
                while (shifted_sum != 0 && shifted_sum[25] == 1'b0 && cont_zeros < 26) begin
                    shifted_sum = shifted_sum << 1;
                    cont_zeros = cont_zeros + 1;
                end

                mantissa_red = {1'b1, shifted_sum[24:2]};
                guard_bit = shifted_sum[1];
                round_bit = shifted_sum[0];
                sticky_bit = 1'b0; 
                exp_temp = exp_temp - cont_zeros;
            end
            
            // Solo procesar redondeo y asignación final si no es cero
            if (!(exponente_final == 8'b0 && mantissa_final == 23'b0)) begin
                // Redondeo
                if (guard_bit && (round_bit || sticky_bit || mantissa_red[0])) begin
                    mantissa_red = mantissa_red + 1;
                    
                    // Se revisa si hay overflow en la mantissa redondeada
                    if (mantissa_red[24]) begin
                        mantissa_red = 24'h800000; // Si hay overflow se normaliza
                        exp_temp = exp_temp + 1;
                    end
                end
                
                if (exp_temp <= 10'd0) begin // Si el exponente es menor o igual a 0
                    exponente_final = 8'b0;
                    mantissa_final = 23'b0;
                    signo_final = 1'b0; // Underflow a +0
                end
                else if (exp_temp >= 10'd255) begin // Si el exponente es mayor o igual a 255
                    exponente_final = 8'hFF;
                    mantissa_final = 23'b0; // Overflow a infinito
                end
                else begin
                    exponente_final = exp_temp[7:0]; // Si el exponente está en un rango válido se convierte a 8 bits
                    mantissa_final = mantissa_red[22:0]; // Se quita el bit implícito para tener una mantissa de 23 bits
                end
            end
        end
    end
end

endmodule
