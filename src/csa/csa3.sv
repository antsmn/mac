module csa3 #(
    parameter W = 8
) (
    input  logic [2:0][W-1:0] p_i,
    output logic [1:0][W-1:0] p_o
);
  fa i_fa[W-1:0] (.a_i(p_i[0]), .b_i(p_i[1]), .c_i(p_i[2]), .c_o(p_o[1]), .s_o(p_o[0]));


endmodule
