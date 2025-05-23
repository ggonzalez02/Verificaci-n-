//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: interface
// Description: Módulo de interfaz para los bancos de pruebas
//////////////////////////////////////////////////////////////////////////////////

interface interface_8088;
    //Señales de entrada y salida del DUT
    bit clk;
    bit reset;
    logic [2:0] OP;
    logic [2:0] Reg1;
    logic [2:0] Reg2;
    logic RD_WR_pin;            //Señal direccional para el DUT
    logic RD_WR_drive;          //Señal local 
    logic [15:0] Data_pin;      //Señal direccional para el DUT
    logic [15:0] Data_drive;    //Señal local
    logic [19:0] Direction;

    logic RD_WR_Regs;
    logic [2:0] Reg_Write;
    logic [15:0] Data_Regs;
    logic [15:0] Relative;
    logic RD_WR_Segments;
    logic [1:0] Segment;
    logic [15:0] Data_Segments;
    logic EN_IP;
    logic SEL_IP;
    logic [7:0] IP;
    logic EN;
    logic Internal_RD_WR;
    logic [7:0] Bus;
    logic [7:0] Data;
    logic [31:0] Instruction;

    logic [15:0] Data_Reg1_out;
    logic [15:0] Data_Reg2_out;

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
    
    //Funci�n para esperar n veces el flanco de subida del clock
    task automatic wait_n_clks(input int n);
        repeat(n) @(posedge clk);
    endtask

    //Resetear la interfaz
    task reset_interface();
        reset = 0;
        wait_n_clks (2);
        reset = 1;
        wait_n_clks (3);
        reset = 0;
    endtask


endinterface //8088Interface