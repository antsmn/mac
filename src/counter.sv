module counter #(
    parameter  W,
    localparam K = $clog2(W + 1)
) (
    input  logic [W-1:0] a_i,
    output logic [K-1:0] s_o
);

  // C. C. Foster and F. D. Stockton, "Counting Responders in an Associative Memory"

  logic [W-1:0] p_1[0:K-1];

  assign p_1[0] = a_i;

  for (genvar i = 0; i < K - 1; i += 1) begin

    cc #(W / (2 ** i)) i_cc
    (
        .a_i(p_1[i]),
        .c_o(p_1[i+1]),
        .s_o(s_o[i])
    );

  end
  assign s_o[K-1] = p_1[K-1];

endmodule

module cc #(
    parameter W
) (
    input  logic [  W-1:0] a_i,
    output logic [W/2-1:0] c_o,
    output logic           s_o
);
  localparam NUM_FA = W / 2;

  logic [3*NUM_FA:0] p_1;

  localparam W_ODD = W + ((W + 1) % 2);

  if (W < W_ODD) begin

    assign p_1[W] = 1'b0;

  end
  assign p_1[W-1:0] = a_i;

  for (genvar i = 0; i < NUM_FA; i += 1) begin

    logic a;
    logic b;
    logic c;

    assign a = p_1[i*3];
    assign b = p_1[i*3+1];
    assign c = p_1[i*3+2];

    logic so;
    logic co;

    fa i_fa
    (
        .a_i(a),
        .b_i(b),
        .c_i(c),
        .c_o(co),
        .s_o(so)
    );

    assign p_1[i+W_ODD] = so;
    assign c_o[i] = co;

  end
  assign s_o = p_1[3*NUM_FA];

endmodule
