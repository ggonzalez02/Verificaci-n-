//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: RegistrosQueue
// Description: registros para mantener la data en el queue
//////////////////////////////////////////////////////////////////////////////////

module RegQ (clk, rst, EN, D, Q);
input clk; 
input rst;
input EN;
input [7:0] D;
output  [7:0] Q;

always @(posedge clk or posedge rst) begin
    if (rst)
        Q <= 8'h00;
    else if (EN)
        Q <= D    
end
endmodule 