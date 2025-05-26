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
        .Bus(bfm.Bus),
        .Data(bfm.Data_pin)
    );
    
    integer log_file; 

    //Función para esperar n veces el flanco de subida del clock
    task automatic wait_n_clks(input int n);
        repeat(n) @(posedge bfm.clk);
    endtask

    initial begin

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

    // Queue 
        bit [7:0] Input_to_queue [4]; 
        int queue_pointer = 0; // apunta al siguiente espacio que se va escribir 

        function void WR_queue_input(bit [7:0] data);
            if (queue_pointer < 4) begin
                Input_to_queue [queue_pointer] = data;
                queue_pointer++;
            end
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
        function bit check_ip(bit [19:0] vieja, bit [19:0] nueva);
            if (nueva == vieja + 1) begin
                $display("SCOREBOARD: IP - PASS: Dirección cambió de 0x%05X a 0x%05X", vieja, nueva);
            return 1;
            end else begin
            $error("SCOREBOARD: IP - FAIL: Esperado 0x%05X, obtuvo 0x%05X", vieja + 1, nueva);
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

        // Queue
        function bit check_queue(bit [31:0] actual);
            bit [31:0] esperado = {Input_to_queue [0], Input_to_queue [1], Input_to_queue [2], Input_to_queue [3]};
            if (actual === esperado) begin
                $display("SCOREBOARD: QUEUE - PASS: 0x%08X", actual);
                return 1;
            end else begin
                $error("SCOREBOARD: QUEUE - FAIL: Esperado 0x%08X, se tiene 0x%08X", esperado, actual);
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

        // Queue
        task Input_to_queue(bit [7:0] data);
            bfm.Internal_RD_WR = 0;  
            bfm.RD_WR_drive = 0; 
            bfm.EN = 1;
            bfm.Bus = data;
            @(posedge bfm.clk);
            @(posedge bfm.clk);
            bfm.EN = 0;
            scb.WR_queue_input(data);
        endtask

    endclass
    

    initial begin
        Scoreboard scb;
        Tester tester;
        bit [15:0] data;
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
        tester.test_alu(0, 0, 0, 0, 0); 
      	dir_antes = bfm.Direction;

        tester.suma_ip();  
        bfm.Segment = 0;   
        @(posedge bfm.clk);
        tester.test_alu(0, 0, 0, 0, 0); 
        scb.check_ip(dir_antes, bfm.Direction);

    //ALU
        bfm.RD_WR_Segments = 0;
        // OP 1
        //Orden: OP, seg, reg1, reg2, relative
        tester.test_alu(1, 1, 0, 0, 16'h0200);  
        OP1_resul = bfm.Direction;
        scb.check_alu(1, bfm.Direction, 20'h20200);


        // OP 2
        tester.test_alu(2, 1, 0, 0, 0);  
        base = bfm.Direction;
        scb.check_alu(2, bfm.Direction, 20'h21234);

        // OP 3
        tester.test_alu(3, 1, 0, 0, 16'h0100);  
        scb.check_alu(3, bfm.Direction, base + 16'h0100);  


        // OP 4
        tester.test_alu(4, 1, 0, 1, 0);  
        scb.check_alu(4, bfm.Direction, base + 16'h5678);

        // OP 5
        tester.test_alu(5, 1, 0, 1, 16'h0100); 
        scb.check_alu(5, bfm.Direction, base + 16'h5678 + 16'h0100);
        
        // OP 0
        tester.test_alu(0, 0, 0, 0, 0);  
        scb.check_alu(0, bfm.Direction, 20'h10051);
        
    //Queue
        tester.Input_to_queue(8'hAA);
        @(posedge bfm.clk);
        tester.Input_to_queue(8'hBB);
        @(posedge bfm.clk);
        tester.Input_to_queue(8'hCC);
        @(posedge bfm.clk);
        tester.Input_to_queue(8'hDD);
        @(posedge bfm.clk);
        scb.check_queue(bfm.Instruction);

       
        #50 $finish;
    end

    //Covergroups

/*
    bins
    Acorde al valor de OP
    000: Segment * 10H + IP
    001: Segment * 10H + Reg1
    010: Segment * 10H + Reg1 + Relative
    011: Segment * 10H + Reg1 + Reg2
    100: Segment * 10H + Reg1 + Reg2 + Relative
*/

    covergroup op_cover;
        coverpoint op_point{
            bins op_1 = {3'b000};
            bins op_2 = {3'b001};
            bins op_3 = {3'b010};
            bins op_4 = {3'b011};
            bins op_5 = {3'b100};
        }

    endgroup

    op_cover op_c;

    initial begin
        op_c = new();
        forever begin
            wait_n_clks(1);
            op_c.sample();
        end
    end

endmodule


