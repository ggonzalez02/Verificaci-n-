//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Banco_de_Registros_tb_2
// Description: Tester y ScoreBoard
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Banco_de_Registros_tb_2;

    //Enum's para debuguear más fácilmente
    typedef enum reg { leer = 1'b0, escribir = 1'b1 } operacion; //Lectura o escritura para señal read_write
    typedef enum reg { _8bits = 1'b0, _16bits = 1'b1 } tamano; //8 o 16 bits para señal size
    typedef enum reg { parte_baja = 1'b0, parte_alta = 1'b1 } parte_alta_baja;
    typedef enum reg { registro_bajo = 1'b0, registro_alto = 1'b1 } datos_registro_h;

    // Señales de entrada y salida del DUT
    reg clk;
    reg reset;
    reg [2:0] select_reg;
    tamano size;
    parte_alta_baja select_high_low;
    datos_registro_h select_data_h_reg;
    operacion read_write;
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

    // Señales para el scoreboard
    bit GUARDAR;
    bit REVISAR;
    reg [15:0] expected_data = 16'h0000;

//TESTER
    // Generación del reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    integer log_file; // Declaración del archivo log

    // Función para elegir el registro en el que se va a escribir o leer
    function reg[2:0] obtener_registro();
        reg[2:0] registro;
        registro = $random;
        return registro;
    endfunction: obtener_registro

    // Función para elegir un registro que se encuentre en el rango de los disponibles de 8 bits
    function reg[2:0] obtener_registro_bajo();
        reg[2:0] reg_bajo;
        reg_bajo = {$random} % 3;
        return reg_bajo;
    endfunction: obtener_registro_bajo

    // Función para elegir el dato que se va escribir en el registro
    function reg[15:0] obtener_dato();
        reg[15:0] dato;
        dato = $random;
        return dato;
    endfunction: obtener_dato

    // Función para elegir si escribir en un registro de 8 o 16 bits
    function tamano obtener_tamano();
        reg tam;
        tam = $random;
        case(tam)
            1'b0: return _8bits;
            1'b1: return _16bits;
        endcase
    endfunction: obtener_tamano

    //Función para elegir si escribir en la parte alta o baja del registro
    function parte_alta_baja seleccionar_parte_alta_baja();
        reg alta_baja;
        alta_baja = $random;
        case(alta_baja)
            1'b0: return parte_baja;
            1'b1: return parte_alta;
        endcase
    endfunction: seleccionar_parte_alta_baja

    //Función para seleccionar los datos que se van a escribir en la parte alta del registro
    function datos_registro_h seleccionar_datos_registro_h();
        reg registro_h;
        registro_h = $random;
        case(registro_h)
            1'b0: return registro_bajo;
            1'b1: return registro_alto; 
        endcase
    endfunction: seleccionar_datos_registro_h

    // Cuerpo de Test
    initial begin: tester
        // Abrir archivo tipo log
        log_file = $fopen("Banco_de_Registros_tb_2.log", "w");
        $fdisplay(log_file, "Time | reset | select_reg | size | select_high_low | select_data_h_reg | read_write | data");
        
        // Inicialización de señales
        reset = 1;
        select_reg = 3'h0;
        size = _16bits;
        select_high_low = parte_baja;
        select_data_h_reg = registro_bajo;
        read_write = leer;
        data_drive = 16'h0000;

        // Desactivar reset
        #20;
        reset = 0;
        #10;

        // Testeo
        repeat(3) begin
            @(negedge clk);

            //Escribir en algún registro aleatorio
            read_write = escribir;
            data_drive = obtener_dato();
            size = obtener_tamano();

            if (size == _8bits) begin
                if (select_reg > 3) begin
                    select_reg = obtener_registro_bajo();
                end
                else begin
                    select_reg = obtener_registro();
                end
            end
            else begin
                select_reg = obtener_registro();
            end
            select_high_low = seleccionar_parte_alta_baja();
            select_data_h_reg = seleccionar_datos_registro_h();
            
            GUARDAR = 1;
            #1;
            GUARDAR = 0;
            #20;

            //Leer el registro en el que se escribió
            read_write = leer;
            select_reg = select_reg;
            select_high_low = select_high_low;
            select_data_h_reg = select_data_h_reg;
            
            REVISAR = 1;
            #1;
            REVISAR = 0;
            #20;
        end

    end: tester

//SCOREBOARD

    always@(posedge GUARDAR) begin: scoreboard_guardar
        
        //Guardar el valor esperado
        if (size == _16bits) begin // Escritura de 16 bits
                expected_data = data_drive;
            end 
            else begin // Escritura de 8 bits
                if (select_high_low == parte_baja) begin
                        expected_data[7:0] = data_drive[7:0];
                    end
                    else begin 
                        expected_data[15:8] = data_drive[7:0];
                    end
            end

    end: scoreboard_guardar

    always@(posedge REVISAR) begin: scoreboard_revisar

        // Verificar lectura del registro
        if (expected_data != data_pin)
            $error("FALLO: Reg: %0h, Esperado: %0h, Obtenido: %0h", 
                select_reg, expected_data, data_pin);

    end: scoreboard_revisar

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