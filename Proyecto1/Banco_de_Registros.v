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
    input clk,              // Reloj
    input reset,            // Señal de reinicio
    input [2:0] select_reg, // Entrada de selección
    input size,             // Tamaño del dato (1: 16 bits, 0: 8 bits)
    input select_high_low,  // Seleccionar parte alta (1) o baja (0) de los registros de uso general
    input select_data_h_reg, // Selección de la parte baja (0) o alta (1) de data_in en los registros tipo H
    input read_write,       // Señal que habilita la escritura o lectura del registro
    inout [15:0] data       // Datos que se escriben o se leen de los registros (lectura: salida, escritura: entrada)
);
  
    // Variables internas
    wire [15:0] enable_write;    // Señal del decodificador al banco de registros
    wire [15:0] reg_data_out;    // Datos de salida de los registros (lectura)
    wire [15:0] data_in;         // Datos para escribir en los registros

    wire [7:0] AL, BL, CL, DL, AH, BH, CH, DH; // Registros de 8 bits
    wire [15:0] AX, BX, CX, DX, SI, DI, SP, BP; // Registros de 16 bits
    
    // Instancia del decodificador
    Decoder decoder (
        .select_reg(select_reg),
        .size(size),
        .select_high_low(select_high_low),
        .output_reg(enable_write)
    );

    // Buffer tristate para controlar la dirección de los datos
    assign data = (!read_write) ? reg_data_out : 16'bZ;   // Si read_write = 0, se activa la función de lectura, si es 1 se activa la escritura
    assign data_in = data;                                // Se conecta el bus a la entrada/salida de datos
    
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
