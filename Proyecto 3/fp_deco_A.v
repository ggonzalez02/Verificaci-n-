//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: fp_decoA
// Description: Este módulo se encarga de dividir un número de 32 bits de punto flotante en signo, exponente y mantissa.
//////////////////////////////////////////////////////////////////////////////////

module fp_decoA (
    input  [31:0] float_numA,
    output signoA,
    output [7:0] exponenteA,
    output [23:0] mantissaA
);

assign signoA = float_numA[31];
assign exponenteA = float_numA[30:23];
assign mantissaA = { 1'b1, float_numA[22:0]}; // Se agrega un 1 al inicio para la normalización implícita (1.xxx)

endmodule 
