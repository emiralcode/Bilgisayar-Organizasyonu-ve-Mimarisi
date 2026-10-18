`timescale 1ns/1ps

module tb_adder4bit;

    logic [3:0] a, b;
    logic       cin;
    logic [3:0] sum;
    logic       cout;

    int hata = 0;

    adder4bit uut (
        .a(a), .b(b), .cin(cin),
        .sum(sum), .cout(cout)
    );

    initial begin
        $dumpfile("adder4bit.vcd");
        $dumpvars(0, tb_adder4bit);

        for (int i = 0; i < 16; i++)
            for (int j = 0; j < 16; j++)
                for (int k = 0; k < 2; k++) begin
                    a = i; b = j; cin = k;
                    #10;
                    if ({cout, sum} !== i + j + k) begin
                        hata++;
                        $display("HATA: %0d + %0d + %0d = %0d", a, b, cin, {cout, sum});
                    end
                end

        a = 4'd5;  b = 4'd3; cin = 0; #10 $display("%0d + %0d + %0d = %0d", a, b, cin, {cout, sum});
        a = 4'd15; b = 4'd1; cin = 0; #10 $display("%0d + %0d + %0d = %0d", a, b, cin, {cout, sum});
        a = 4'd9;  b = 4'd7; cin = 1; #10 $display("%0d + %0d + %0d = %0d", a, b, cin, {cout, sum});

        if (hata == 0)
            $display("Tum testler gecti");
        else
            $display("%0d hata bulundu", hata);

        $finish;
    end

endmodule
