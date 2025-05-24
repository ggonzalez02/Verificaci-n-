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
        .Data_Reg1_out(bfm.Data_Reg1_out),
        .Data_Reg2_out(bfm.Data_Reg2_out),
        .Relative(bfm.Relative),
        .Segment(bfm.Segment),
        .EN_IP(bfm.EN_IP),
        .SEL_IP(bfm.SEL_IP),
        .IP(bfm.IP),
        .EN(bfm.EN),
        .Internal_RD_WR(bfm.Internal_RD_WR),
        .Instruction(bfm.Instruction),
        .Data_Segment_out(bfm.Data_Segment_out)
    );
    
    integer log_file; 

    initial begin
        // Abrir archivo tipo log
      /*
        log_file = $fopen("Testbench_1.log", "w");
        $fdisplay(log_file, "Time | reset | OP | RD_WR_Regs | Reg_Write | EN_IP | Internal_RD_WR | Direction");
       */

        // Para el wave form en playground
        $dumpfile("dump.vcd");
        $dumpvars(0, Interface_tb2);
    end

    class Scoreboard; 
    // Registros 
        bit [15:0] banc_reg[8]; // 8 registros
    
        // función escribe al registro 
        function void WR_reg(int indice,bit [15:0] data);
            banc_reg[indice] = data;
        endfunction
        // función lee el registro
        function bit RD_reg(int indice,bit [15:0] data_actual);
            return (data_actual === banc_reg[indice]);
        endfunction

    // Segmentos 
        bit [15:0] seg_reg[4];// 4 segmentos 
        
        // función escribe al segmento 
        function void WR_seg(int indice,bit [15:0] data);
            seg_reg[indice] = data;
        endfunction
        // función lee el segmento
        function bit RD_seg(int indice,bit [15:0] data_actual);
            return (data_actual === seg_reg[indice]);
        endfunction
        
    //Check list 
        //Registros
        function void check_reg(int indice, bit [15:0] data_actual);
        if (data_actual === banc_reg[indice]) begin
            $display("SCOREBOARD: REG[%0d] - PASS: Esperado 0x%h, Obtuvo 0x%h", indice, banc_reg[indice], data_actual);
        end else begin
            $error("SCOREBOARD: REG[%0d] - FAIL: Esperado 0x%h, Obtuvo 0x%h", indice, banc_reg[indice], data_actual);
        end
        endfunction
      
        //Segmentos 
        function void check_seg(int indice, bit [15:0] data_actual);
        if (data_actual === seg_reg[indice]) begin
            $display("SCOREBOARD: REG[%0d] - PASS: Esperado 0x%h, Obtuvo 0x%h", indice, banc_reg[indice], data_actual);
        end else begin
          $error("SCOREBOARD: REG[%0d] - FAIL: Esperado 0x%h, Obtuvo 0x%h", indice, seg_reg[indice], data_actual);
        end
        endfunction

    endclass


    class Tester; 
        virtual interface_8088 bfm;
        Scoreboard scb;

        function new(virtual interface_8088 p_bfm);
            bfm = p_bfm;
        endfunction

        // Registros 
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
            scb.check_reg(indice, data_actual);
        endtask

        // Segmentos 
        task WR_seg(int indice, bit [15:0] data);
            bfm.RD_WR_Segments = 1;
            bfm.Segment = indice;
            bfm.Data_Segments = data;
            @(posedge bfm.clk);
            @(posedge bfm.clk);
            bfm.RD_WR_Segments = 0;
            scb.WR_seg(indice, data);
        endtask

        task RD_seg(int indice, output bit [15:0] data);
            bfm.RD_WR_Segments = 0;
            bfm.Segment = indice;
            @(posedge bfm.clk);
            @(posedge bfm.clk);
            data = bfm.Data_Segment_out;
            scb.check_seg(indice, data);
        endtask
    endclass
    

    initial begin
        Scoreboard scb;
        Tester tester;
        bit [15:0] data;
   

        
        scb = new();
        tester = new(bfm);
        tester.scb = scb;
        
        
        bfm.reset_interface();
        
        // Tests

        //Regs
        tester.WR_reg(0, 16'h1234); //AX
        tester.WR_reg(1, 16'h5678); //BX
        tester.WR_reg(2, 16'h8683); //CX
        tester.WR_reg(3, 16'h3234); //DX
        tester.WR_reg(4, 16'h4123); //SP
        tester.WR_reg(5, 16'h6909); //BP
        tester.WR_reg(6, 16'h3133); //SI
        tester.WR_reg(7, 16'h0189); //DI

        tester.RD_reg(0, data);
        tester.RD_reg(1, data);
        tester.RD_reg(2, data);
        tester.RD_reg(3, data);
        tester.RD_reg(4, data);
        tester.RD_reg(5, data);
        tester.RD_reg(6, data);
        tester.RD_reg(7, data);
        //Segs
        tester.WR_seg(0, 16'h1000); // CS
        tester.WR_seg(1, 16'h2000); // DS
        tester.WR_seg(2, 16'h3000); // SS
        tester.WR_seg(3, 16'h4000); // ES
    
        tester.RD_seg(0, data);
        tester.RD_seg(1, data);
        tester.RD_seg(2, data);
        tester.RD_seg(3, data);

        
        #50 $finish;
    end
/*
    initial begin
        forever begin
            #10;
            $fdisplay(log_file, "%3dns | %b | %b | %b | %b | %b | %b | %h", 
                 $time, reset, OP, RD_WR_Regs, Reg_Write, EN_IP, Internal_RD_WR, Direction);
        end
    end

*/

endmodule
