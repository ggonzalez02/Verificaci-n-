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

module testbench2;
    
    //Interfaz
    interfaz bfm();

    //Señales para hacer pruebas
    logic op_actual;
    logic [31:0] float_num_A_actual;
    logic [31:0] float_num_B_actual;
    logic [31:0] calculo;
    int indice;
    logic [31:0] resultado_esperado;

    //Instancia del DUT
    top DUT(
    .Float_num_A(bfm.Float_num_A),
    .Float_num_B(bfm.Float_num_B),
    .OP_input(bfm.OP_input),
    .Resultado(bfm.Resultado)
    );

    //Archivo tipo log
    integer log_file;

    //Waveform para pruebas en playground
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench2);
    end

    //Memoria que contiene valores aleatorios de prueba
    logic [31:0] mem [0:999];
    //Cargar datos en la memoria
    initial begin
        $readmemb("ieee754_reales.mem", mem);
    end

    //Obtener operacion aleatoria (suma o multiplicación)
    function logic operacion_aleatoria();
        logic op_aleatoria;
        op_aleatoria = $urandom;
        return op_aleatoria;
    endfunction

    //Scoreboard
    class Scoreboard;
        //Datos internos
        bit operacion_esperada;
        shortreal A, B;
        shortreal resultado_esperado;
        
        //Guardar el resultado esperado
        function logic [31:0] guardar(logic operacion, logic [31:0] float_num_A, logic [31:0] float_num_B);
            operacion_esperada = operacion;
            A = shortreal'(float_num_A);
            B = shortreal'(float_num_B);
            if (operacion_esperada == 0) begin
                resultado_esperado = A + B;
            end
            else begin
                resultado_esperado = A * B;
            end
            return $bitstoreal(resultado_esperado);
        endfunction

        //Verificar lectura de la operacion y el resultado
        function void revisar(logic op, logic [31:0] resultado, logic [31:0] resultado_esperado);
        //Verificar la operacion
        if (op == 0) begin
            if (operacion_esperada != op)
                $error("FALLO: Suma, Esperado: %0b, Obtenido: %0b", operacion_esperada, op);
        else begin
            if (operacion_esperada != op)
                $error("FALLO: Multiplicación, Esperado: %0b, Obtenido: %0b", operacion_esperada, op);
            end
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

        task entradas(logic op, logic [31:0] float_num_A, logic [31:0] float_num_B);
            bfm.OP_input = op;
            bfm.Float_num_A = float_num_A;
            bfm.Float_num_B = float_num_B;
        endtask
    endclass //Tester

    //Pruebas
    initial begin
        //Uso de las clases
        Scoreboard scoreboard;
        Tester tester;

        scoreboard = new();
        tester = new(bfm);

        // Abrir archivo tipo log
        log_file = $fopen("Testbench1.log", "w");
        $fdisplay(log_file, "Time | Float_num_A | Float_num_B | OP_input | Resultado");

        for (int i = 0; i < 10; i++) begin
            op_actual = operacion_aleatoria();
            //Obtener un número aleatorio para A
            indice = $urandom_range(0,999);
            float_num_A_actual = mem[indice];
            //Obtener un número aleatorio para B
            indice = $urandom_range(0,999);
            float_num_B_actual = mem[indice];
            tester.entradas(op_actual, float_num_A_actual, float_num_B_actual);
            resultado_esperado = scoreboard.guardar(op_actual, float_num_A_actual, float_num_B_actual);
            #5;
            calculo = bfm.Resultado;
            scoreboard.revisar(op_actual, calculo, resultado_esperado);
            #50;
        end

        //Resultados de los covergroups
        $display("=== COVERGROUPS RESULTADOS ===");
        $display("OP Coverage: %.2f%%", op_c.get_coverage());

        //Cerrar archivo tipo log
        $fclose(log_file);

        #50 $finish;
    end

    // Monitoreo de señales
    initial begin
        $monitor("Time: %3dns | Float_num_A: %b | Float_num_B: %b | OP_input: %b | Resultado: %b",
                 $time, bfm.Float_num_A, bfm.Float_num_B, bfm.OP_input, bfm.Resultado);
        forever begin
            #10;
            $fdisplay(log_file, "%3dns | %b | %b | %b | %b", 
                 $time, bfm.Float_num_A, bfm.Float_num_B, bfm.OP_input, bfm.Resultado);
        end
    end
    
    //Covergroups
    /*
    bins
    Acorde al valor de OP
    0: Sumar
    1: Multiplicar

    Acorde al signo de los operadores
    Signo A
    0: Positivo
    1: Negativo
    Signo B
    0: Positivo
    1: Negativo

    Acorde a los exponentes
    Float A
    Exponente mayor o igual a 127
    Exponente menor a 127
    Float B
    Exponente mayor o igual a 127
    Exponente menor a 127

    Acorde a los mantisas
    Float A
    Mantisa 0
    Mantisa no 0
    Float B
    Mantisa 0
    Mantisa no 0

    Acorde al orden de las operaciones
    Sumar -> Multiplicar
    Multiplicar -> Sumar
    */

    covergroup op_cover;
        //Sumas, multiplicaciones y transiciones entre ellas
        coverpoint bfm.OP_input{
            bins op_1 = {1'b0};
            bins op_2 = {1'b1};
            bins op_suma_mult = (1'b0 => 1'b1);
            bins op_mult_suma = (1'b1 => 1'b0);
        }
        //Valor de A como cero
        coverpoint bfm.Float_num_A{
            bins num_0 = {32'b00000000000000000000000000000000};
        }
        //Signo de A
        coverpoint bfm.Float_num_A [31]{
            bins num_positivo = {1'b0};
            bins num_negativo = {1'b1};
        }
        //Exponente de A
        coverpoint bfm.Float_num_A [30:23]{
            bins mayor_a_127 = {[127:255]};
            bins menor_a_127 = {[0:126]};
        }
        //Mantisa de A
        coverpoint bfm.Float_num_A [22:0]{
            bins mantisa_0 = {23'b00000000000000000000000};
            bins mantisa_no_0 = {[1:$]};
        }
        //Valor de B como cero
        coverpoint bfm.Float_num_B{
            bins num_0 = {32'b00000000000000000000000000000000};
        }
        //Signo de B
        coverpoint bfm.Float_num_B [31]{
            bins num_positivo = {1'b0};
            bins num_negativo = {1'b1};
        }
        //Exponente de B
        coverpoint bfm.Float_num_B [30:23]{
            bins mayor_a_127 = {[127:255]};
            bins menor_a_127 = {[0:126]};
        }
        //Mantisa de B
        coverpoint bfm.Float_num_B [22:0]{
            bins mantisa_0 = {23'b00000000000000000000000};
            bins mantisa_no_0 = {[1:$]};
        }
    endgroup

    op_cover op_c;

    initial begin
        op_c = new();
        forever begin
            #1;
            op_c.sample();
        end
    end

endmodule