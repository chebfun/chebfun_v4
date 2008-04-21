function Fout = comp(F, op)
% Composition of a chebfun with the function op, i.e., Fout=op(F)
%

%Note: this function does not deal with deltas!

Fout=F;
for k = 1:numel(F)
    Fout(k) = chebfun(@(x) op(feval(F(k),x)), F(k).ends);
end