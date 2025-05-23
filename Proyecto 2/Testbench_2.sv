//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: 8088Interface_tb2
// Description: Testbench para probar la interfaz del 8088
//////////////////////////////////////////////////////////////////////////////////


// Que quier testear? 
//Quiero probar bancos de registros escribir y leer a AX, BX , CX, al igual que los segmentos CS,SS etc 
// Probar la ALU 
// Escribir a IP 
// Shift en el queue 

include "interface.sv"

module 8088Interface_tb2;
    
    //Interfaz
    interface_8088 bfm();
    
    //Tester
    funtion 

    endfunction 
    //Scoreboard


    //DUT
    top DUT (
        .clk(bfm.clk),
        .reset(bfm.reset),
        .OP(bfm.OP),
        .Reg1(bfm.Reg1),
        .Reg2(bfm.Reg2),
        .RD_WR_regs(bfm.RD_WR_regs),
        .Data_regs(bfm.Data_regs),
        .RD_WR_seg(bfm.RD_WR_seg),
        .Data_seg(bfm.Data_seg),
        




        .Direction(bfm.Direction)
    );

endmodule

 class Scorebaord; 
    bit [15:0] banc_reg[8]; // 8 registros
    bit [15:0] banc_seg[8]; // 4 segmentos
    bit [7:0]  reg_IP;      // Registro IP
    bit [7:0]  D_queue[4]; // 4 registros del queue


 endclass
