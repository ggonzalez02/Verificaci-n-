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

    typedef enum bit { read = 1'b0, write = 1'b1 } operacion;
    bit FIN; // Señal para el scoreboard

//TESTER
    // Generación del reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

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

    // Cuerpo de Test
    initial begin: tester
        
    end: tester

//SCOREBOARD
    always@(posedge FIN) begin
        

    end: scoreboard

endmodule