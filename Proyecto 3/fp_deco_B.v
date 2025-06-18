//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: fp_decoB
// Description: Este módulo se encarga de dividir un número de 32 bits de punto flotante en signo, exponente y mantissa.
//////////////////////////////////////////////////////////////////////////////////

module fp_decoB (
    input  [31:0] Float_num_B,
    output Signo_B,
    output [7:0] Exponente_B,
    output [23:0] Mantissa_B
);

// Se divide el número de 32 bits en tres partes para ejecutar las operaciones
assign Signo_B = Float_num_B[31];
assign Exponente_B = Float_num_B[30:23];
assign Mantissa_B = { 1'b1, Float_num_B[22:0]}; // Se agrega un 1 al inicio para la normalización implícita (1.xxx)

endmodule 
