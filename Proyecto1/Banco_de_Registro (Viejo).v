//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: register_bank_8088
// Description: Banco de registros del microprocesador 8088
//////////////////////////////////////////////////////////////////////////////////

module register_bank_8088(
    input clk,
    input reset,
    input wire en_write,           // 1: Habilita escritura, 0: Escritura inhabilitada
    input wire [2:0] reg_write,    // Registro a escribir
    input wire [15:0] write_data,  // Datos a escribir
    input wire [2:0] reg_read1,    // Primer registro de lectura
    input wire [2:0] reg_read2,    // Segundo registro de lectura
    input wire size,               // Tamaño del registro (0: 8 bits, 1: 16 bits)
    input wire select_high_low,    // Selección de XH o XL (0: parte baja, 1: parte alta )
    output reg [15:0] read_data1, // Datos leídos del primer registro
    output reg [15:0] read_data2  // Datos leídos del segundo registro

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
        else if (en_write) begin
            if (size == 1) // Escribir en los registros de 16 bits
                case (reg_write)
                    3'h0: AX <= write_data;
                    3'h1: BX <= write_data;
                    3'h2: CX <= write_data;
                    3'h3: DX <= write_data;
                    3'h4: SP <= write_data;
                    3'h5: BP <= write_data;
                    3'h6: SI <= write_data;
                    3'h7: DI <= write_data;
                    default;
                endcase
                
            else begin
                case (reg_write) // Si se escribe en un registro de 8 bits, seleccionar parte alta o baja de los registros de uso general
                    3'h0: begin
                        if (select_high_low == 0)
                            AX[7:0] <= write_data[7:0];
                        else
                            AX[15:8] <= write_data[7:0];
                    end
                    3'h1: begin
                        if (select_high_low == 0)
                            BX[7:0] <= write_data[7:0];
                        else
                            BX[15:8] <= write_data[7:0];
                    end
                    3'h2: begin
                        if (select_high_low == 0)
                            CX[7:0] <= write_data[7:0];
                        else
                            CX[15:8] <= write_data[7:0];
                    end
                    3'h3: begin
                       if (select_high_low == 0)
                            DX[7:0] <= write_data[7:0];
                        else
                            DX[15:8] <= write_data[7:0];
                    end
                endcase
            end
        end
    end

    always@(*) begin
        case(reg_read1) //Lectura de Registro 1
            3'h0: read_data1 = AX;
            3'h1: read_data1 = BX;
            3'h2: read_data1 = CX;
            3'h3: read_data1 = DX;
            3'h4: read_data1 = SP;
            3'h5: read_data1 = BP;
            3'h6: read_data1 = SI;
            3'h7: read_data1 = DI;
            default: read_data1 = 16'h0000;

        endcase

        case(reg_read2) //Lectura de Registro 2
            3'h0: read_data2 = AX;
            3'h1: read_data2 = BX;
            3'h2: read_data2 = CX;
            3'h3: read_data2 = DX;
            3'h4: read_data2 = SP;
            3'h5: read_data2 = BP;
            3'h6: read_data2 = SI;
            3'h7: read_data2 = DI;
            default: read_data2 = 16'h0000;
        endcase
    end

endmodule
