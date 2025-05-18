//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: top
// Description: Módulo top de la interfaz
//////////////////////////////////////////////////////////////////////////////////

module top (
    input clk,
    input reset,
    input [2:0] OP,
    input RD_WR_Regs,
    input [2:0] Reg_Write,
    input [2:0] Reg1,
    input [2:0] Reg2,
    input [15:0] Data_Regs,
    input [15:0] Relative,
    input RD_WR_Segments,
    input [1:0] Segment,
    input [15:0] Data_Segments,
    input EN_IP,
    input SEL_IP,
    input [7:0] IP,
    input Internal_RD_WR,
    inout RD_WR,
    inout [7:0] Bus,
    inout [7:0] Data,
    output [31:0] Instruction,
    output [19:0] Direction
);
    //Definicion de señales internas
    wire [15:0] Data_Reg1, Data_Reg2, Data_Segment, Data_IP;

    //Banco de registros
    register_bank Registers(.clk(clk), .reset(reset), .RD_WR(RD_WR_Regs), .reg_write(Reg_Write), .Data(Data_Regs),
                            .Reg1(Reg1), .Reg2(Reg2), .Data_Reg1(Data_Reg1), .Data_Reg2(Data_Reg1));
    
    //Segmentos
    segments Segments(.clk(clk), .rst(reset), .write_en(RD_WR_Segments), .reg_select(Segment), .data(Data_Segments), .Data_Segment(Data_Segment));

    //Registro IP
    RegIP IP(.clk(clk), .rst(reset), .EN(EN_IP), .SEL(SEL_IP), .D(IP), .Q(Data_IP));

    //Queue
    queue Queue(.EN(), .clk(clk), .rst(reset), .data(Bus), .Data_Q(Instruction));

    //ALU
    ALU Dir(.OP(OP), .Relative(Relative), .Data_Segment(Data_Segment), .Data_IP(Data_IP), .Data_Reg1(Data_Reg1), .Data_Reg2(Data_Reg2), .Direction(Direction));

    //Buffer de entrada y salida
    Buff_In_Out Buffer(.clk(clk), .rst(reset), .Internal_RD_WR(Internal_RD_WR), .RD_WR(RD_WR), .DataBus(Data), .InternalBus(Bus));
    
endmodule