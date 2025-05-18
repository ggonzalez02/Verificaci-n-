//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: queue
// Description: cola de instrucciones 
//////////////////////////////////////////////////////////////////////////////////

module queue (
    input EN,
    input clk,
    input rst,
    input  [7:0] data,
    output [31:0] Data_Q
);

// Data -> R1 -> R2 -> R3 -> R4
wire [7:0] OUT1,OUT2,OUT3,OUT4; 

RegQ R4(clk, rst, EN, OUT3, OUT4);
RegQ R3(clk, rst, EN, OUT2, OUT3);
RegQ R2(clk, rst, EN, OUT1, OUT2);
RegQ R1(clk, rst, EN, data, OUT1);

assign Data_Q = {OUT4, OUT3, OUT2, OUT1};


endmodule 