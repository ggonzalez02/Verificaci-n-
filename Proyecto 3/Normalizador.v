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
    input OP_input,
    input Signo_mul,
    input Signo_sum,
    input [7:0] Exp_comun,
    input [8:0] Exp_resul,
    input [47:0] Producto,
    input [26:0] Suma_resul,
    output [31:0] Resultado
);

reg [22:0] mantissa_final;
reg [7:0] exponente_final;
reg signo_final;
reg guard_bit, round_bit, sticky_bit;
reg [23:0] mantissa_rounded;
reg [5:0] leading_zeros;
reg [47:0] shifted_mult;
reg [26:0] shifted_sum;
reg signed [9:0] exp_temp;

assign Resultado = {signo_final, exponente_final, mantissa_final};

always @(*) begin
    signo_final = OP_input ? Signo_mul : Signo_sum;
    
    guard_bit = 1'b0;
    round_bit = 1'b0;
    sticky_bit = 1'b0;
    mantissa_rounded = 24'b0;
    
    if (OP_input) begin
        if (Producto == 0) begin
            exponente_final = 8'b0;
            mantissa_final = 23'b0;
        end
        else begin
            exp_temp = $signed({1'b0, Exp_resul});
            
            if (Producto[47]) begin
                mantissa_rounded = {1'b1, Producto[46:24]};
                guard_bit = Producto[23];
                round_bit = Producto[22];
                sticky_bit = |Producto[21:0];
                exp_temp = exp_temp + 1;
            end
            else if (Producto[46]) begin
                mantissa_rounded = {1'b1, Producto[45:23]};
                guard_bit = Producto[22];
                round_bit = Producto[21];
                sticky_bit = |Producto[20:0];
            end
            else begin
                leading_zeros = 0;
                shifted_mult = Producto;
                
                if (Producto[45:40] == 6'b0) begin leading_zeros = leading_zeros + 6; shifted_mult = shifted_mult << 6; end
                if (shifted_mult[47:44] == 4'b0) begin leading_zeros = leading_zeros + 4; shifted_mult = shifted_mult << 4; end
                if (shifted_mult[47:46] == 2'b0) begin leading_zeros = leading_zeros + 2; shifted_mult = shifted_mult << 2; end
                if (shifted_mult[47] == 1'b0) begin leading_zeros = leading_zeros + 1; shifted_mult = shifted_mult << 1; end
                
                mantissa_rounded = {1'b1, shifted_mult[46:24]};
                guard_bit = shifted_mult[23];
                round_bit = shifted_mult[22];
                sticky_bit = |shifted_mult[21:0];
                exp_temp = exp_temp - leading_zeros;
            end
            
            if (guard_bit && (round_bit || sticky_bit || mantissa_rounded[0])) begin
                mantissa_rounded = mantissa_rounded + 1;
                
                if (mantissa_rounded[24]) begin
                    mantissa_rounded = 24'h800000;
                    exp_temp = exp_temp + 1;
                end
            end
            
            if (exp_temp >= 10'd255) begin
                exponente_final = 8'hFF;
                mantissa_final = 23'b0;
            end
            else if (exp_temp <= 10'd0) begin
                exponente_final = 8'b0;
                mantissa_final = 23'b0;
            end
            else begin
                exponente_final = exp_temp[7:0];
                mantissa_final = mantissa_rounded[22:0];
            end
        end
    end
    else begin
        if (Suma_resul == 0) begin
            exponente_final = 8'b0;
            mantissa_final = 23'b0;
        end
        else begin
            exp_temp = $signed({2'b00, Exp_comun});
            
            if (Suma_resul[26]) begin
                mantissa_rounded = {1'b1, Suma_resul[25:3]};
                guard_bit = Suma_resul[2];
                round_bit = Suma_resul[1];
                sticky_bit = Suma_resul[0];
                exp_temp = exp_temp + 1;
            end
            else if (Suma_resul[25]) begin
                mantissa_rounded = {1'b1, Suma_resul[24:2]};
                guard_bit = Suma_resul[1];
                round_bit = Suma_resul[0];
                sticky_bit = 1'b0;
            end
            else begin
                leading_zeros = 0;
                shifted_sum = Suma_resul;
                
                if (shifted_sum[24:20] == 5'b0) begin leading_zeros = leading_zeros + 5; shifted_sum = shifted_sum << 5; end
                if (shifted_sum[25:23] == 3'b0) begin leading_zeros = leading_zeros + 3; shifted_sum = shifted_sum << 3; end
                if (shifted_sum[25:24] == 2'b0) begin leading_zeros = leading_zeros + 2; shifted_sum = shifted_sum << 2; end
                if (shifted_sum[25] == 1'b0) begin leading_zeros = leading_zeros + 1; shifted_sum = shifted_sum << 1; end
                
                mantissa_rounded = {1'b1, shifted_sum[24:2]};
                guard_bit = shifted_sum[1];
                round_bit = shifted_sum[0];
                sticky_bit = 1'b0;
                exp_temp = exp_temp - leading_zeros;
            end
            
            if (guard_bit && (round_bit || sticky_bit || mantissa_rounded[0])) begin
                mantissa_rounded = mantissa_rounded + 1;
                
                if (mantissa_rounded[24]) begin
                    mantissa_rounded = 24'h800000;
                    exp_temp = exp_temp + 1;
                end
            end
            
            if (exp_temp <= 10'd0) begin
                exponente_final = 8'b0;
                mantissa_final = 23'b0;
            end
            else if (exp_temp >= 10'd255) begin
                exponente_final = 8'hFF;
                mantissa_final = 23'b0;
            end
            else begin
                exponente_final = exp_temp[7:0];
                mantissa_final = mantissa_rounded[22:0];
            end
        end
    end
end

endmodule
