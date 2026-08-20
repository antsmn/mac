`timescale 1ns / 1ns
module tb_mac;
  parameter W = `W;
  // import pg_pkg::*;

  logic           clk;
  logic           rstn;

  logic           a_signed_i;
  logic           b_signed_i;
  logic           c_signed_i;
  logic [  W-1:0] a_i;
  logic [  W-1:0] b_i;
  logic [  W-1:0] c_i;
  logic [2*W-1:0] p_o;
  logic           v_i;
  logic           v_o;

  parameter       NUM_STAGES = 2;
  initial assert (NUM_STAGES > 0) else $fatal(1);

  logic [         W:0]          a;
  logic [         W:0]          b;
  logic [         W:0]          c;
  logic [     2*W-1:0]          p;

  logic [NUM_STAGES:0][2*W-1:0] res;
  logic [     2*W-1:0]          diff;
  logic                         error;

  initial begin
    clk = 1'b0;
    forever clk = #1 ~clk;
  end
  initial begin
    rstn <= 1'b0;
    @(posedge clk);
    rstn <= 1'b1;
  end

  initial begin
    $dumpfile("tb_mac");
    $dumpvars(0, tb_mac);
    // test_init
    a_signed_i <= '0;
    b_signed_i <= '0;
    c_signed_i <= '0;
    a_i        <= '0;
    b_i        <= '0;
    c_i        <= '0;
    v_i        <= '0;
    @(posedge rstn);
    // driver seq
    repeat (1 << 10) begin
      @(posedge clk);
      a_signed_i <= $random();
      b_signed_i <= $random();
      // c_signed_i <= $random();
      a_i        <= $random();
      b_i        <= $random();
      // c_i        <= $random();
      v_i        <= $random();
      // a_i = 1;
      // b_i = -1;
      #1
      // #2
      assert (!v_o || (v_o && !error))
      else begin
        $fatal(1, "%h %h %h %h %h %h %h", a_signed_i, a_i, b_signed_i, b_i, c_signed_i, c_i, diff);
      end

`ifdef VERBOSE
      $display("%-1t: %b%b %h * %h = %h", $time, a_signed_i, b_signed_i, c_signed_i, a_i, b_i, c_i, p_o);
`endif

    end

    $finish(2);

  end


`ifdef NETLIST
  initial $sdf_annotate(`SDF_FILENAME, DUT);
`endif
  mac DUT (.*);

  assign a = {a_signed_i & a_i[W-1], a_i};
  assign b = {b_signed_i & b_i[W-1], b_i};
  assign c = {c_signed_i & c_i[W-1], c_i};

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) res <= '0;
    else res <= {res[NUM_STAGES-1:0], (2 * W)'($signed(a) * $signed(b) + $signed(c))};
  end

  assign diff  = p_o - res[NUM_STAGES-1];
  assign error = p_o != res[NUM_STAGES-1];

endmodule
