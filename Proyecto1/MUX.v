//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: MUX
// Description: Multiplexor para elegir el registro que se va a leer
//////////////////////////////////////////////////////////////////////////////////

module MUX (
    input size,             // Tamaño del dato (1: 16 bits, 0: 8 bits)
    input select_high_low,  // Seleccionar parte alta (1) o baja (0) de los registros de uso general
    input [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7,  // Registros de Uso General y de Puntero e Indice
    input [2:0] sel_reg,    // Entrada de selección para el registro
    output reg [15:0] data_out  // Datos de salida
);

    always @(*) begin
        if (size == 1) begin    // Registros de 16 bits
            case (sel_reg)
                3'b000 : data_out = reg0; // AX
                3'b001 : data_out = reg1; // BX
                3'b010 : data_out = reg2; // CX
                3'b011 : data_out = reg3; // DX
                3'b100 : data_out = reg4; // SI
                3'b101 : data_out = reg5; // DI
                3'b110 : data_out = reg6; // SP
                3'b111 : data_out = reg7; // BP
                default: data_out = 16'b0000000000000000;
            endcase
        end
        else begin  // Registros de 8 bits
            // Parte alta del registro (Se escribe en la parte alta y se rellena la parte baja con ceros para completar los 16 bits)
            if (select_high_low == 1) begin 
                case (sel_reg)
                    3'b000 : data_out = {reg0[15:8], 8'b00000000}; // AH
                    3'b001 : data_out = {reg1[15:8], 8'b00000000}; // BH
                    3'b010 : data_out = {reg2[15:8], 8'b00000000}; // CH
                    3'b011 : data_out = {reg3[15:8], 8'b00000000}; // DH
                    default: data_out = 16'b0000000000000000;
                endcase
            end
            // Parte baja del registro (Se escribe en la parte baja y se rellena la parte alta con ceros para completar los 16 bits)
            else begin
                case (sel_reg)
                    3'b000 : data_out = {8'b00000000, reg0[7:0]}; // AL
                    3'b001 : data_out = {8'b00000000, reg1[7:0]}; // BL
                    3'b010 : data_out = {8'b00000000, reg2[7:0]}; // CL
                    3'b011 : data_out = {8'b00000000, reg3[7:0]}; // DL
                    default: data_out = 16'b0000000000000000;
                endcase
            end
        end
    end

endmodule
