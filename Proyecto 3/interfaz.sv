//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: interfaz
// Description: Módulo de interfaz para el sumador/multiplicador de punto flotante
//////////////////////////////////////////////////////////////////////////////////

interface interfaz;
    //Señales de entrada y salida del DUT
    //Entradas
    logic [31:0] Float_num_A;
    logic [31:0] Float_num_B;
    logic        OP_input;
    //Salida
    logic [31:0] Resultado;

endinterface //interfaz