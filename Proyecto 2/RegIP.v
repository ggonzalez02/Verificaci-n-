//////////////////////////////////////////////////////////////////////////////////
// University:  Instituto Tecnológico de Costa Rica                             
// Engineers:   Anthony Artavia                                                 
//              Maricruz Campos                                                 
//              Gabriel González                                                
//  
// Module Name: RegIP
// Description: Registro correspondiente al segmento IP
//////////////////////////////////////////////////////////////////////////////////

module RegIP (
    input clk,
    input rst,
    input EN,       //0: Mantener Q, 1: Escribir en Q  
    input SEL,      //0: Sumar 1 a Q, 1: Escribir en Data_In
    input [7:0] D,  //Dato de entrada
    output [7:0] Q  //Dato de salida
);
    //Registro interno de escritura
    reg [7:0] Data_In;

    //Multiplexor para decidir el valor a escribir en Q
    always @(Q or D or SEL) begin
        case (SEL)
            1'b0: Data_In = Q + 1;
            1'b1: Data_In = D; 
        endcase
    end

    //Estructura habitual de un registro
    always @(posedge clk or posedge rst) begin
    if (rst)
        Q <= 8'h00;
    else if (EN)
        Q <= Data_In;
    else
        Q <= Q;
    end
    
endmodule