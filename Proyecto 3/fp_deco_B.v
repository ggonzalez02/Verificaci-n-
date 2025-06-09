//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: fp_decoB
// Description: Este módulo se encarga de dividir un número de 32 bits de punto flotante en signo, exponente y mantissa.
//////////////////////////////////////////////////////////////////////////////////

module address (
    input  [31:0] float_numB,
    output signoB,
    output [7:0] exponenteB,
    output [23:0] mantissaB
);

assign signoB = float_numB[31];
assign exponenteB = float_numB[30:23];
assign mantissaB = { 1'b1, float_numB[22:0]}; // Se agrega un 1 al inicio para la normalización implícita (1.xxx)

endmodule 
