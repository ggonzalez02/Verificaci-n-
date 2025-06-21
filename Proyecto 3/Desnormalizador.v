//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Desnormalizador
// Description: Convierte los exponentes a exponentes reales, compara los exponentes y alinea las mantissas.
//////////////////////////////////////////////////////////////////////////////////

module Desnormalizador (
    input  [23:0] Mantissa_A,
    input  [7:0]  Exponente_A,
    input  [23:0] Mantissa_B,
    input  [7:0] Exponente_B,
    output [25:0] Resul_Mantissa_A,
    output [7:0]  Exp_comun,
    output [25:0] Resul_Mantissa_B
);

// Convertir exponentes
wire signed [8:0] exp_real_A = $signed({1'b0, Exponente_A}) - 9'd127;
wire signed [8:0] exp_real_B = $signed({1'b0, Exponente_B}) - 9'd127;

//Comparar para saber cuál es el mayor
wire signed [8:0] exp_mayor = (exp_real_A >= exp_real_B) ? exp_real_A : exp_real_B;
// Sumar 127 para la salida
assign Exp_comun = exp_mayor + 9'd127;

// Se restan los exponentes para hacer el shifteo a la derecha
wire [7:0] resta_exponentes = (exp_real_A >= exp_real_B) ? (exp_real_A - exp_real_B) : (exp_real_B - exp_real_A);

// Extender mantissas a 26 bits
wire [25:0] mantissa_A_ext = {Mantissa_A, 2'b00};
wire [25:0] mantissa_B_ext = {Mantissa_B, 2'b00};

// Asignar el resultado de la mantissa según el exponente mayor
assign Resul_Mantissa_A = (exp_real_A >= exp_real_B) ? mantissa_A_extended : (mantissa_A_extended >> resta_exponentes);
assign Resul_Mantissa_B = (exp_real_A >= exp_real_B) ? (mantissa_B_extended >> resta_exponentes) : mantissa_B_extended;

endmodule
