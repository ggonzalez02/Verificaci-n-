//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: register_bank
// Description: Banco de registros del microprocesador 8088
//////////////////////////////////////////////////////////////////////////////////

module register_bank(
    input clk,
    input reset,
    input wire RD_WR,               //1: Habilita escritura, 0: Escritura inhabilitada
    input wire [2:0] reg_write,     //Registro a escribir
    input wire [15:0] Data,         //Datos a escribir
    input wire [2:0] Reg1,          //Primer registro de lectura
    input wire [2:0] Reg2,          //Segundo registro de lectura
    output reg [15:0] Data_Reg1,    //Datos leídos del primer registro
    output reg [15:0] Data_Reg2     //Datos leídos del segundo registro

);
    // Registros de Uso General
    reg[15:0] AX, BX, CX, DX;

    // Registros Punteros y de Índice
    reg[15:0] SP, BP, SI, DI;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializar todos los registros
            AX <= 16'h0000; BX <= 16'h0000; CX <= 16'h0000; DX <= 16'h0000; 
            SP <= 16'h0000; BP <= 16'h0000; SI <= 16'h0000; DI <= 16'h0000;
        end
        else if (RD_WR) begin
            case (reg_write)
                    3'h0: AX <= Data;
                    3'h1: BX <= Data;
                    3'h2: CX <= Data;
                    3'h3: DX <= Data;
                    3'h4: SP <= Data;
                    3'h5: BP <= Data;
                    3'h6: SI <= Data;
                    3'h7: DI <= Data;
                    default;
            endcase
        end
    end

    always@(*) begin
        case(reg_read1) //Lectura de Registro 1
            3'h0: Data_Reg1 = AX;
            3'h1: Data_Reg1 = BX;
            3'h2: Data_Reg1 = CX;
            3'h3: Data_Reg1 = DX;
            3'h4: Data_Reg1 = SP;
            3'h5: Data_Reg1 = BP;
            3'h6: Data_Reg1 = SI;
            3'h7: Data_Reg1 = DI;
            default: Data_Reg1 = 16'h0000;

        endcase

        case(reg_read2) //Lectura de Registro 2
            3'h0: Data_Reg2 = AX;
            3'h1: Data_Reg2 = BX;
            3'h2: Data_Reg2 = CX;
            3'h3: Data_Reg2 = DX;
            3'h4: Data_Reg2 = SP;
            3'h5: Data_Reg2 = BP;
            3'h6: Data_Reg2 = SI;
            3'h7: Data_Reg2 = DI;
            default: Data_Reg2 = 16'h0000;
        endcase
    end

endmodule