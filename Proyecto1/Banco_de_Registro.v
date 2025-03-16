//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: register_bank_8088
// Description: Banco de registros del microprocesador 8088
//////////////////////////////////////////////////////////////////////////////////

module register_bank_8088(
    input clk
    input reset
    input wire en_write,           // 1: Habilita escritura, 0: Escritura inhabilitada
    input wire [3:0] reg_write,    // Registro a escribir
    input wire [15:0] write_data,  // Datos a escribir
    input wire [3:0] reg_read1,    // Primer registro de lectura
    input wire [3:0] reg_read2,    // Segundo registro de lectura
    input wire size,               // Tamaño del registro (0: 8 bits, 1: 16 bits)
    input wire select_high_low,    // Selección de XH o XL (0: parte baja, 1: parte alta )
    output wire [15:0] read_data1, // Datos leídos del primer registro
    output wire [15:0] read_data2  // Datos leídos del segundo registro

);
    // Registros de Uso General
    reg[15:0] AX, BX, CX, DX;

    // Registros Punteros y de Índice
    reg[15:0] SP, BP, SI, DI, IP;

    // Registro de Banderas
    reg[15:0] FLAGS;

    // Registros de Segmento
    reg[15:0] CS, DS, PS, ES;

    always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Inicializar todos los registros
        AX <= 16'h0000; BX <= 16'h0000; CX <= 16'h0000; DX <= 16'h0000; SP <= 16'h0000; 
        BP <= 16'h0000; SI <= 16'h0000; DI <= 16'h0000; IP <= 16'h0000; FLAGS <= 16'h0000; 
        CS <= 16'h0000; DS <= 16'h0000; PS <= 16'h0000; ES <= 16'h0000;
        end
    end

endmodule
