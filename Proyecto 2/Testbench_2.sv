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
module Interface_tb2;
    
    //Interfaz
    interface_8088 bfm();


    
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
        .Reg_Read(bfm.Reg_Read),
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
    function bit RD_reg(int indice,bit [15:0] data_actual);
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

    task RD_reg (int indice, output bit [15:0] data_actual)
        bfm.RD_WR_Regs = 0;
        bfm.Reg1 = indice; 
        @(posedge bfm.clk);
        @(posedge bfm.clk);
        data_actual = DUT.Registers.Data_Reg1; // path del output de reg1 en top.v 
    endtask

endclass