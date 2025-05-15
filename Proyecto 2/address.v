//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Unidad de Generación de direcciones 
// Description: Contiene dos entradas y una salida, primero desplaza hacia la izquierda
//              por 4 el segmento a utilizar y luego suma el offset de 16 bits para formar 
//              una dirección de 20 bits.
//////////////////////////////////////////////////////////////////////////////////

module address (
    input  [15:0] offset,
    input  [15:0] segmento,
    output [19:0] address
);

// shift hacia la izquierda más suma del segmento
assign address = {segmento << 4} + offset;

endmodule 