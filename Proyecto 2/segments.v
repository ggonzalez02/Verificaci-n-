//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Registros de Segmentos
// Description:
//////////////////////////////////////////////////////////////////////////////////

module segments (
    //inputs
    input wire clk,
    input wire rst, 
    input write_en, //0: Lectura, 1: Escritura
    input  [2:0] reg_select, //000 CS, 001 ES, 010 DS, 011 SS, 100
    input  [15:0] data,
    output [15:0] Data_Segment //Segmento de salida
);

//Parámetros internos para facilitar lectura
localparam CS = 3'b000;
localparam DS = 3'b001;
localparam SS = 3'b010;
localparam ES = 3'b011;
localparam IP = 3'b100;

//Registros de segmento
reg [15:0] cs_out, ds_out, ss_out, es_out, ip_out;

always @(posedge clk or posedge rst ) begin
    if (rst) begin
        cs_out <= 16'h0000;
        ds_out <= 16'h0000;
        ss_out <= 16'h0000;
        es_out <= 16'h0000;
        
    end
    else if (write_en) begin
        case (reg_select)
            CS: cs_out <= data;
            DS: ds_out <= data;
            SS: ss_out <= data;
            ES: es_out <= data;
            IP: ip_out <= data;
        endcase 
    end
    else
    case (reg_select)
        CS: Data_Segment <= cs_out;
        DS: Data_Segment <= ds_out;
        SS: Data_Segment <= ss_out;
        ES: Data_Segment <= es_out;
        IP: Data_Segment <= ip_out;
    endcase
        
    
end

endmodule
