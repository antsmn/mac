module pg_a3 #(
    parameter W,
    parameter E
) (
    input  logic [W-1:0] a_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] y_o
);
  // num cpa blocks
  localparam N = W / E;

  logic [N-1:0][E-1:0] a1;
  logic [N-1:0][E-1:0] a2;
  logic [N-1:0][E-1:0] s;
  logic [N-1:0]        c;

  // generate cpa blocks
  for (genvar i = 0; i < N; i += 1) begin

    assign a2[i] = a_i[(i*E)+:E];
    assign a1[i] = a_i[(i*E+1)+:E];
  end
  for (genvar i = 0; i < N; i += 1) begin
    assign {c[i], s[i]} = a1[i] + a2[i];
  end
  // bias has 1'b1 at cout of every cpa blocks

  // sum + carry + 1 fa
  logic [N-1:0] x;
  logic [N-1:0] y;
  for (genvar i = 1; i < N; i += 1) begin

    assign y[i] = s[i][0] | c[i-1];
    assign x[i] = ~(s[i][0] ^ c[i-1]);
  end
  // align
  always @(*) begin
    y_o = '0;
    for (int i = 1; i < N; i += 1) begin

      y_o[i*E+2] = y[i];
    end
  end
  for (genvar i = 1; i < N; i += 1) begin

    assign p_o[i*E+1+:E] = {s[i][E-1:1], x[i]};
  end
  assign p_o[W-1] = c[N-1];
  assign p_o[E:0] = {s[0], a_i[0]};

endmodule
