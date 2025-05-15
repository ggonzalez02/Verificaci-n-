//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: interface
// Description: Módulo de interfaz para los bancos de pruebas
//////////////////////////////////////////////////////////////////////////////////

interface 8088Interface;
    //Señales de entrada y salida del DUT
    bit clk,
    bit reset,
    logic [2:0] OP,
    logic [2:0] Reg1,
    logic [2:0] Reg2,
    logic RD_WR_pin,            //Señal direccional para el DUT
    logic RD_WR_drive,          //Señal local 
    logic [15:0] Data_pin;      //Señal direccional para el DUT
    logic [15:0] Data_drive;    //Señal local
    logic [19:0] Direction

    //Asignación para tener una señal que sea de entrada y salida
    assign Data_pin = Data_drive;
    assign RD_WR_pin = RD_WR_drive;

    //Enums para facilitar la lectura de las señales
    typedef enum logic { leer = 1'b0, escribir = 1'b1 } operacion; //Lectura o escritura

    //Generación del reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    //Resetear la interfaz
    task Reset_8088Interface taskName(arguments);
        reset = 0;
        @negedge(clk); //Esperar un ciclo
        reset = 1;
        @negedge(clk);
        @negedge(clk);
        reset = 0;
    endtask    


endinterface //8088Interface