/////////////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: testbench1
// Description: Banco de pruebas inicial para el sumador/multiplicador de punto flotante.
////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module testbench1;

    //Señales de entrada y salida del DUT
    //Entradas
    logic [31:0] Float_num_A;
    logic [31:0] Float_num_B;
    logic        OP_input;
    //Salida
    logic [31:0] Resultado;

    //Instancia del DUT
    top DUT(
    .Float_num_A(Float_num_A),
    .Float_num_B(Float_num_B),
    .OP_input(OP_input),
    .Resultado(Resultado)
    );

    //Archivo tipo log
    integer log_file;

    initial begin
        //Abrir archivo tipo log
        log_file = $fopen("Testbench1.log", "w");
        $fdisplay(log_file, "Time | Float_num_A | Float_num_B | OP_input | Resultado");
      
        //Caso de operadores en cero
        Float_num_A = 0;
        Float_num_B = 0;
        OP_input = 0;
        #200;

        /*
        Resultado ideal (0)
        0 00000000 00000000000000000000000
        Resultado simulacion
        0 00000000 00000000000000000000000
        */

        //Hacer una suma de números positivos
        OP_input = 1'b0; //Suma
        Float_num_A = 32'b01000000110101100000000000000000; //Bit de signo en 0, Exponente: 10000001 (129 en decimal), Número en decimal: 6.6875 
        Float_num_B = 32'b01000000011101110000000000000000; //Bit de signo en 0, Exponente: 10000000 (128 en decimal), Número en decimal: 3.859375
        #200;

        /*
        Resultado ideal (10.546875)
        0 10000010 01010001100000000000000
        Resultado simulacion
        0 10000010 01010001100000000000000
        */

        //Hacer una suma de números negativos
        OP_input = 1'b0; //Suma
        Float_num_A = 32'b11000000110101100000000000000000; //Bit de signo en 1, Exponente: 10000001 (129 en decimal), Número en decimal: 6.6875 
        Float_num_B = 32'b11000000011101110000000000000000; //Bit de signo en 1, Exponente: 10000000 (128 en decimal), Número en decimal: 3.859375
        #200;

        /*
        Resultado ideal (-10.546875)
        1 10000010 01010001100000000000000
        Resultado simulacion
        1 10000010 01010001100000000000000
        */

        //Hacer una resta
        OP_input = 1'b0; //Suma
        Float_num_A = 32'b01000000110101100000000000000000; //Bit de signo en 0, Exponente: 10000001 (129 en decimal), Número en decimal: 6.6875
        Float_num_B = 32'b11000000011101110000000000000000; //Bit de signo en 1, Exponente: 10000000 (128 en decimal), Número en decimal: 3.859375
        #200;

        /*
        Resultado ideal (2.828125)
        0 10000000 01101010000000000000000
        Resultado simulacion
        0 10000000 01101010000000000000000
        */

        //Hacer una multiplicación de números positivos
        OP_input = 1'b1; //Multiplicación
        Float_num_A = 32'b01000000101011100110011001100110; //Bit de signo en 0, Exponente: 10000001 (129 en decimal), Número en decimal: 5.45
        Float_num_B = 32'b01000000111011111010010111100011; //Bit de signo en 0, Exponente: 10000001 (129 en decimal), Número en decimal: 7.489
        #200;

        /*
        Resultado ideal (40.81505)
        0 10000100 01000110100001010011100
        Resultado simulacion
        0 10000100 01000110100001010011100
        */

        //Hacer una multiplicación de números negativos
        OP_input = 1'b1; //Multiplicación
        Float_num_A = 32'b11000000101011100110011001100110; //Bit de signo en 1, Exponente: 10000001 (129 en decimal), Número en decimal: 5.45
        Float_num_B = 32'b11000000111011111010010111100011; //Bit de signo en 1, Exponente: 10000001 (129 en decimal), Número en decimal: 7.489
        #200;

        /*
        Resultado ideal (40.81505)
        0 10000100 01000110100001010011100
        Resultado simulacion
        0 10000100 01000110100001010011100
        */

        //Hacer una multiplicación de números con distintos signo
        OP_input = 1'b1; //Multiplicación
        Float_num_A = 32'b01000000101011100110011001100110; //Bit de signo en 0, Exponente: 10000001 (129 en decimal), Número en decimal: 5.45
        Float_num_B = 32'b11000000111011111010010111100011; //Bit de signo en 1, Exponente: 10000001 (129 en decimal), Número en decimal: 7.489
        #200;

        /*
        Resultado ideal (-40.81505)
        1 10000100 01000110100001010011100
        Resultado simulacion
        1 10000100 01000110100001010011100
        */

        //Hacer una división
        OP_input = 1'b1; //Multiplicación
        Float_num_A = 32'b01000000101011100110011001100110; //Bit de signo en 0, Exponente: 10000001 (129 en decimal), Número en decimal: 5.45
        Float_num_B = 32'b00111111000000000000000000000000; //Bit de signo en 0, Exponente: 01111110 (126 en decimal), Número en decimal: 0.5
        #200;

        /*
        Resultado ideal (2.725)
        0 10000000 01011100110011001100110
        Resultado simulacion
        0 10000000 01011100110011001100110
        */

        //Cerrar archivo tipo log
        $fclose(log_file);
        $finish;
    end

    //Monitoreo de señales
    initial begin
        $monitor("Time: %3dns | Float_num_A: %b | Float_num_B: %b | OP_input: %b | Resultado: %b",
                 $time, Float_num_A, Float_num_B, OP_input, Resultado);
        forever begin
            #10;
            $fdisplay(log_file, "%3dns | %b | %b | %b | %b", 
                 $time, Float_num_A, Float_num_B, OP_input, Resultado);
        end
    end

endmodule