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
    input  [7:0] Exponente_A,
    input  [7:0] Exponente_B,
    output [8:0] Exp_resul
);

assign Exp_resul = Exponente_A + Exponente_B;

endmodule 
