//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: xor_signo
// Description: Compuerta XOR para determinar el signo de la multiplicación.
//////////////////////////////////////////////////////////////////////////////////

module xor_signo (
    input  Signo_A,
    input  Signo_B,
    output Signo
);

assign signo = signoA ^ signoB ;

endmodule 