/////////////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: top
// Description: Módulo top que instancia todos los componentes para
//              realizar operaciones de suma, resta y multiplicación en punto flotante.
////////////////////////////////////////////////////////////////////////////////////////

module top (
    input  [31:0] Float_num_A,
    input  [31:0] Float_num_B,
    input OP_input,
    output [31:0] Resultado
);

// Se establecen las variables internas necesarias para el funcionamiento de los módulos instanciados
wire Signo_A, Signo_B;
wire [7:0]  Exponente_A, Exponente_B;
wire [23:0] Mantissa_A, Mantissa_B;
wire [25:0] Resul_Mantissa_A, Resul_Mantissa_B;
wire [7:0]  Exp_comun;
wire [26:0] Suma_resul;
wire Signo_sum;
wire [8:0]  Exp_resul;
wire [47:0] Producto;
wire Signo_mul;

// Módulos
// Decodificador A
fp_decoA decoder_A (
    .Float_num_A(Float_num_A),
    .Signo_A(Signo_A),
    .Exponente_A(Exponente_A),
    .Mantissa_A(Mantissa_A)
);

// Decodificador B
fp_decoB decoder_B (
    .Float_num_B(Float_num_B),
    .Signo_B(Signo_B),
    .Exponente_B(Exponente_B),
    .Mantissa_B(Mantissa_B)
);

// Denormalizador
Desnormalizador desnorm (
    .Mantissa_A(Mantissa_A),
    .Exponente_A(Exponente_A),
    .Mantissa_B(Mantissa_B),
    .Exponente_B(Exponente_B),
    .Resul_Mantissa_A(Resul_Mantissa_A),
    .Exp_comun(Exp_comun),
    .Resul_Mantissa_B(Resul_Mantissa_B)
);
 
// Sumador
Adder adder (
    .SignoA(Signo_A),
    .SignoB(Signo_B),
    .Resul_Mantissa_A(Resul_Mantissa_A),
    .Resul_Mantissa_B(Resul_Mantissa_B),
    .Suma_resul(Suma_resul),
    .Signo_sum(Signo_sum)
);

// Sumador de Exponentes
exp_adder exp_add (
    .Exponente_A(Exponente_A),
    .Exponente_B(Exponente_B),
    .Exp_resul(Exp_resul)
);

// Multiplicador
Mul_mod multiplicador (
    .Mantissa_A(Mantissa_A),
    .Mantissa_B(Mantissa_B),
    .Producto(Producto)
);

// Xor para signo
xor_signo xor_sign (
    .Signo_A(Signo_A),
    .Signo_B(Signo_B),
    .Signo(Signo_mul)
);

// Normalizador
Normalizador normalizador (
    .OP_input(OP_input),
    .Signo_mul(Signo_mul),
    .Signo_sum(Signo_sum),
    .Exp_comun(Exp_comun),
    .Exp_resul(Exp_resul),
    .Producto(Producto),
    .Suma_resul(Suma_resul),
    .Resultado(Resultado)
);

endmodule
