module be #(
    parameter W = 18
) (
    input  logic [W-1:0] a1_i,
    input  logic [W-1:0] a2_i,
    input  logic [W-1:0] a3_i,
    input  logic [W-1:0] a4_i,
    input  logic [  3:0] x_i,
    output logic [W-1:0] p_o,
    output logic         n_o
);
  logic x1;
  logic x2;
  logic x3;
  logic x4;
  logic xn;
  logic [W-1:0] a1;
  logic [W-1:0] a2;
  logic [W-1:0] a3;
  logic [W-1:0] a4;

  wire [1:0]    x1_0 = x_i[1:0];
  wire [1:0]    x1_0_b = ~x_i[1:0];

  wire [2:0]    x2_0 = x_i[2:0];
  wire [2:0]    x2_0_b = ~x_i[2:0];

  assign x2 = x_i[2] ? (&x1_0_b) : &x1_0;
  assign x4 = x_i[3] ? (&x2_0_b) : &x2_0;
  assign x1 = (^x1_0) & ~(^x_i[3:2]);
  assign x3 = (^x1_0) &  (^x_i[3:2]);
  assign xn  = (x_i[3] & ~(&x2_0));

  assign a1 = (a1_i ^ ({W{xn}}));
  assign a2 = (a2_i ^ ({W{xn}}));
  assign a3 = (a3_i ^ ({W{xn}}));
  assign a4 = (a4_i ^ ({W{xn}}));

  assign p_o = (a1 & ({W{x1}})) | (a2 & ({W{x2}})) | (a3 & ({W{x3}})) | (a4 & ({W{x4}}));

  assign n_o = xn;

endmodule
