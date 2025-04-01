//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Banco_de_Registros
// Description: Módulo principal para el banco de registros 8088
//////////////////////////////////////////////////////////////////////////////////

module Banco_de_Registros (
    input clk,
    input reset,
    input [2:0] select_reg,
    input size,
    input select_high_low,
    input select_data_h_reg,
    input read_write,
    inout [15:0] data
);
  
    wire [15:0] enable_write;      // Señal del decodificador al banco de registros
    wire [15:0] reg_data_out;      // Datos de salida de los registros
    wire [15:0] data_in;           // Datos para escribir en los registros

    wire [7:0] AL, BL, CL, DL, AH, BH, CH, DH;
    wire [15:0] AX, BX, CX, DX, SI, DI, SP, BP;
    
    // Instancia del decodificador
    Decoder decoder (
        .select_reg(select_reg),
        .size(size),
        .select_high_low(select_high_low),
        .output_reg(enable_write)
    );

    // Buffer tristate para controlar la dirección de los datos
    assign data = (!read_write) ? reg_data_out : 16'bZ; // Si read_write=0, se activa la función de lectura
    assign data_in = data;                                  // Se conecta el bus a la entrada de datos
    
    // Instancia del banco de registros
    Registros registers (
        .clk(clk),
        .reset(reset),
        .en_write(enable_write),
        .data_in(data_in),
        .select_data_h_reg(select_data_h_reg),
        .AL(AL), .BL(BL), .CL(CL), .DL(DL),
        .AH(AH), .BH(BH), .CH(CH), .DH(DH),
        .AX(AX), .BX(BX), .CX(CX), .DX(DX),
        .SI(SI), .DI(DI), .SP(SP), .BP(BP)
    );
    
    // Instancia del multiplexor para lectura
    MUX mux (
        .size(size),
        .select_high_low(select_high_low),
        .reg0(AX), .reg1(BX), .reg2(CX), .reg3(DX),
        .reg4(SI), .reg5(DI), .reg6(SP), .reg7(BP),
        .sel_reg(select_reg),
        .data_out(reg_data_out)
    );

endmodule
