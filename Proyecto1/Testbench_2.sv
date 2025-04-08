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

    // Señales de entrada y salida del DUT
    bit clk;
    bit reset;
    bit [2:0] select_reg;
    bit size;
    bit select_high_low;
    bit select_data_h_reg;
    bit read_write;
    bit [15:0] data;
    
    // Instancia del módulo
    Banco_de_Registros dut (
        .clk(clk),
        .reset(reset),
        .select_reg(select_reg),
        .size(size),
        .select_high_low(select_high_low),
        .select_data_h_reg(select_data_h_reg),
        .read_write(read_write),
        .data(data)
    );

    typedef enum bit { read = 1'b0, write = 1'b1 } operacion;
    bit FIN; // Señal para el scoreboard

//TESTER
    // Generación del reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    integer log_file; // Declaración del archivo log

    // Función para definir operación
    function operacion obtener_operacion();
        bit tipo_op;
        tipo_op = $random;
        case(tipo_op)
            1'b1: return write;
            1'b0: return read; 
        endcase
    endfunction: obtener_operacion

    // Función para elegir el registro en el que se va a escribir o leer
    function bit[2:0] obtener_registro();
        bit[2:0] registro;
        registro = $random;
        return registro;
    endfunction: obtener_registro

    // Función para elegir un registro que se encuentre en el rango de los disponibles de 8 bits
    function bit[2:0] obtener_registro_bajo();
        bit[2:0] registro;
        registro = {$random} % 3;
        return registro;
    endfunction: obtener_registro_bajo

    // Función para elegir el dato que se va escribir en el registro
    function bit[15:0] obtener_dato();
        bit[15:0] dato;
        dato = $random;
        return dato;
    endfunction: obtener_dato

    // Función para elegir si escribir en un registro de 8 o 16 bits
    function bit obtener_tamano();
        bit tamano;
        tamano = $random;
        return tamano;
    endfunction: obtener_tamano

    //Función para elegir si escribir en la parte alta o baja del registro
    function bit seleccionar_parte_alta_baja();
        bit parte_alta_baja;
        parte_alta_baja = $random;
        return parte_alta_baja;
    endfunction: seleccionar_parte_alta_baja

    //Función para seleccionar los datos que se van a escribir en la parte alta del registro
    function bit seleccionar_datos_registro_h();
        bit datos_registro_h;
        datos_registro_h = $random;
        return datos_registro_h;
    endfunction: seleccionar_datos_registro_h

    // Cuerpo de Test
    initial begin: tester
        // Abrir archivo tipo log
        log_file = $fopen("Banco_de_Registros_tb_2.log", "w");
        $fdisplay(log_file, "Time | reset | select_reg | size | select_high_low | select_data_h_reg | read_write | data");
        
        // Inicialización de señales
        reset = 1;
        select_reg = 3'h0;
        size = 1;
        select_high_low = 0;
        select_data_h_reg = 0;
        read_write = 0;
        data = 16'h0000;

        // Desactivar reset
        #20;
        reset = 0;
        #10;

        // Testeo
        repeat(3) begin
            @(negedge clk);
            read_write = obtener_operacion();

            if (read_write == write) begin
                data = obtener_dato();
                size = obtener_tamano();

                if (size == 0) begin
                    if (select_reg > 3) begin
                        select_reg = obtener_registro_bajo();
                    end
                    else begin
                        select_reg = obtener_registro();
                        select_high_low = seleccionar_parte_alta_baja();
                        select_data_h_reg = seleccionar_datos_registro_h();
                    end
                end
            end
            else begin
                select_reg = obtener_registro();

                FIN = 1;
                #1;
                FIN = 0;
            end
        end

    end: tester

//SCOREBOARD

    always@(posedge FIN) begin: scoreboard
        bit [15:0] expected_data;
        expected_data = 16'h0000;

        // Calcular el valor esperado
        if (read_write == 1) begin
            if (size == 1) begin // Escritura de 16 bits
                expected_data = data;
            end 
            else begin // Escritura de 8 bits
                if (select_high_low == 0) begin
                        expected_data[7:0] = data[7:0];
                    end
                    else begin 
                        expected_data[15:8] = data[7:0];
                    end
            end
        end
    
        // Verificar lectura del registro
        if (expected_data != data)
            $error("FALLO: Reg1: %0h, Esperado: %0h, Obtenido: %0h", 
                select_reg, expected_data, data);

    end: scoreboard


// Monitoreo de señales
    initial begin
        $monitor("Time: %3dns | reset: %b | select_reg: %b | size: %h | select_high_low: %h | select_data_h_reg: %b | read_write: %b | data: %h",
                 $time, reset, select_reg, size, select_high_low, select_data_h_reg, read_write, data_pin);
        forever begin
            #10;
            $fdisplay(log_file, "%3dns | %b | %b | %h | %h | %b | %b | %h | %h", 
                      $time, reset, select_reg, size, select_high_low, select_data_h_reg, read_write, data_pin);
        end
    end

endmodule