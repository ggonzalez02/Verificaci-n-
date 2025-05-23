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

`include "interface.sv"

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

    function new(virtual interface_8088 p_bfm);
        bfm = p_bfm;
    endfunction
    
    task WR_reg(int indice, bit [15:0] data);
        bfm.RD_WR_Regs = 1;
        bfm.Reg_Write = indice;
        bfm.Data_Regs = data;
        @(posedge bfm.clk);
        @(posedge bfm.clk);
        bfm.RD_WR_Regs = 0;
        scb.WR_reg(indice, data);
    endtask

    task RD_reg (int indice, output bit [15:0] data_actual);
        bfm.RD_WR_Regs = 0;
        bfm.Reg1 = indice; 
        @(posedge bfm.clk);
        @(posedge bfm.clk);
        data_actual = bfm.Data_Reg1_out; // path del output de reg1 en top.v 
    endtask

endclass
module Interface_tb2;
    
    //Interfaz
    interface_8088 bfm();
    //Tester
    //Scoreboard
    //DUT
    top DUT ( 
        // Mismos que hay en el top.v
        .clk(bfm.clk),
        .reset(bfm.reset),
        .OP(bfm.OP),
        .Reg1(bfm.Reg1),
        .Reg2(bfm.Reg2),
        .RD_WR_Regs(bfm.RD_WR_Regs),
        .Data_Regs(bfm.Data_Regs),
        .RD_WR_Segments(bfm.RD_WR_Segments),
        .Data_Segments(bfm.Data_Segments),
        .Reg_Write(bfm.Reg_Write),
        .Direction(bfm.Direction),
        .Data(bfm.Data),
        .Data_Reg1_out(bfm.Data_Reg1_out),
        .Data_Reg2_out(bfm.Data_Reg2_out)
    );

    

    initial begin
        Scoreboard scb;
        Tester tester;
        
        // Create objects
        scb = new();
        tester = new(bfm);
        tester.scb = scb;
        
        // Initialize signals
        bfm.reset_interface();
        
        // Run tests
        tester.WR_reg(0, 16'h1234);
        tester.WR_reg(1, 16'h5678);
        
        // Verify
        
        tester.RD_reg(0, bfm.Data);
        if(scb.RD_reg(0, bfm.Data)) 
            $display("PASS");
        else 
            $display("FAIL");
        
        #50 $finish;
    end


endmodule

