module csa #(
    parameter W = 8
) (
    input  logic [4:0][W-1:0] p_i,
    output logic [1:0][W-1:0] p_o
);
  logic [4:0][W-1:0] p0;

  assign p0 = p_i;

  logic [1:0][W-1:0] p1;

  genvar i;
  genvar k;

  logic [W:0]      c[0:1];

  // logic [W:0][1:0] c;

  assign c[0] = 2'b00;

  for (i = 0; i < W; i += 1) begin

    logic [1:0] p;
    logic [4:0] a;

    for (k = 0; k < 5; k += 1) begin

      assign a[k] = p0[k][i];

    end

    compressor5_2 i_compressor5_2 (
        .a_i(a),
        .c_i(c[i]),
        .c_o(c[i+1]),
        .s_o(p)
    );

    assign p1[1][i] = p[1];
    assign p1[0][i] = p[0];

  end
  assign p_o[0] = p1[0];
  assign p_o[1] = p1[1] << 1;

endmodule
