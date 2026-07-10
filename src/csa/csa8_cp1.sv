module csa #(
    parameter W = 8
) (
    input  logic [7:0][W-1:0] p_i,
    output logic [1:0][W-1:0] p_o
);
  logic [7:0][W-1:0] p0;

  assign p0 = p_i;

  logic [3:0][W-1:0] p1;
  logic [3:0][W-1:0] p2;
  logic [1:0][W-1:0] p3;

  genvar i;
  genvar k;

  logic [W:0] c[0:2];

  assign c[2][0] = 1'b0;
  assign c[1][0] = 1'b0;
  assign c[0][0] = 1'b0;

  for (i = 0; i < W; i = i + 1) begin

    logic [7:0] a;
    logic [3:0] p;

    for (k = 0; k < 8; k = k + 1) begin

      assign a[k] = p0[k][i];

    end

    compressor4_2 i_compressor4_2_1 (
        .a_i(a[7:4]),
        .c_i(c[1][i]),
        .c_o(c[1][i+1]),
        .s_o(p[3:2])
    );
    compressor4_2 i_compressor4_2_2 (
        .a_i(a[3:0]),
        .c_i(c[0][i]),
        .c_o(c[0][i+1]),
        .s_o(p[1:0])
    );

    assign p1[0][i] = p[0];
    assign p1[1][i] = p[1];
    assign p1[2][i] = p[2];
    assign p1[3][i] = p[3];

  end
  assign p2[0] = p1[0];
  assign p2[2] = p1[2];
  assign p2[1] = p1[1] << 1;
  assign p2[3] = p1[3] << 1;

  for (i = 0; i < W; i = i + 1) begin

    logic [3:0] a;
    logic [1:0] p;

    for (k = 0; k < 4; k = k + 1) begin

      assign a[k] = p2[k][i];

    end

    compressor4_2 i_compressor4_2 (
        .a_i(a),
        .c_i(c[2][i]),
        .c_o(c[2][i+1]),
        .s_o(p)
    );

    assign p3[0][i] = p[0];
    assign p3[1][i] = p[1];

  end
  assign p_o[0] = p3[0];
  assign p_o[1] = p3[1] << 1;

endmodule
