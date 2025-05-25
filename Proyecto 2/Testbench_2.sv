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
        .Data_Segment_out(bfm.Data_Segment_out),
        .RD_WR(bfm.RD_WR_pin),
        .Data(bfm.Data_pin)
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
    //Registros 
        bit [15:0] banc_reg[8]; // 8 registros
    
        // función escribe al registro 
        function void WR_reg(int indice,bit [15:0] data);
            banc_reg[indice] = data;
        endfunction
        // función lee el registro
        function bit RD_reg(int indice,bit [15:0] data_actual);
            return (data_actual === banc_reg[indice]);
        endfunction

    //Segmentos 
        bit [15:0] seg_reg[4];// 4 segmentos 
        
        // función escribe al segmento 
        function void WR_seg(int indice,bit [15:0] data);
            seg_reg[indice] = data;
        endfunction
        // función lee el segmento
        function bit RD_seg(int indice,bit [15:0] data_actual);
            return (data_actual === seg_reg[indice]);
        endfunction

    //IP 
        bit [7:0] ip_reg;
        function void WR_ip(bit [7:0] data);
            ip_reg = data;
        endfunction

        function void suma_ip();
        ip_reg++;
        endfunction


    //ALU
        function bit [19:0] calculate_address(int mode, int seg_indice, int reg1_indice, int reg2_indice, bit [15:0] relative);
            bit [15:0] offset;
            bit [19:0] addr;
            
            // Operaciones escogidas 
            case(mode)
                0: offset = {8'h00, ip_reg};  
                1: offset = relative;
                2: offset = banc_reg[reg1_indice];
                3: offset = banc_reg[reg1_indice] + relative;
                4: offset = banc_reg[reg1_indice] + banc_reg[reg2_indice];
                5: offset = banc_reg[reg1_indice] + banc_reg[reg2_indice] + relative;
            endcase
            
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
            $display("SCOREBOARD: SEG[%0d] - PASS: Esperado 0x%h, Obtuvo 0x%h", indice, seg_reg[indice], data_actual);
        end else begin
          $error("SCOREBOARD: SEG[%0d] - FAIL: Esperado 0x%h, Obtuvo 0x%h", indice, seg_reg[indice], data_actual);
        end
        endfunction

        // IP

        function bit check_ip_change(bit [19:0] old_dir, bit [19:0] new_dir);
            bit [19:0] expected_diff = 1; // IP incremented by 1
            if (new_dir == old_dir + expected_diff) begin
                $display("SCOREBOARD: IP - PASS: Direction changed by 0x%X", expected_diff);
                return 1;
            end else begin
                $error("SCOREBOARD: IP - FAIL: Expected change of 0x%X", expected_diff);
                return 0;
            end
        endfunction
        
        //ALU
        function bit check_alu(int mode, bit [19:0] data_actual, bit [19:0] esperado);
            if (data_actual === esperado) begin
            $display("SCOREBOARD: ALU OP[%0d] - PASS: Address = 0x%05X", mode, data_actual);
            return 1;
            end else begin
            $error("SCOREBOARD: ALU OP[[%0d] - FAIL: esperado 0x%05X, got 0x%05X", mode, esperado, data_actual);
            return 0;
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
            data_actual = bfm.Data_Reg1_out; 
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

        //IP
        task WR_ip(bit [7:0] data);
            bfm.EN_IP = 1;
            bfm.SEL_IP = 1;
            bfm.IP = data;
            @(posedge bfm.clk);
            @(posedge bfm.clk);
            bfm.EN_IP = 0;
            scb.WR_ip(data);
        endtask

        task suma_ip();
            bfm.EN_IP = 1;
            bfm.SEL_IP = 0;
            @(posedge bfm.clk);
            @(posedge bfm.clk);
            bfm.EN_IP = 0;
            scb.suma_ip();
        endtask

        //ALU
        task test_alu(int mode, int seg, int reg1, int reg2, bit [15:0] rel);
            bfm.OP = mode;
            bfm.Segment = seg;
            bfm.Reg1 = reg1;
            bfm.Reg2 = reg2;
            bfm.Relative = rel;
            @(posedge bfm.clk);
            @(posedge bfm.clk);
        endtask
    endclass
    

    initial begin
        Scoreboard scb;
        Tester tester;
        bit [15:0] data;
        bit [19:0] result_mode2;
        bit [19:0] result_mode4;
     	bit [19:0] dir_antes;
        bit [19:0] OP1_resul;
        bit [19:0] base;
   

        
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

        // IP 
        tester.WR_ip(8'h50);
        tester.test_alu(0, 0, 0, 0, 0);  // Mode 0: CS:IP
      	dir_antes = bfm.Direction;

        tester.suma_ip();  // Increment IP
        tester.test_alu(0, 0, 0, 0, 0);  // Mode 0 again
      scb.check_ip_change(dir_antes, bfm.Direction);

        //ALU

        // OP 1: Segment + Relative only
        tester.test_alu(1, 1, 0, 0, 16'h0200);  // DS:0200h
        OP1_resul = bfm.Direction;
        $display("OP 1 (DS:0200h): 0x%05X", OP1_resul);


        // OP 2: DS:AX
        tester.test_alu(2, 1, 0, 0, 0);  
         base = bfm.Direction;
        $display("OP 2 (DS:AX): 0x%05X", base);

        // Mode 3: DS:AX+0x100
        tester.test_alu(3, 1, 0, 0, 16'h0100);  
        scb.check_alu(3, bfm.Direction, (base & 16'hFFFF) + 16'h0100);


        // OP 4: DS:AX+BX
        tester.test_alu(4, 1, 0, 1, 0);  
        scb.check_alu(4, bfm.Direction, (base & 16'hFFFF) + 16'h5678);

        // OP 5: DS:AX+BX+Relative
        tester.test_alu(5, 1, 0, 1, 16'h0100);  // DS:AX+BX+0100h
        scb.check_alu(5, bfm.Direction, (base & 16'hFFFF) + 16'h5678 + 16'h0100);
        
        // OP 0: CS:IP
        tester.test_alu(0, 0, 0, 0, 0);  
        $display("OP 0 (CS:IP): 0x%05X", bfm.Direction);
        
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


