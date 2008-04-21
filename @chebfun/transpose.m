function F = transpose(F)
% .'	Transpose
% F.' is the non-conjugate transpose of F.

% Chebfun Version 2.0

for k = 1:numel(F), F(k).trans=not(F(k).trans); end
