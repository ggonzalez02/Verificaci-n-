//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: register_bank_8088_tb
// Description: Testbench que muestra el cambio en las señales del banco de registros del microprocesador 8088
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module register_bank_8088_tb;

    // Señales de entrada y salida del DUT
    reg clk;
    reg reset;
    reg en_write;
    reg [2:0] reg_write;
    reg [15:0] write_data;
    reg [2:0] reg_read1;
    reg [2:0] reg_read2;
    reg size;
    reg select_high_low;
    wire [15:0] read_data1;
    wire [15:0] read_data2;
    
    // Instancia del módulo
    register_bank_8088 dut (
        .clk(clk),
        .reset(reset),
        .en_write(en_write),
        .reg_write(reg_write),
        .write_data(write_data),
        .reg_read1(reg_read1),
        .reg_read2(reg_read2),
        .size(size),
        .select_high_low(select_high_low),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // Generación del reloj
    initial begin
            
        clk = 0;
        forever #5 clk = ~clk; 
    end
    
    integer log_file;
    
    initial begin
    
        // Abrir archivo tipo log
        log_file = $fopen("register_bank_8088.log", "w");
        $fdisplay(log_file, "Time | reset | en_write | reg_write | write_data | size | high_low | read1 | read2");
        
        // Inicialización de señales
        reset = 1;
        en_write = 0;
        reg_write = 3'h0;
        write_data = 16'h0000;
        reg_read1 = 3'h0;
        reg_read2 = 3'h0;
        size = 1;
        select_high_low = 0;
        
        // Desactivar reset
        #20;
        reset = 0;
        #10;
        
        // Prueba 1: Escribir en AX
        en_write = 1;
        reg_write = 3'h0; 
        write_data = 16'hABCD;
        size = 1; // 16 bits
        #10;
        
        // Leer AX
        en_write = 0;
        reg_read1 = 3'h0; 
        #10;
        
        // Prueba 2: Escribir en BL
        en_write = 1;
        reg_write = 3'h1; 
        write_data = 16'h00EF; 
        size = 0; // 8 bits
        select_high_low = 0; // Parte baja
        #10;
        
        // Prueba 3: Escribir en BH
        write_data = 16'h0012; 
        select_high_low = 1; // Parte alta
        #10;
        
        // Leer BX
        en_write = 0;
        reg_read1 = 3'h1; 
        #10;
        
        // Prueba 4: Escribir en CX y DX 
        en_write = 1;
        reg_write = 3'h2; 
        write_data = 16'h3456;
        size = 1; 
        #10;
        
        reg_write = 3'h3; 
        write_data = 16'h789A;
        #10;
        
        // Leer CX y DX 
        en_write = 0;
        reg_read1 = 3'h2; 
        reg_read2 = 3'h3; 
        #10;
        
        // Prueba 5: Escribir en registros de puntero e índice
        en_write = 1;
        reg_write = 3'h4; // SP
        write_data = 16'hFFFC;
        #10;
        
        reg_write = 3'h5; // BP
        write_data = 16'hAABB;
        #10;
        
        reg_write = 3'h6; // SI
        write_data = 16'hCCDD;
        #10;
        
        reg_write = 3'h7; // DI
        write_data = 16'hEEFF;
        #10;
        
        // Leer 
        en_write = 0;
        reg_read1 = 3'h4; 
        reg_read2 = 3'h7; 
        #10;

        reg_read1 = 3'h5; 
        reg_read2 = 3'h6; 
        
        // Terminar la simulación
        #10;
        //Cerrar archivo tipo log
        $fclose(log_file);
        $finish;
    end
    
    // Monitoreo de señales
    initial begin
        $monitor("Time: %3dns | reset: %b | en_write: %b | reg_write: %h | write_data: %h | size: %b | high_low: %b | read1: %h | read2: %h",
                 $time, reset, en_write, reg_write, write_data, size, select_high_low, read_data1, read_data2);
        forever begin
            #10;
            $fdisplay(log_file, "%3dns | %b | %b | %h | %h | %b | %b | %h | %h", 
                      $time, reset, en_write, reg_write, write_data, size, select_high_low, read_data1, read_data2);
        end
    end

endmodule
