//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Buff_In_Out
// Description: Buffer de entrada y salida para el bus interno y el bus de datos
//////////////////////////////////////////////////////////////////////////////////

module Buff_In_Out (
    input clk,
    input rst,
    input Internal_RD_WR,   //0: Lectura (IRD), 1: Escritura (IWR)
    input RD_WR,            //0: Lectura (RD), 1: Escritura (WR)
    inout [7:0] DataBus,    //Bus de datos externo
    inout [7:0] InternalBus //Bus de datos interno
);
    //Multiplexor
    reg [7:0] out_mux;
    always @(InternalBus or DataBus or Internal_RD_WR) begin
        case (Internal_RD_WR)
            1'b0: out_mux = InternalBus;
            1'b1: out_mux = DataBus; 
        endcase
    end

    //Registro
    wire [7:0] out_reg;
    RegQ R1 (.clk(clk), .rst(rst), .EN(!Internal_RD_WR | RD_WR), .D(out_mux), (out_reg));

    //Buffers tri estado
    buffer_tri_state P1 (.in(out_reg), .EN(Internal_RD_WR), .out(DataBus));
    buffer_tri_state P2 (.in(out_reg), .EN(!RD_WR), .out(InternalBus));
    
endmodule