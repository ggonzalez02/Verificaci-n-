//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: register_bank_8088_tb_2
// Description: Tester, ScoreBoard y Cover Groups
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module register_bank_8088_tb_2;

    // Señales de entrada y salida del DUT
    bit clk;
    bit reset;
    bit en_write;
    bit [2:0] reg_write;
    bit [15:0] write_data;
    bit [2:0] reg_read1;
    bit [2:0] reg_read2;
    bit size;
    bit select_high_low;
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
        en_write = 0;
        reg_write = 0;
        write_data = 0;
        reg_read1 = 0;
        reg_read2 = 0;
        size = 0;
        select_high_low = 0;
        reset = 1;
        @(negedge clk);
        reset = 0;

            //Testing    
            repeat(3) begin
                @(negedge clk);
                en_write = obtener_operacion();

                if (en_write == write) begin
                    reg_write = obtener_registro();
                    write_data = obtener_dato();
                    size = obtener_tamano();

                    if (size == 0) begin
                        if (reg_write > 3) begin
                            reg_write = obtener_registro();
                        end
                        else begin
                            select_high_low = seleccionar_parte_alta_baja();
                        end
                    end
                end
                else begin
                    reg_read1 = obtener_registro();
                    reg_read2 = obtener_registro();

                    FIN = 1;
                    #1;
                    FIN = 0;
                end
            end
    end: tester

//SCOREBOARD
    always@(posedge FIN) begin
        bit [15:0] expected_data1;
        bit [15:0] expected_data2;
        expected_data1 = 16'h0000;
        expected_data2 = 16'h0000;

        // Calcular el valor esperado
        if (en_write == 1) begin
            if (size == 1) begin // Escritura de 16 bits
                if (reg_write == reg_read1) // Se revisa en cual registro se escribió
                    expected_data1 = write_data;
                if (reg_write == reg_read2)
                    expected_data2 = write_data;
            end 
            else begin // Escritura de 8 bits
                if (reg_write == reg_read1) begin
                    if (select_high_low == 0) begin
                        expected_data1[7:0] = write_data[7:0];
                    end
                    else begin 
                        expected_data1[15:8] = write_data[7:0];
                    end
                end
                if (reg_write == reg_read2) begin
                    if (select_high_low == 0) begin
                        expected_data2[7:0] = write_data[7:0];
                    end
                    else begin
                        expected_data2[15:8] = write_data[7:0];
                    end
                end
            end
        end
    
        // Verificar lectura del primer registro
        if (expected_data1 != read_data1)
            $error("FALLO: Reg1: %0h, Esperado: %0h, Obtenido: %0h", 
                reg_read1, expected_data1, read_data1);
               
        // Verificar lectura del segundo registro
        if (expected_data2 != read_data2)
            $error("FALLO: Reg2: %0h, Esperado: %0h, Obtenido: %0h", 
                reg_read2, expected_data2, read_data2);

    end: scoreboard

endmodule
