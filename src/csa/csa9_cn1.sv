module csa #(
    parameter W = 8
) (
    input  logic [8:0][W-1:0] p_i,
    output logic [1:0][W-1:0] p_o
);
  logic [8:0][W-1:0] p0;
  assign p0 = p_i;

  logic [  3:0][W-1:0] p1;
  logic [  3:0][W-1:0] p2;
  logic [  1:0][W-1:0] p3;

  logic [W-1:0][  8:0] t0;
  logic [W-1:0][  3:0] t1;

  genvar i;
  genvar k;

  for (i = 0; i < W; i = i + 1) begin
    for (k = 0; k < 9; k = k + 1) begin

      assign t0[i][k] = p0[k][i];

    end
    for (k = 0; k < 4; k = k + 1) begin

      assign p1[k][i] = t1[i][k];

    end

    counter9_4 i_counter9_4 (.a_i(t0[i]), .s_o(t1[i]));

  end
  assign p2[0] = p1[0];
  assign p2[1] = p1[1] << 1;
  assign p2[2] = p1[2] << 2;
  assign p2[3] = p1[3] << 3;

  logic [W:0] c;

  assign c[0] = 1'b0;

  for (i = 0; i < W; i = i + 1) begin

    logic [3:0] a;
    logic [1:0] p;

    for (k = 0; k < 4; k = k + 1) begin

      assign a[k] = p2[k][i];

    end

    compressor4_2 i_compressor4_2 (
        .a_i(a),
        .c_i(c[i]),
        .c_o(c[i+1]),
        .s_o(p)
    );

    assign p3[0][i] = p[0];
    assign p3[1][i] = p[1];

  end
  assign p_o[0] = p3[0];
  assign p_o[1] = p3[1] << 1;

endmodule
