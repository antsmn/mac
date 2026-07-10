`timescale 1ns / 1ns
module tb_counter;

  parameter W = 8;

  localparam K = $clog2(W + 1);
  logic [W-1:0] a_i;
  logic [K-1:0] s_o;
  logic [K-1:0] res;
  logic [K-1:0] diff;
  logic         error;
  initial begin
    $dumpfile("tb_counter");
    $dumpvars(0, tb_counter);
    a_i = 0;
    repeat (1 << 10) begin
      a_i = $random();
      #1
      assert (!error)
      else begin
        $error(1, "%b %b %b %b", a_i, s_o, res, diff);
      end
    end
  end
  counter #(W) DUT (.*);

  always @(*) begin
    res = '0;
    for (int i = 0; i < W; i += 1) res += a_i[i];
  end
  assign diff  = s_o - res;
  assign error = s_o != res;

endmodule
