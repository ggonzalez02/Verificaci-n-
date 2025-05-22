//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: ALU
// Description: Módulo encargado de retornar la dirección
//////////////////////////////////////////////////////////////////////////////////

module ALU (
    input [2:0] OP,                 //Señal que indica el tipo de direccionamiento
    input [15:0] Relative,          //Valor del relativo para el direccionamiento
    input [15:0] Data_Segment,      //Datos del registro dee segmento
    input [15:0] Data_IP,           //Datos del registro IP
    input [15:0] Data_Reg1,         //Datos del primer registro de lectura del banco de registros
    input [15:0] Data_Reg2,         //Datos del segundo registro de lectura del banco de registros
    output [19:0] Direction         //Dirección resultante
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
                offset = Data_IP;
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