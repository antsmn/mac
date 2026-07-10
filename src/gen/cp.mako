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
<%
n = W
i = 0
c = 0
%>
  wire [${n-1}:0] p_0;

  assign p_0 = a_i;

% while n > 3:
  // stage ${i}

  wire [${n-n//3-1}:0] p_${i+1};

% for k in range(n // 3):
  // fa ${k}

  wire a_${i}_${k} = p_${i}[${k*3+2}];
  wire b_${i}_${k} = p_${i}[${k*3+1}];
  wire c_${i}_${k} = p_${i}[${k*3+0}];

  wire x_${i}_${k};
  wire y_${i}_${k};

  fa i_fa_${i}_${k}
  (
  .a_i(a_${i}_${k}),
  .b_i(b_${i}_${k}),
  .c_i(c_${i}_${k}),
  .c_o(x_${i}_${k}),
  .s_o(y_${i}_${k})
  );

  assign c_o[${c}] = x_${i}_${k};

  assign p_${i+1}[${(n%3)+(n//3)+k}] = y_${i}_${k};
  assign p_${i+1}[${(n%3)+k}] = c_i[${c}];
<%
c += 1
%>
% endfor
% for k in range(n % 3):
  assign p_${i+1}[${k}] = p_${i}[${n-1-k}];
% endfor
<%
i += 1
n -= n // 3
%>
% endwhile

  // stage ${i}

  // fa 0

  wire a_${i}_0 = p_${i}[0];
  wire b_${i}_0 = p_${i}[1];
  wire c_${i}_0 = p_${i}[2];

  wire x_${i}_0;
  wire y_${i}_0;

  fa i_fa_${i}_0 (
  .a_i(a_${i}_0),
  .b_i(b_${i}_0),
  .c_i(c_${i}_0),
  .c_o(x_${i}_0),
  .s_o(y_${i}_0)
  );

  assign s_o[1] = x_${i}_0;
  assign s_o[0] = y_${i}_0;

endmodule
