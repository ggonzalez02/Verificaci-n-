//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Adder
// Description: Módulo que maneja la suma y resta de las mantissas.
//////////////////////////////////////////////////////////////////////////////////

module Adder (
    input SignoA,
    input SignoB,
    input [25:0] Resul_Mantissa_A,
    input [25:0] Resul_Mantissa_B,
    output[26:0] Suma_resul,
    output Signo_sum
);

wire operacion = (SignoA == SignoB) ? 1 : 0; // 1: suma, 0: resta
wire mantissa_mayor = (Resul_Mantissa_A >= Resul_Mantissa_B) ? 1 : 0; // 1: A > B, 0: A < B

// Según el tipo de operación se suma o se restan las mantissas
assign Suma_resul = (operacion) ? Resul_Mantissa_A + Resul_Mantissa_B :
                    (mantissa_mayor) ? Resul_Mantissa_A - Resul_Mantissa_B :
                    Resul_Mantissa_B - Resul_Mantissa_A;

// Si la operación es suma se asigna el signo A, ya que son iguales,
// si es resta se verifica cuál mantissa es mayor para establcer el signo
assign Signo_sum = (operacion) ? SignoA :
                   (Resul_Mantissa_A >= Resul_Mantissa_B) ? SignoA : 
                   SignoB;

endmodule
