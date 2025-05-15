//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: ALU
// Description: Módulo encargado de retornar la dirección
//////////////////////////////////////////////////////////////////////////////////

`include "address.v"

module ALU (
    input [2:0] OP,
    input [15:0] Relative,
    input [15:0] Data_Segment,
    input [15:0] Data_Reg1,
    input [15:0] Data_Reg2,
    output [19:0] Direction
    );

    //Definición de señales internas para usar el módulo address
    reg [15:0] offset ;
    reg  [15:0] segmento;
    reg [19:0] address;

    //A partir de OP, decidir el tipo de direccionamiento que se va a obtener
    always @(OP) begin
        case (OP)
            3'h0: begin
                segmento = Data_Segment;
                offset = Data_Reg1;
            end
            3'h1: begin
                segmento = Data_Segment;
                offset = Relative;
            end
            3'h2: begin
                segmento = Data_Segment;
                offset = Data_Reg1;
            end
            3'h3: begin
                segmento = Data_Segment;
                offset = Data_Reg1 + Relative;
            end
            3'h4: begin
                segmento = Data_Segment;
                offset = Data_Reg1 + Data_Reg2;
            end
            3'h5: begin
                segmento = Data_Segment;
                offset = Data_Reg1 + Data_Reg2 + Relative;
            end
            default: begin
                segmento = Data_Segment;
                offset = Data_Reg1;
            end
        endcase
    end

    //Suma para obtener la señal de dirección
    address Calculo (.offset(offset), .segmento(segmento), .address(address));

    assign Direction = address;

endmodule 