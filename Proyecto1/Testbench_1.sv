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
    reg clk,
    reg reset,
    reg [2:0] select_reg,
    reg size,
    reg select_high_low,
    reg select_data_h_reg,
    reg read_write,
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
    
    integer log_file;
    
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
        data_drive 16'h0000;
        
        // Desactivar reset
        #20;
        reset = 0;
        #10;
        
        // Prueba 1: Escribir en AX
        read_write = 1;
        select_reg = 3'h0;
        data_drive = 16'hABCD;
        size = 1; // 16 bits
        #10;
        
        // Leer AX
        read_write = 0;
        select_reg = 3'h0; 
        #10;
        
        // Prueba 2: Escribir en BL
        read_write = 1;
        select_reg = 3'h1; 
        data_drive = 16'h00EF; 
        size = 0; // 8 bits
        select_high_low = 0; // Parte baja
        #10;
        
        // Prueba 3: Escribir en BH
        data_drive = 16'h0012; 
        select_high_low = 1; // Parte alta
        #10;
        
        // Leer BX
        read_write = 0;
        select_reg = 3'h1; 
        #10;
        
        // Prueba 4: Escribir en CX y DX 
        read_write = 1;
        select_reg = 3'h2; 
        data_drive = 16'h3456;
        size = 1; 
        #10;
        
        select_reg = 3'h3; 
        data_drive = 16'h789A;
        #10;
        
        // Leer CX y DX 
        read_write = 0;
        select_reg = 3'h2; // CX
        #10;

        reg_read2 = 3'h3; // DX
        #10;
        
        // Prueba 5: Escribir en registros de puntero e índice
        read_write = 1;
        select_reg = 3'h4; // SP
        data_drive = 16'hFFFC;
        #10;
        
        select_reg = 3'h5; // BP
        data_drive = 16'hAABB;
        #10;
        
        select_reg = 3'h6; // SI
        data_drive = 16'hCCDD;
        #10;
        
        select_reg = 3'h7; // DI
        data_drive = 16'hEEFF;
        #10;
        
        // Leer 
        read_write = 0;
        select_reg = 3'h4;
        #10;

        select_reg = 3'h7; 
        #10;

        select_reg = 3'h5;
        #10;
         
        select_reg = 3'h6; 
        
        // Terminar la simulación
        #10;
        //Cerrar archivo tipo log
        $fclose(log_file);
        $finish;
    end
    
    // Monitoreo de señales
    initial begin
        "Time | reset | select_reg | size | select_high_low | select_data_h_reg | read_write | data"
        $monitor("Time: %3dns | reset: %b | select_reg: %b | size: %h | select_high_low: %h | select_data_h_reg: %b | read_write: %b | data: %h",
                 $time, reset, select_reg, size, select_high_low, select_data_h_reg, read_write, data_pin);
        forever begin
            #10;
            $fdisplay(log_file, "%3dns | %b | %b | %h | %h | %b | %b | %h | %h", 
                      $time, reset, select_reg, size, select_high_low, select_data_h_reg, read_write, data_pin);
        end
    end

endmodule