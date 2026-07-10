module pg_a1 #(
    parameter W,
    parameter E
) (
    input  logic [W-1:0] a_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] y_o
);
  always @(*) begin
    p_o = a_i;
    for (int i = E + 1; i < W - 2; i += E) p_o[i] = ~a_i[i];
  end
  always @(*) begin
    y_o = '0;
    for (int i = E + 2; i < W - 1; i += E) y_o[i] = a_i[i-1];
  end

endmodule
