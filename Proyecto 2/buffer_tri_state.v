//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: buffer_tri_state
// Description: Buffer tri estados para el uso del bus de datos
//////////////////////////////////////////////////////////////////////////////////

module buffer_tri_state (
    input [7:0] in,     //Dato de entrada
    input EN,           //0: Lectura, 1: Escritura
    output [7:0] out    //Dato de salida
);

    // Buffer tristate para controlar la dirección de los datos
    assign out = (!EN) ? in : 8'bZ;   // Si EN = 0, se activa la función de lectura, si es 1 se activa la escritura
    
endmodule