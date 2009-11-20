function e = isempty(A)
% ISEMPTY   True for empty nonlinop.

e = isempty(A.dom) && isempty(A.op);

end