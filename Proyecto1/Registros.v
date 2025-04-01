//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: Registros
// Description: Registros de uso General y de Punteros e Índice
//////////////////////////////////////////////////////////////////////////////////

module Registros (
    input clk,
    input reset,
    input [15:0] en_write,  // Señal que habilita el registro
    input [15:0] data_in,   // Datos de entrada
    input select_data_h_reg, // Selección de la parte baja (0) o alta (1) de data_in en los registros tipo H
    output wire [7:0] AL, BL, CL, DL, AH, BH, CH, DH,
    output wire [15:0] AX, BX, CX, DX, SI, DI, SP, BP
);

    // Registros internos para el manejo de datos
    reg [15:0] AX_reg, BX_reg, CX_reg, DX_reg, SP_reg, BP_reg, SI_reg, DI_reg;

    // Asignación de salidas usando los registros internos
    assign AL = AX_reg[7:0];    
    assign BL = BX_reg[7:0];    
    assign CL = CX_reg[7:0];    
    assign DL = DX_reg[7:0];    
    assign AH = AX_reg[15:8];   
    assign BH = BX_reg[15:8];   
    assign CH = CX_reg[15:8];   
    assign DH = DX_reg[15:8];   
    
    assign AX = AX_reg;
    assign BX = BX_reg;
    assign CX = CX_reg;
    assign DX = DX_reg;
    assign SI = SI_reg;
    assign SP = SP_reg;
    assign BP = BP_reg;
    assign DI = DI_reg;

    always @(posedge clk or posedge reset) begin
        if (reset == 1) begin
            AX_reg <= 16'h0000; BX_reg <= 16'h0000; CX_reg <= 16'h0000; DX_reg <= 16'h0000; 
            SP_reg <= 16'h0000; BP_reg <= 16'h0000; SI_reg <= 16'h0000; DI_reg <= 16'h0000;
        end
        else begin
            if (en_write[0])
                AX_reg <= data_in;
            else if (en_write[12])
                AX_reg[7:0] <= data_in[7:0];
            else if (en_write[8]) begin
                if (select_data_h_reg == 1)
                    AX_reg[15:8] <= data_in[15:8];
                else 
                    AX_reg[15:8] <= data_in[7:0];
            end 

            if (en_write[1])
                BX_reg <= data_in;
            else if (en_write[13])
                BX_reg[7:0] <= data_in[7:0];
            else if (en_write[9]) begin
                if (select_data_h_reg == 1)
                    BX_reg[15:8] <= data_in[15:8];
                else 
                    BX_reg[15:8] <= data_in[7:0];
            end 

            if (en_write[2])
                CX_reg <= data_in;
            else if (en_write[14])
                CX_reg[7:0] <= data_in[7:0];
            else if (en_write[10]) begin
                if (select_data_h_reg == 1)
                    CX_reg[15:8] <= data_in[15:8];
                else 
                    CX_reg[15:8] <= data_in[7:0];
            end 

            if (en_write[3])
                DX_reg <= data_in;
            else if (en_write[15])
                DX_reg[7:0] <= data_in[7:0];
            else if (en_write[11]) begin
                if (select_data_h_reg == 1)
                    DX_reg[15:8] <= data_in[15:8];
                else 
                    DX_reg[15:8] <= data_in[7:0];
            end 

            if (en_write[4])
                SI_reg <= data_in;

            if (en_write[5])
                DI_reg <= data_in;

            if (en_write[6])
                SP_reg <= data_in;

            if (en_write[7])
                BP_reg <= data_in;            
        end
    end


endmodule
