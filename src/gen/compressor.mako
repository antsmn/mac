<%
# (beg - end) / s
if W < 4:
   return
num_fa = W - 2
num_co = W - 3
%>\
module compressor #(
    parameter W = ${W}  // unused
) (
  input  logic [${W-1}:0] a_i,
  input  logic [${W-4}:0] c_i,
  output logic [${W-4}:0] c_o,
  output logic [1:0] s_o
);
  logic [${3*num_fa-1}:0] p;

  assign p[${W-1}:0] = a_i[${W-1}:0];

% for i in range(num_fa - 1):
  wire a_${i} = p[${i*3}];
  wire b_${i} = p[${i*3+1}];
  wire c_${i} = p[${i*3+2}];

  wire y_${i};
  wire x_${i};

  fa i_fa_${i}
  (
  .a_i(a_${i}),
  .b_i(b_${i}),
  .c_i(c_${i}),
  .c_o(x_${i}),
  .s_o(y_${i})
  );

  assign c_o[${i}] = x_${i};

  assign p[${W+i*2+1}] = y_${i};
  assign p[${W+i*2}] = c_i[${i}];

% endfor
<% i = num_fa - 1 %>
  logic a_${i};
  logic b_${i};
  logic c_${i};

  assign a_${i} = p[${(i)*3}];
  assign b_${i} = p[${(i)*3+1}];
  assign c_${i} = p[${(i)*3+2}];

  logic y_${i};
  logic x_${i};

  fa i_fa_${i}
  (
  .a_i(a_${i}),
  .b_i(b_${i}),
  .c_i(c_${i}),
  .c_o(x_${i}),
  .s_o(y_${i})
  );

  assign s_o[1] = x_${i};
  assign s_o[0] = y_${i};

endmodule
