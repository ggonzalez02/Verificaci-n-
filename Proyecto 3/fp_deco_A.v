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
    input  [31:0] Float_num_A,
    output Signo_A,
    output [7:0] Exponente_A,
    output [23:0] Mantissa_A
);

assign Signo_A = Float_num_A[31];
assign Exponente_A = Float_num_A[30:23];
assign Mantissa_A = { 1'b1, Float_num_A[22:0]}; // Se agrega un 1 al inicio para la normalización implícita (1.xxx)

endmodule 
