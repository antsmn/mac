module be #(
  parameter W = 17
) (
  input  logic [W-1:0] a1_i,
  input  logic [W-1:0] a2_i,
  input  logic [  1:0] x_i,
  input  logic         c_i,
  output logic [W-1:0] p_o,
  output logic         n_o
);
  // generate -A and carry out for + 3A encoding, use prefix-tree to generate carry out in log stages

  logic [W-1:0] a1;
  logic [W-1:0] a2;
  logic         x1;
  logic         x2;
  logic         xn;

  always @(*) begin
    x1 = 1'b0;
    x2 = 1'b0;
    xn = 1'b0;
    case ({x_i, c_i})
      3'b000:  ;
      3'b010:  x1 = 1'b1;
      3'b001:  x1 = 1'b1;
      3'b011:  x2 = 1'b1;
      3'b100:  x2 = 1'b1;
      3'b101:  xn = 1'b1;  // -A
      3'b110:  xn = 1'b1;  // -A
      3'b111:  ;
      default: ;
    endcase
  end

  assign p_o = (a1_i & ({W{x1}})) | (a2_i & ({W{x2}})) | (~a1_i & ({W{xn}}));

  assign n_o = xn;

endmodule
