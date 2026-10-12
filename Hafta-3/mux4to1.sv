// 8 bit 4x1 mux
// sel: 00->d0, 01->d1, 10->d2, 11->d3

module mux4to1 #(parameter WIDTH = 8) (
    input  logic [WIDTH-1:0] d0, d1, d2, d3,
    input  logic [1:0]       sel,
    output logic [WIDTH-1:0] y
);

    always_comb begin
        case (sel)
            2'b00:   y = d0;
            2'b01:   y = d1;
            2'b10:   y = d2;
            2'b11:   y = d3;
            default: y = '0;
        endcase
    end

endmodule
