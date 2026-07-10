module csa #(
    parameter W = 8
) (
    input  logic [4:0][W-1:0] p_i,
    output logic [1:0][W-1:0] p_o
);
  logic [4:0][W-1:0] p0;
  assign p0 = p_i;

  logic [  2:0][W-1:0] p1;
  logic [  2:0][W-1:0] p2;
  logic [  1:0][W-1:0] p3;

  logic [W-1:0][  4:0] t0;
  logic [W-1:0][  2:0] t1;

  genvar i;
  genvar k;

  for (i = 0; i < W; i = i + 1) begin
    for (k = 0; k < 5; k = k + 1) begin

      assign t0[i][k] = p0[k][i];

    end
    for (k = 0; k < 3; k = k + 1) begin

      assign p1[k][i] = t1[i][k];

    end

    counter5_3 i_counter5_3 (.a_i(t0[i]), .s_o(t1[i]));

  end
  assign p2[0] = p1[0];
  assign p2[1] = p1[1] << 1;
  assign p2[2] = p1[2] << 2;


  for (i = 0; i < W; i = i + 1) begin  // : cp3

    wire  a = p2[2][i];
    wire  b = p2[1][i];
    wire  c = p2[0][i];

    logic co;
    logic so;

    fa i_fa
    (
        .a_i(a),
        .b_i(b),
        .c_i(c),
        .c_o(co),
        .s_o(so)
    );

    assign p3[0][i] = so;
    assign p3[1][i] = co;

  end
  assign p_o[0] = p3[0];
  assign p_o[1] = p3[1] << 1;

endmodule
