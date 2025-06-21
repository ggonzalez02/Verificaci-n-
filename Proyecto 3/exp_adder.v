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

wire signed [8:0] exp_real_A = $signed({1'b0, Exponente_A}) - 9'd127;
wire signed [8:0] exp_real_B = $signed({1'b0, Exponente_B}) - 9'd127;

assign Exp_resul = exp_real_A + exp_real_B + 9'd127;

endmodule 
