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
    input  signoA,
    input signoB,
    output signo
);

assign signo = signoA ^ signoB ;

endmodule 