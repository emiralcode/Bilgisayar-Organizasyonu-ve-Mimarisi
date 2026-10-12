`timescale 1ns/1ps

module tb_mux4to1;

    logic [7:0] d0, d1, d2, d3;
    logic [1:0] sel;
    logic [7:0] y;
    logic [7:0] beklenen;

    int hata = 0;
    int sayac = 0;

    mux4to1 #(.WIDTH(8)) uut (
        .d0(d0), .d1(d1), .d2(d2), .d3(d3),
        .sel(sel),
        .y(y)
    );

    task kontrol(input logic [1:0] s);
        sel = s;
        #10;
        case (s)
            2'b00: beklenen = d0;
            2'b01: beklenen = d1;
            2'b10: beklenen = d2;
            2'b11: beklenen = d3;
        endcase
        sayac++;
        if (y !== beklenen) begin
            hata++;
            $display("HATA: sel=%b y=%h beklenen=%h", sel, y, beklenen);
        end
    endtask

    initial begin
        $dumpfile("mux4to1.vcd");
        $dumpvars(0, tb_mux4to1);

        // sabit degerler
        d0 = 8'hAA; d1 = 8'h55; d2 = 8'hF0; d3 = 8'h0F;
        for (int i = 0; i < 4; i++) begin
            kontrol(i);
            $display("sel=%b  y=%h", sel, y);
        end

        d0 = 8'h00; d1 = 8'hFF; d2 = 8'h00; d3 = 8'hFF;
        for (int i = 0; i < 4; i++) kontrol(i);

        // rastgele degerler
        repeat (100) begin
            d0 = $urandom; d1 = $urandom; d2 = $urandom; d3 = $urandom;
            for (int i = 0; i < 4; i++) kontrol(i);
        end

        if (hata == 0)
            $display("Tum testler gecti (%0d test)", sayac);
        else
            $display("%0d hata bulundu (%0d test)", hata, sayac);

        $finish;
    end

endmodule
