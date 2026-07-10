module csa #(
    parameter W = 8
) (
    input  logic [8:0][W-1:0] p_i,
    output logic [1:0][W-1:0] p_o
);
  logic [8:0][W-1:0] p0;

  assign p0 = p_i;

  logic [1:0][W-1:0] p1;

  genvar i;
  genvar k;

  logic [W:0][5:0] c;

  assign c[0] = 6'b0;

  for (i = 0; i < W; i = i + 1) begin

    logic [8:0] a;
    logic [1:0] p;

    for (k = 0; k < 9; k = k + 1) begin

      assign a[k] = p0[k][i];

    end

    compressor9_2 i_compressor9_2 (
        .a_i(a),
        .c_i(c[i]),
        .c_o(c[i+1]),
        .s_o(p)
    );

    assign p1[0][i] = p[0];
    assign p1[1][i] = p[1];

  end
  assign p_o[0] = p1[0];
  assign p_o[1] = p1[1] << 1;

endmodule
