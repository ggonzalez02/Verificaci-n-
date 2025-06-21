/////////////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: testbench2
// Description: Banco de pruebas con tester, scoreboard y covergroups para el sumador/multiplicador de punto flotante.
////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

`include "interface.sv"

module testbench2;
    
    //Interfaz
    interfaz bfm();

    //Señales para hacer pruebas
    logic op_actual;
    logic [31:0] float_num_A_actual;
    logic [31:0] float_num_B_actual;
    logic [31:0] calculo;

    //Instancia del DUT
    top DUT(
    .Float_num_A(bfm.Float_num_A),
    .Float_num_B(bfm.Float_num_B),
    .OP_input(bfm.OP_input),
    .Resultado(bfm.Resultado)
    );

    //Archivo tipo log
    integer log_file;

    initial begin
        // Para el wave form en playground
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench2);
    end

    //Obtener operacion aleatoria (suma o multiplicación)
    function logic operacion_aleatoria();
        logic op_aleatoria;
        op_aleatoria = $random;
        return op_aleatoria;
    endfunction

    //Obtener número aleatorio flotante
    function logic [31:0] numero_flotante_aleatorio();
        logic [31:0] num_flotante;
        num_flotante = $random;
        return num_flotante;
    endfunction

    //Scoreboard
    class Scoreboard;
        //Datos internos
        logic operacion_esperada;
        shortreal A, B;
        shortreal resultado_esperado;

        //Guardar el resultado esperado
        function void guardar(input operacion, input [31:0] float_num_A, input [31:0] float_num_B);
            operacion_esperada = operacion;
            A = $bitstoreal(float_num_A);
            B = $bitstoreal(float_num_B);
            if (operacion_esperada == 0) begin
                resultado_esperado = A + B;
                resultado_esperado = $realtobits(resultado_esperado);
            end
            else begin
                resultado_esperado = A * B;
                resultado_esperado = $realtobits(resultado_esperado);
            end
        endfunction

        //Verificar lectura de la operacion y el resultado
        function void revisar(op, resultado);
        //Verificar la operacion
        if (op == 0) begin
            if (operacion_esperada != op)
                $error("FALLO: Suma: %0h, Esperado: %0h, Obtenido: %0h", expected_data, data_pin);
        end
        else begin
            if (operacion_esperada != op);
        end
        //Verificar el resultado
        if (resultado_esperado != resultado)
            $error("FALLO: Resultado esperado: %0b, Resultado obtenido: %0b", resultado_esperado, resultado);

        endfunction
    endclass //Scoreboard

    //Tester
    class Tester;
        //Datos internos
        virtual interfaz bfm;

        function new(virtual interfaz p_bfm);
            bfm = p_bfm;
        endfunction

        task entradas(input op, input [31:0] float_num_A, input [31:0] float_num_B);
            bfm.OP_input = op;
            bfm.Float_num_A = float_num_A;
            bfm.Float_num_B = float_num_B;
        endtask


    endclass //Tester

    //Pruebas
    initial begin
        //Uso de las clases
        ScoreBoard scoreboard;
        Tester tester;

        scoreboard = new();
        tester = new(bfm);
        
        // Abrir archivo tipo log
        log_file = $fopen("Testbench1.log", "w");
        $fdisplay(log_file, "Time | Float_num_A | Float_num_B | OP_input | Resultado");

        for (int i = 0; i < 10; i++) begin
            op_actual = operacion_aleatoria();
            float_num_A_actual = numero_flotante_aleatorio();
            float_num_B_actual = numero_flotante_aleatorio();
            tester.entradas(op_actual, float_num_A_actual, float_num_B_actual);
            scoreboard.scoreboard_guardar();
            #100;
        end

    end

    // Monitoreo de señales
    initial begin
        $monitor("Time: %3dns | Float_num_A: %b | Float_num_B: %b | OP_input: %b | Resultado: %b",
                 $time, Float_num_A, Float_num_B, OP_input, Resultado);
        forever begin
            #10;
            $fdisplay(log_file, "%3dns | %b | %b | %b | %b", 
                 $time, Float_num_A, Float_num_B, OP_input, Resultado);
        end
    end
    
    //Covergroups
    /*
    bins
    Acorde al valor de OP
    0: Sumar
    1: Multiplicar

    Acorde al signo de los operadores
    Signo A         Signo B
    0: Positivo,    0: Positivo
    1: Negativo,    1: Negativo
    0: Positivo,    1: Negativo
    1: Negativo,    0: Positivo

    Acorde a los exponentes
    Float A             Float B
    Exponente grande,   Exponente grande
    Exponente pequeño,  Exponente pequeño
    Exponente grande,   Exponente pequeño
    Exponente pequeño,  Exponente pequeño

    Acorde a los mantisas
    Float A             Float B
    Mantisa 0,          Mantisa 0
    Mantisa 0,          Mantisa no 0
    Mantisa no 0,       Mantisa 0
    Mantisa grande,     Mantisa grande
    Mantisa pequeña,    Mantisa pequeña
    Mantisa grande,     Mantisa pequeña
    Mantisa pequeña,    Mantisa grande

    Acorde al orden de las operaciones
    Sumar -> Sumar
    Multiplicar -> Multiplicar
    Sumar -> Multiplicar
    Multiplicar -> Sumar
    */
    
    covergroup op_cover;
        coverpoint bfm.OP{
            bins op_1 = {1'b0};
            bins op_2 = {1'b1};
            bins op_suma_mult = (1'b0 => 1'b1);
            bins op_mult_suma = (1'b1 => 1'b0);
        }
        coverpoint bfm.Float_num_A{
            bins num_0 = {32'b00000000000000000000000000000000};
            bins num_positivo = {32'b0XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX};
            bins num_negativo = {32'b1XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX};
        }
        coverpoint bfm.Float_num_B{
            bins num_0 = {32'b00000000000000000000000000000000};
            bins num_positivo = {32'b0XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX};
            bins num_negativo = {32'b1XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX};
        }
    endgroup

    op_cover op_c;

    initial begin
        op_c = new();
        forever begin
            op_c.sample();
            #100;
        end
    end

endmodule