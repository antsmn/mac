module csa #(
    parameter W = 8
) (
    input  logic [8:0][W-1:0] p_i,
    output logic [1:0][W-1:0] p_o
);
  logic [8:0][W-1:0] p0;

  assign p0 = p_i;

  logic [3:0][W-1:0] p1;
  logic [3:0][W-1:0] p2;
  logic [1:0][W-1:0] p3;

  genvar i;
  genvar k;

  logic [W:0][1:0] c1;
  logic [W:0] c2;

  assign c1[0] = 2'b00;
  assign c2[0] = 1'b0;

  for (i = 0; i < W; i = i + 1) begin

    logic [8:0] a;
    logic [3:0] p;

    for (k = 0; k < 9; k = k + 1) begin

      assign a[k] = p0[k][i];

    end

    compressor5_2 i_compressor5_2 (
        .a_i(a[8:4]),
        .c_i(c1[i]),
        .c_o(c1[i+1]),
        .s_o(p[3:2])
    );
    compressor4_2 i_compressor4_2 (
        .a_i(a[3:0]),
        .c_i(c2[i]),
        .c_o(c2[i+1]),
        .s_o(p[1:0])
    );

    assign p1[0][i] = p[0];
    assign p1[1][i] = p[1];
    assign p1[2][i] = p[2];
    assign p1[3][i] = p[3];

  end
  assign p2[2] = p1[0];
  assign p2[3] = p1[2];
  assign p2[0] = p1[1] << 1;
  assign p2[1] = p1[3] << 1;

  logic [W:0] c3;

  assign c3[0] = 1'b0;

  for (i = 0; i < W; i = i + 1) begin

    logic [3:0] a;
    logic [1:0] p;

    for (k = 0; k < 4; k = k + 1) begin

      assign a[k] = p2[k][i];

    end

    compressor4_2 i_compressor4_2 (
        .a_i(a),
        .c_i(c3[i]),
        .c_o(c3[i+1]),
        .s_o(p)
    );

    assign p3[0][i] = p[0];
    assign p3[1][i] = p[1];

  end
  assign p_o[0] = p3[0];
  assign p_o[1] = p3[1] << 1;

endmodule
