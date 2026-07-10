`timescale 1ns / 1ps
module tb_cp;
  parameter W = 8;
  localparam K = $clog2(W + 1);

  logic [      W-1:0] a_i;
  logic [      W-4:0] c_i;
  logic [W+(W-3)-1:0] src;
  logic [        1:0] s_o;
  logic [      W-4:0] c_o;
  logic [      W-4:0] c_1;
  logic [      K-1:0] s_1;
  logic [      K-1:0] res;

  initial begin
    $dumpfile("tb_cp");
    $dumpvars(0, tb_cp);
    a_i = '0;
    c_i = '0;
    repeat (1 << 10) begin
      a_i = $random();
      c_i = $random();
      #1
      assert (s_1 == res)
      else begin
        $fatal(1, "%b %b s_1:%b(%d)", a_i, c_i, s_1, res);
      end
    end
  end
  always @(*) begin
    src = {a_i, c_i};
  end
  always @(*) begin
    s_1 = '0;
    c_1 = '0;
    for (int i = 0; i < W - 3; i += 1) begin
      c_1 += c_o[i];
    end
    s_1 = s_o + (c_1 << 1);
  end
  always @(*) begin
    res = '0;
    for (int i = 0; i < $bits(src); i += 1) begin
      res += src[i];
    end
  end
  compressor #(W) DUT (.*);

endmodule
