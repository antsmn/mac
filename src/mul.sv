module mul
  import pg_pkg::*;
(
    input  logic           clk,
    input  logic           rstn,
    input  logic           v_i,
    input  logic           a_signed_i,
    input  logic           b_signed_i,
    input  logic [  W-1:0] a_i,
    input  logic [  W-1:0] b_i,
    output logic           v_o,
    output logic [2*W-1:0] p_o
);
  logic c_signed_i;
  assign c_signed_i = 1'b0;

  logic [W-1:0] c_i;
  assign c_i = '0;

  mac i_mac (.*);

endmodule
