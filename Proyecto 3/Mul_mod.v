//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Mul_mod
// Description: Módulo que multiplica las mantissas de los números ingresados.
//////////////////////////////////////////////////////////////////////////////////

module Mul_mod (
    input [23:0] Mantissa_A,
    input [23:0] Mantissa_B,
    output [47:0] Producto
);

// Se multiplican las mantissas de ambos números
assign Producto = Mantissa_A * Mantissa_B; 
endmodule
