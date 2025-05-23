//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Testbench_1
// Description: Testbench sencillo en SystemVerilog para observar cómo cambian
//              las señales del módulo de interfaz del 8088
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module Testbench_1;

    // Señales de entrada y salida del DUT
    reg clk;
    reg reset;
    reg [2:0] OP;
    reg RD_WR_Regs;
    reg [2:0] Reg_Write;
    reg [2:0] Reg1;
    reg [2:0] Reg2;
    reg [15:0] Data_Regs;
    reg [15:0] Relative;
    reg RD_WR_Segments;
    reg [1:0] Segment;
    reg [15:0] Data_Segments;
    reg EN_IP;
    reg SEL_IP;
    reg [7:0] IP;
    reg EN;
    reg Internal_RD_WR;

    // Control de señales bidireccionales para Bus, Data y RD_WR
    reg RD_WR_drive;
    reg [7:0] Bus_drive;
    reg [7:0] Data_drive;
    reg drive_RD_WR;
    reg drive_Bus;

    wire RD_WR;
    wire [7:0] Bus;
    wire [7:0] Data;
    
    // Asignación de las señales bidireccionales
    assign RD_WR = drive_RD_WR ? RD_WR_drive : 1'bz;        
    assign Bus = drive_Bus ? Bus_drive : 8'bzzzzzzzz;       
    
    wire [31:0] Instruction;
    wire [19:0] Direction;

    // Instancia del módulo
    top DUT (
        .clk(clk),
        .reset(reset),
        .OP(OP),
        .RD_WR_Regs(RD_WR_Regs),
        .Reg_Write(Reg_Write),
        .Reg1(Reg1),
        .Reg2(Reg2),
        .Data_Regs(Data_Regs),
        .Relative(Relative),
        .RD_WR_Segments(RD_WR_Segments),
        .Segment(Segment),
        .Data_Segments(Data_Segments),
        .EN_IP(EN_IP),
        .SEL_IP(SEL_IP),
        .IP(IP),
        .EN(EN),
        .Internal_RD_WR(Internal_RD_WR),
        .RD_WR(RD_WR),
        .Bus(Bus),
        .Data(Data),
        .Instruction(Instruction),
        .Direction(Direction)
    );

    // Generación del reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    integer log_file; 

    initial begin
        // Abrir archivo tipo log
        log_file = $fopen("Testbench_1.log", "w");
        $fdisplay(log_file, "Time | reset | OP | RD_WR_Regs | Reg_Write | EN_IP | Internal_RD_WR | Direction");
      
        // Inicialización de señales
        reset = 1;
        OP = 0;
        RD_WR_Regs = 0;
        Reg_Write = 0;
        Reg1 = 0;
        Reg2 = 0;
        Data_Regs = 0;
        Relative = 0;
        RD_WR_Segments = 0;
        Segment = 0;
        Data_Segments = 0;
        EN_IP = 0;
        SEL_IP = 0;
        IP = 0;
        EN = 0;
        Internal_RD_WR = 0;
       
        drive_RD_WR = 1;
        drive_Bus = 1;
        RD_WR_drive = 0;
        Bus_drive = 8'h00;
        Data_drive = 8'h00;
        
        // Desactivar reset
        #20; reset = 0;
        #10;
        
        // Escribir en registros
        RD_WR_Regs = 1;
        
        // Escribir en AX 
        Reg_Write = 3'b000;
        Data_Regs = 16'h1234;
        #20;
        
        // Escribir en BX
        Reg_Write = 3'b001;
        Data_Regs = 16'h5678;
        #20;
        
        // Escribir en CX
        Reg_Write = 3'b010;
        Data_Regs = 16'hABCD;
        #20;
        
        // Escritura inhabilitada
        RD_WR_Regs = 0;
        #10;
        
        // Escritura en los registros de segmento
        RD_WR_Segments = 1;
        
        // DS
        Segment = 2'b01;
        Data_Segments = 16'h2000;
        #20;
        
        // CS
        Segment = 2'b00;
        Data_Segments = 16'h1000;
        #20;
        
        // Lectura en los registros de segmento
        RD_WR_Segments = 0;
        #10;
        
        // Configuración de IP
        // Escribir en Q y en Data In
        EN_IP = 1;
        SEL_IP = 1;
        IP = 8'h10;
        #20;
        // Mantener Q
        EN_IP = 0;
        #10;
        
        // Cargar datos en Queue
        EN = 1; // Habilitar queue
        drive_Bus = 1; // Controlar Bus
        
        // Cargar datos en el bus
        @(posedge clk);
        Bus_drive = 8'hA1;
        @(posedge clk);
        Bus_drive = 8'hB2;
        @(posedge clk);
        Bus_drive = 8'hC3;
        @(posedge clk);
        Bus_drive = 8'hD4;
        @(posedge clk);
        
        EN = 0; // Deshabilitar queue
        Bus_drive = 8'h00;
        #20; 
        
        // Desactivar señales bidireccionales
        drive_Bus = 0;   
        #10;
        drive_RD_WR = 0; 
        #10;
        
        // Prueba de los modos de direccionamiento
        Reg1 = 3'b000; // AX
        Reg2 = 3'b001; // BX
        Relative = 16'h0100;
        Segment = 2'b01; // DS
        
        // Segmento + IP
        OP = 3'b000;
        #20;
        
        // Segmento + Relativo
        OP = 3'b001;
        #20;
        
        // Segmento + Reg1
        OP = 3'b010;
        #20;
        
        // Segmento + Reg1 + Relativo
        OP = 3'b011;
        #20;
        
        // Segmento + Reg1 + Reg2
        OP = 3'b100;
        #20;
        
        // Segmento + Reg1 + Reg2 + Relativo
        OP = 3'b101;
        #20;
        
        // Aumentar IP
        EN_IP = 1; // Escribir en Q
        SEL_IP = 0; // Sumar 1 a Q
        #20;
        EN_IP = 0; // Mantener Q
        #10;
        
        //Cerrar archivo tipo log
        $fclose(log_file);
        $finish;
    end

    // Monitoreo de señales
    initial begin
        $monitor("Time: %3dns | reset: %b | OP: %b | RD_WR_Regs: %b | Reg_Write: %b | EN_IP: %b | Internal_RD_WR: %b | Direction: %h",
                 $time, reset, OP, RD_WR_Regs, Reg_Write, EN_IP, Internal_RD_WR, Direction);
        forever begin
            #10;
            $fdisplay(log_file, "%3dns | %b | %b | %b | %b | %b | %b | %h", 
                 $time, reset, OP, RD_WR_Regs, Reg_Write, EN_IP, Internal_RD_WR, Direction);
        end
    end

endmodule
