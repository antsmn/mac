module csa #(
    parameter K = 8,
    parameter W = 16
) (
    input  logic [K-1:0][W-1:0] p_i,
    output logic [  1:0][W-1:0] p_o
);

  // sparse unpacked array index by number of pps each stage

  logic [K-1:0][W-1:0] p[2:K];

  assign p[K] = p_i;

  genvar i;
  genvar k;

  for (i = K; i > 3; i -= (i / 4) * 2) begin

    localparam N = i - (i / 4) * 2;

    localparam Q = i / 4;
    localparam Z = i % 4;

    for (k = 0; k < Q; k += 1) begin

      logic [3:0][W-1:0] p_0;
      logic [1:0][W-1:0] p_1;

      assign p_0 = p[i][k*4+:4];

      csa4 #(W) i_csa4 (.p_i(p_0),
                        .p_o(p_1));
      assign p[N][Z+Q+k] = p_1[0];
      assign p[N][Z+k] = p_1[1] << 1;

    end
    for (k = 0; k < Z; k += 1) begin

      assign p[N][k] = p[i][i-1-k];

    end
    if (N == 3) begin
      logic [2:0][W-1:0] p_0;
      logic [1:0][W-1:0] p_1;

      assign p_0 = p[3][2:0];

      fa i_fa[W-1:0] (.a_i(p_0[0]),
                      .b_i(p_0[1]),
                      .c_i(p_0[2]),
                      .s_o(p_1[0]),
                      .c_o(p_1[1]));
      assign p[2][1] = p_1[0];
      assign p[2][0] = p_1[1] << 1;
    end
  end
  assign p_o[1] = p[2][1];
  assign p_o[0] = p[2][0];

endmodule
