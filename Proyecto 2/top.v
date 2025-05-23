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
    input [2:0] OP,                 //Tipo de direccionamiento a realizar
    input RD_WR_Regs,               //Señal de escritura-lectura para el banco de registros
    input [2:0] Reg_Write,          //Registro en el que se va a escribir en el banco de registros
    input [2:0] Reg1,               //Primer registro de lectura del banco de registros
    input [2:0] Reg2,               //Segundo registro de lectura del banco de registros
    input [15:0] Data_Regs,         //Datos a escribir en el banco de registros
    input [15:0] Relative,          //Relativo para usar en el direccionamiento
    input RD_WR_Segments,           //Señal de escritura-lectura para los registros de segmento
    input [1:0] Segment,            //Registro en el que se va a escribir en los registros de segmento
    input [15:0] Data_Segments,     //Datos a escribir en los registros de segmento
    input EN_IP,                    //Señal de habilitación para el registro IP
    input SEL_IP,                   //Selección del tipo de escritura para el registro IP
    input [7:0] IP,                 //Datos a escribir en el registro IP
    input EN,
    input Internal_RD_WR,           //Señal interna de escritura para el buffer de entrada y salida
    inout RD_WR,                    //Señal de escritura para el buffer de entrada y salida
    inout [7:0] Bus,                //Bus de datos para la interfaz
    inout [7:0] Data,               //Señal de datos para la interfaz
    output [31:0] Instruction,      //Señal de instrucción resultante
    output [19:0] Direction         //Señal de dirección resultante
);
    //Definicion de señales internas
    wire [15:0] Data_Reg1, Data_Reg2, Data_Segment, Data_IP;

    //Banco de registros
    register_bank Registers(.clk(clk), .reset(reset), .RD_WR(RD_WR_Regs), .reg_write(Reg_Write), .Data(Data_Regs),
                            .Reg1(Reg1), .Reg2(Reg2), .Data_Reg1(Data_Reg1), .Data_Reg2(Data_Reg2));
    
    //Segmentos
    segments Segments(.clk(clk), .rst(reset), .write_en(RD_WR_Segments), .reg_select(Segment),
                      .data(Data_Segments), .Data_Segment(Data_Segment));

    //Registro IP
    RegIP R_IP(.clk(clk), .rst(reset), .EN(EN_IP), .SEL(SEL_IP), .D(IP), .Q(Data_IP));

    //Queue
    queue Queue(.EN(EN), .clk(clk), .rst(reset), .data(Bus), .Data_Q(Instruction));

    //ALU
    ALU Dir(.OP(OP), .Relative(Relative), .Data_Segment(Data_Segment), .Data_IP(Data_IP),
            .Data_Reg1(Data_Reg1), .Data_Reg2(Data_Reg2), .Direction(Direction));

    //Buffer de entrada y salida
    Buff_In_Out Buffer(.clk(clk), .rst(reset), .Internal_RD_WR(Internal_RD_WR), .RD_WR(RD_WR), .DataBus(Data), .InternalBus(Bus));
    
endmodule
