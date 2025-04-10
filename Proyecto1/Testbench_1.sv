//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Banco_de_Registros_tb
// Description: Testbench que muestra el cambio en las señales del banco de registros del microprocesador 8088
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Banco_de_Registros_tb;

    // Señales de entrada y salida del DUT
    reg clk;
    reg reset;
    reg [2:0] select_reg;
    reg size;
    reg select_high_low;
    reg select_data_h_reg;
    reg read_write;
    wire [15:0] data_pin;   // Señal direccional para el DUT
    reg [15:0] data_drive;  // Señal local

    assign data_pin = data_drive;
    
    // Instancia del módulo
    Banco_de_Registros dut (
        .clk(clk),
        .reset(reset),
        .select_reg(select_reg),
        .size(size),
        .select_high_low(select_high_low),
        .select_data_h_reg(select_data_h_reg),
        .read_write(read_write),
        .data(data_pin)
    );
    
    // Generación del reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
    
    integer log_file; // Declaración del archivo log
    
    initial begin
    
        // Abrir archivo tipo log
        log_file = $fopen("Banco_de_Registros_tb.log", "w");
        $fdisplay(log_file, "Time | reset | select_reg | size | select_high_low | select_data_h_reg | read_write | data");
        
        // Inicialización de señales
        reset = 1;
        select_reg = 3'h0;
        size = 1;
        select_high_low = 0;
        select_data_h_reg = 0;
        read_write = 0;
        data_drive = 16'h0000;
        
        // Desactivar reset
        #20;
        reset = 0;
        #10;
        
        // Prueba 1: Escribir en AX
        read_write = 1;
        select_reg = 3'h0;
        data_drive = 16'hABCD;
        size = 1; // 16 bits
        #20;
        
        // Leer AX
        read_write = 0;
        select_reg = 3'h0; 
        #20;
        
        // Prueba 2: Escribir en BL
        read_write = 1;
        select_reg = 3'h1; 
        data_drive = 16'h00EF; 
        size = 0; // 8 bits
        select_high_low = 0; // Parte baja
        #20;
        
        // Prueba 3: Escribir en BH
        data_drive = 16'h0012; 
        select_high_low = 1; // Parte alta
        select_data_h_reg = 0; // Introducir los valores del 7:0 en la parte alta
        #20;
        
        // Leer BX
        read_write = 0;
        select_reg = 3'h1;
        size = 1; // 16 bits
        #20;
        
        // Prueba 4: Escribir en CX y DX
        // CX
        read_write = 1;
        select_reg = 3'h2; 
        data_drive = 16'h3456;
        size = 1; 
        #20;
        // DX
        read_write = 1;
        select_reg = 3'h3; 
        data_drive = 16'h789A;
        #20;
        
        // Leer CX y DX
        // CX
        read_write = 0;
        select_reg = 3'h2; // CX
        #20;
        // DX
        read_write = 0;
        select_reg = 3'h3; // DX
        #20;
        
        // Prueba 5: Escribir en registros de puntero e índice
        // SP
        read_write = 1;
        select_reg = 3'h4; // SP
        data_drive = 16'hFFFC;
        #20;
        // BP
        select_reg = 3'h5; // BP
        data_drive = 16'hAABB;
        #20;
        // SI
        select_reg = 3'h6; // SI
        data_drive = 16'hCCDD;
        #20;
        // DI
        select_reg = 3'h7; // DI
        data_drive = 16'hEEFF;
        #20;
        
        // Leer 
        // SP
        read_write = 0;
        select_reg = 3'h4;
        #20;
        // DI
        select_reg = 3'h7; 
        #20;
        // BP
        select_reg = 3'h5;
        #20;
        // SI
        select_reg = 3'h6; 
        
        // Terminar la simulación
        #20;
        //Cerrar archivo tipo log
        $fclose(log_file);
        $finish;
    end
    
    // Monitoreo de señales
    initial begin
        $monitor("Time: %3dns | reset: %b | select_reg: %b | size: %b | select_high_low: %b | select_data_h_reg: %b | read_write: %b | data: %h",
                 $time, reset, select_reg, size, select_high_low, select_data_h_reg, read_write, data_pin);
        forever begin
            #10;
            $fdisplay(log_file, "%3dns | %b | %b | %b | %b | %b | %b | %h", 
                 $time, reset, select_reg, size, select_high_low, select_data_h_reg, read_write, data_pin);
        end
    end

endmodule