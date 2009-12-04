function e = isempty(A)
% ISEMPTY   True for empty chebop.

e = isempty(A.dom) && isempty(A.op);

end