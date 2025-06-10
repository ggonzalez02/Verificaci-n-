module Mul_mod (
    input [23:0] Mantissa_A,
    input [23:0] Mantissa_B,
    output [47:0] Producto
);

assign Producto = Mantissa_A * Mantissa_B; 
endmodule