// ALU - Testbench
`timescale 1ns/1ps

module alu_tb;

    localparam int WIDTH = 4;

    logic [WIDTH-1:0] a, b;
    logic [1:0]       select;
    logic [WIDTH-1:0] cikti;
    logic             carry;

    int hata = 0;

    alu #(.WIDTH(WIDTH)) dut (
        .a(a), .b(b), .select(select),
        .cikti(cikti), .carry(carry)
    );

    // Beklenen sonucu hesaplayip karsilastiran gorev
    task automatic test(input logic [WIDTH-1:0] ta, tb, input logic [1:0] tsel);
        logic [WIDTH:0] beklenen;
        string islem;
        a = ta; b = tb; select = tsel;
        #10;
        case (tsel)
            2'b00: begin beklenen = ta + tb;         islem = "TOPLAMA"; end
            2'b01: begin beklenen = ta - tb;         islem = "CIKARMA"; end
            2'b10: begin beklenen = {1'b0, ta & tb}; islem = "AND    "; end
            2'b11: begin beklenen = {1'b0, ta | tb}; islem = "OR     "; end
        endcase
        if ({carry, cikti} !== beklenen) begin
            $display("HATA  | %s a=%b b=%b -> cikti=%b carry=%b (beklenen %b)",
                     islem, a, b, cikti, carry, beklenen);
            hata++;
        end else
            $display("DOGRU | %s a=%b (%0d) b=%b (%0d) -> cikti=%b (%0d) carry=%b",
                     islem, a, a, b, b, cikti, cikti, carry);
    endtask

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        $display("---- Toplama (00) ----");
        test(4'd3,  4'd5,  2'b00);
        test(4'd9,  4'd8,  2'b00);   // tasma -> carry=1

        $display("---- Cikarma (01) ----");
        test(4'd12, 4'd5,  2'b01);
        test(4'd3,  4'd7,  2'b01);   // negatif -> borc=1

        $display("---- AND (10) ----");
        test(4'b1100, 4'b1010, 2'b10);
        test(4'b1111, 4'b0101, 2'b10);

        $display("---- OR (11) ----");
        test(4'b1100, 4'b1010, 2'b11);
        test(4'b0000, 4'b0110, 2'b11);

        // Tum kombinasyonlari otomatik dene
        for (int s = 0; s < 4; s++)
            for (int i = 0; i < 16; i++)
                for (int j = 0; j < 16; j++) begin
                    a = i; b = j; select = s; #1;
                end

        $display("--------------------");
        if (hata == 0) $display("Tum testler BASARILI");
        else           $display("%0d hata bulundu", hata);
        $finish;
    end

endmodule
