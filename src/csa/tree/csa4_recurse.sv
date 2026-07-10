module csa #(
    parameter K = 8,
    parameter W = 16
) (
    input  logic [K-1:0][W-1:0] p_i,
    output logic [K-1:0][W-1:0] p_o
);
  localparam m = K - (K / 4) * 2;

  logic [m-1:0][W-1:0] p;

  if (K == 2) begin

    assign p_o = p_i;

  end else if (K == 3) begin

    logic [1:0][W-1:0] p_1;

    fa i_fa[W-1:0] (.a_i(p_i[0]),
                    .b_i(p_i[1]),
                    .c_i(p_i[2]),
                    .s_o(p_1[0]),
                    .c_o(p_1[1]));

    assign p_o[0] = p_1[0];
    assign p_o[1] = p_1[1] << 1;

  end else if (K > 3) begin

    for (genvar k = 0; k < K / 4; k += 1) begin

      logic [1:0][W-1:0] p_1;

      csa4 #(W) i_csa4 (.p_i(p_i[k*4+:4]),
                        .p_o(p_1));

      assign p[(K%4)+2*k+1] = p_1[0];
      assign p[(K%4)+2*k]   = p_1[1] << 1;

    end
    for (genvar k = 0; k < K % 4; k++) begin

      assign p[k] = p_i[K-1-k];

    end

    csa #(m, W) i_csa (.p_i(p), .p_o(p_o[m-1:0]));

  end

endmodule
