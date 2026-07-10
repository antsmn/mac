module csa5 #(
    parameter W = 8
) (
    input  logic [4:0][W-1:0] p_i,
    output logic [1:0][W-1:0] p_o
);
  logic [W-1:0] p_0;
  logic [W-1:0] p_1;

  logic [  1:0]   c[0:W];

  assign c[0] = 2'b00;

  for (genvar i = 0; i < W; i += 1) begin
    logic [1:0] p;
    logic [4:0] a;

    for (genvar k = 0; k < 5; k = k + 1) begin

      assign a[k] = p_i[k][i];

    end

    compressor5_2 i_compressor5_2 (
        .a_i(a),
        .c_i(c[i]),
        .c_o(c[i+1]),
        .s_o(p)
    );

    assign p_0[i] = p[0];
    assign p_1[i] = p[1];

  end
  assign p_o[0] = p_0;
  assign p_o[1] = p_1 << 1;

endmodule
