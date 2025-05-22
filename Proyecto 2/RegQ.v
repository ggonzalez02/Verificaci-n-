//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: RegQ
// Description: Registros para mantener la data en el queue
//////////////////////////////////////////////////////////////////////////////////

module RegQ (clk, rst, EN, D, Q);
input clk; 
input rst;
input EN; //0: Mantener Q, 1: Escribir en Q
input [7:0] D; //Dato de entrada
output reg [7:0] Q; //Dato de salida

always @(posedge clk or posedge rst) begin
    if (rst)
        Q <= 8'h00;
    else if (EN)
        Q <= D;
end
endmodule 