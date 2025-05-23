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
    bit [15:0] banc_seg[8]; // 4 segmentos
    bit [7:0]  reg_IP;      // Registro IP
    bit [7:0]  D_queue[4]; // 4 registros del queue
include "interface.sv"

module 8088Interface_tb2;
    
    //Interfaz
    interface_8088 bfm();

    initial begin
        bfm.clk = 0;
        forever #5 bfm.clk = ~bfm.clk; // 10ns
    end 
    
    //Tester
   
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
        .Reg_Write(bfm.Reg_Write),




        .Direction(bfm.Direction)
    );

endmodule

class Scoreboard; 
    bit [15:0] banc_reg[8]; // 8 registros
    
    
    // función escribe al registro 
    function void WR_reg(int indice,bit [15:0] data);
        banc_reg[indice] = data;
    endfunction
    // función lee el registro
    function bit RD_reg(int indice,bit [15:0] data_actual;);
        return (data_actual === banc_reg[indice]);
    endfunction

endclass


class Tester; 
    virtual interface_8088 bfm;
    Scoreboard scb;
    
    


    task WR_reg(int indice, bit [15:0] data);
        bfm.RD_WR_Regs = 1;
        bfm.Reg_Write = indice;
        bfm.Data_Regs = data;
        @(posedge bfm.clk);
        @(posedge bfm.clk);
        bfm.RD_WR_Regs = 0;
        scb.WR_reg(indice, data);
    endtask

endclass