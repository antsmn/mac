module be #(
    parameter W = 18,
    parameter E = 8// this param change fanout on neg select for booth encoded pp
            // cpa is out of critical path
) (
    // bias
    input  logic [W-1:0] k_i,
    // mux src
    input  logic [W-1:0] a1_i,
    input  logic [W-1:0] a2_i,
    input  logic [W-1:0] a3_i,
    input  logic [W-1:0] a4_i,
    input  logic [W-1:0] y1_i,
    input  logic [W-1:0] y2_i,
    input  logic [W-1:0] y3_i,
    input  logic [W-1:0] y4_i,
    // select src
    input  logic [  3:0] x_i,
    // redundant pp
    output logic [W-1:0] p_o,
    output logic [W-1:0] y_o,
    output logic         n_o
);
  logic x0;
  logic x1;
  logic x2;
  logic x3;
  logic x4;
  logic xn;
  // redundant PP
  logic [W-1:0] a1;
  logic [W-1:0] a2;
  logic [W-1:0] a3;
  logic [W-1:0] a4;
  logic [W-1:0] y1;
  logic [W-1:0] y2;
  logic [W-1:0] y3;
  logic [W-1:0] y4;

  wire [1:0]    x1_0 = x_i[1:0];
  wire [1:0]    x1_0_b = ~x_i[1:0];

  wire [2:0]    x2_0 = x_i[2:0];
  wire [2:0]    x2_0_b = ~x_i[2:0];

  wire [1:0]    x3_2 = x_i[3:2];

  assign x2 = x_i[2] ? (&x1_0_b) : &x1_0;
  assign x4 = x_i[3] ? (&x2_0_b) : &x2_0;
  assign x1 = (^x1_0) & ~(^x3_2);
  assign x3 = (^x1_0) &  (^x3_2);
  assign xn  = (x_i[3] & ~(&x2_0));

  logic [W-1:0] n_mask_y;
  logic [W-1:0] n_mask_p;

  always @(*) begin
    n_mask_y = '0;
    for (int i = E + 2; i < W ; i += E) n_mask_y[i] = xn;

  end
  assign n_mask_p = {W{xn}};

  assign y1 = y1_i ^ n_mask_y;
  assign y2 = y2_i ^ n_mask_y;
  assign y3 = y3_i ^ n_mask_y;
  assign y4 = y4_i ^ n_mask_y;
  assign a1 = a1_i ^ n_mask_p;
  assign a2 = a2_i ^ n_mask_p;
  assign a3 = a3_i ^ n_mask_p;
  assign a4 = a4_i ^ n_mask_p;

  assign x0 = (&x_i | ~(|x_i));

  assign p_o = (k_i & ({W{x0}})) |
               (a1  & ({W{x1}})) |
               (a2  & ({W{x2}})) |
               (a3  & ({W{x3}})) |
               (a4  & ({W{x4}}));

  assign y_o = (y1 & ({W{x1}})) | (y2 & ({W{x2}})) | (y3 & ({W{x3}})) | (y4 & ({W{x4}}));

  assign n_o = xn;

endmodule
