<%!
from math import ceil, log2
%>\
<%
# (beg - end) / s
if W < 2:
   return

cn_w = W
cn_k = ceil(log2(W + 1))

%>\
module counter #(
    parameter  W  // unused
) (
    input  logic [${cn_w-1}:0] a_i,
    output logic [${cn_k-1}:0] s_o
);

% for i in range(cn_k):
  logic [${(cn_w>>i)-1}:0] p_${i};
% endfor

  assign p_0 = a_i;

% for i in range(cn_k - 1):
  cc${i} i_cc${i}
  (
  .a_i(p_${i}),
  .c_o(p_${i+1}),
  .s_o(s_o[${i}])
  );
% endfor

  assign s_o[${cn_k-1}] = p_${cn_k-1};

endmodule

% for i in range(cn_k - 1):
<%
cc_w = cn_w >> i
cc_k = cc_w // 2
cc_o = cc_w + ((cc_w + 1) % 2)
%>\
module cc${i}
(
   input  logic [${cc_w-1}:0] a_i,
   output logic [${cc_k-1}:0] c_o,
   output logic s_o
);

  logic [${3*cc_k}:0] p;

% if cc_w < cc_o:
  assign p[${cc_w}] = 1'b0;
% endif
  assign p[${cc_w-1}:0] = a_i;

% for i in range(cc_k):
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
  assign p[${i+cc_o}] = y_${i};

% endfor

  assign s_o = p[${3*cc_k}];

endmodule
% endfor
