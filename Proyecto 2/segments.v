//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Regsitros de Segmentos
// Description:
//////////////////////////////////////////////////////////////////////////////////

module segments (
    //inputs
    input wire clk;
    input wire rst; 
    input write_en; 
    input  [1:0] reg_select; // 00 CS, 01 ES, 10 DS, 11 SS
    input  [15:0] data;

    //outputs de segmentos 
    output [15:0] cs_out;
    output [15:0] ds_out;
    output [15:0] ss_out;
    output [15:0] es_out;
);

localparam CS = 2'b00;
localparam DS = 2'b01;
localparam SS = 2'b10;
localparam ES = 2'b11;

always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        cs_out <= 16'h0000;
        ds_out <= 16'h0000;
        ss_out <= 16'h0000;
        es_out <= 16'h0000;
        
    end 
    `elsif (write_en) begin
        case (reg_select)
        CS: cs_out <= data;
        DS: ds_out <= data;
        SS: ss_out <= data;
        ES: es_out <= data;
        endcase 
    end 
    
end

endmodule
