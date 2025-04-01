//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: MUX
// Description: Multiplexor para elegir el registro que se va a leer / escribir
//////////////////////////////////////////////////////////////////////////////////

module MUX (
    input size,
    input select_high_low,
    input [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7,
    input [2:0] sel_reg,
    output reg [15:0] data_out
);

    always @(*) begin
        if (size == 1) begin
            case (sel_reg)
                3'b000 : data_out = reg0;
                3'b001 : data_out = reg1;
                3'b010 : data_out = reg2;
                3'b011 : data_out = reg3;
                3'b100 : data_out = reg4;
                3'b101 : data_out = reg5;
                3'b110 : data_out = reg6;
                3'b111 : data_out = reg7;
                default: data_out = 16'b0000000000000000;
            endcase
        end
        else begin
            if (select_high_low == 1) begin
                case (sel_reg)
                    3'b000 : data_out = {reg0[15:8], 8'b00000000};
                    3'b001 : data_out = {reg1[15:8], 8'b00000000};
                    3'b010 : data_out = {reg2[15:8], 8'b00000000};
                    3'b011 : data_out = {reg3[15:8], 8'b00000000};
                    default: data_out = 16'b0000000000000000;
                endcase
            end
            else begin
                case (sel_reg)
                    3'b000 : data_out = {8'b00000000, reg0[7:0]};
                    3'b001 : data_out = {8'b00000000, reg1[7:0]};
                    3'b010 : data_out = {8'b00000000, reg2[7:0]};
                    3'b011 : data_out = {8'b00000000, reg3[7:0]};
                    default: data_out = 16'b0000000000000000;
                endcase
            end
        end
    end

endmodule
