//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: 8088Interface_tb2
// Description: Testbench para probar la interfaz del 8088
//////////////////////////////////////////////////////////////////////////////////

`include "interface.sv"

module 8088Interface_tb2;
    
    //Interfaz
    8088Interface bfm();
    
    //Tester

    //Scoreboard

    //DUT
    top DUT (
    .clk(bfm.clk),
    .reset(bfm.reset),
    .OP(bfm.OP),
    .Reg1(bfm.Reg1),
    .Reg2(bfm.Reg2),
    .RD_WR(bfm.RD_WR_pin),
    .Data(bfm.Data_pin),
    ,Direction(bfm.Direction)
    );

endmodule