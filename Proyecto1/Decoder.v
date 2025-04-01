//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Decoder
// Description: Decodificador para seleccionar el registro
//////////////////////////////////////////////////////////////////////////////////

module Decoder (
    input [2:0] select_reg,    // Variable que elige el registro
    input size,                // Tamaño del dato (1= 16 bits, 0= 8 bits)
    input select_high_low,     // Seleccionar parte alta (1) o baja (0) de los registros de uso general
    output reg [15:0] output_reg    // Salida
);

    always @(*) begin
        if(size == 1) begin
            case(select_reg)
                3'b000 : output_reg = 16'b0000000000000001; //AX
                3'b001 : output_reg = 16'b0000000000000010; //BX
                3'b010 : output_reg = 16'b0000000000000100; //CX
                3'b011 : output_reg = 16'b0000000000001000; //DX
                3'b100 : output_reg = 16'b0000000000010000; //SI
                3'b101 : output_reg = 16'b0000000000100000; //DI
                3'b110 : output_reg = 16'b0000000001000000; //SP
                3'b111 : output_reg = 16'b0000000010000000; //BP
                default : output_reg = 16'b0000000000000000;
            endcase
        end
        else begin
            if(select_high_low == 1)begin
                case(select_reg)
                    3'b000 : output_reg = 16'b0000000100000000; //AH
                    3'b001 : output_reg = 16'b0000001000000000; //BH
                    3'b010 : output_reg = 16'b0000010000000000; //CH
                    3'b011 : output_reg = 16'b0000100000000000; //DH
                    default : output_reg = 16'b0000000000000000;
                endcase
            end
            else begin
                case(select_reg)
                    3'b000 : output_reg = 16'b0001000000000000; //AL
                    3'b001 : output_reg = 16'b0010000000000000; //BL
                    3'b010 : output_reg = 16'b0100000000000000; //CL
                    3'b011 : output_reg = 16'b1000000000000000; //DL
                    default : output_reg = 16'b0000000000000000;
                endcase
            end
        end
    end    

endmodule
