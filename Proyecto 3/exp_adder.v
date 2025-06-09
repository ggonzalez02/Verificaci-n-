//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: exp_adder
// Description: Este módulo se encarga de sumar los exponentes extraidos de lo números flotantes de entrada.
//////////////////////////////////////////////////////////////////////////////////

module exp_adder (
    input  [7:0] exponenteA,
    input [7:0] exponenteB,
    output [8:0] exp_result
);

assign exp_result = exponenteA + exponenteB;

endmodule 
