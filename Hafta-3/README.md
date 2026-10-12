# Hafta 3 - 8 Bit 4x1 Mux

8 bit genişliğinde 4x1 multiplexer tasarımı ve testbench.

- `mux4to1.sv` : mux modülü
- `tb_mux4to1.sv` : testbench

| sel | y  |
|-----|----|
| 00  | d0 |
| 01  | d1 |
| 10  | d2 |
| 11  | d3 |

## Çalıştırma

```
iverilog -g2012 -o sim mux4to1.sv tb_mux4to1.sv
vvp sim
```

Dalga formu için `gtkwave mux4to1.vcd`
