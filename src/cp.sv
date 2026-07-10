module compressor #(
    parameter W = 8
) (
    input  logic [W-1:0] a_i,
    input  logic [W-4:0] c_i,
    output logic [W-4:0] c_o,
    output logic [  1:0] s_o
);
  logic [W-1:0] c_0[2:W];
  logic [W-1:0] c_1[2:W];

  always @(*) begin
    int i;
    int n;
    int k;

    c_o = '0;

    // enumerate stage i indexed by number of pp n in unpacked array
    i = 0;
    for (n = W; n > 3; n -= n / 3) begin
      for (k = 0; k < n / 3; k += 1) begin

        c_0[n][k] = c_i[i];
        c_o[i]    = c_1[n][k];

        i += 1;
      end
    end
  end

  logic [W-1:0] p[2:W];

  assign p[W] = a_i;

  genvar n;
  genvar k;

  for (n = W; n > 3; n -= n / 3) begin
    for (k = 0; k < n / 3; k += 1) begin

      logic a;
      logic b;
      logic c;

      assign a = p[n][k*3];
      assign b = p[n][k*3+1];
      assign c = p[n][k*3+2];

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
      assign p[n-(n/3)][(n%3)+k] = c_0[n][k];
      assign p[n-(n/3)][(n%3)+(n/3)+k] = so;
      assign c_1[n][k] = co;

    end
    for (k = 0; k < n % 3; k += 1) begin
      assign p[n-(n/3)][k] = p[n][n-1-k];
    end
  end
  logic a;
  logic b;
  logic c;

  assign a = p[3][0];
  assign b = p[3][1];
  assign c = p[3][2];

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
  assign s_o[0] = so;
  assign s_o[1] = co;

endmodule
