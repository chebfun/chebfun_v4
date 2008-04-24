function out = eq(F1,F2)
% ==	Equal
%  F1 == F2 compares funs F1 and F2 and returns one if F1 and F2 are
%  equal and zero otherwise.
%

% Chebfun Version 2.0

if numel(F1) ~= numel(F2) || F1(1).trans ~= F2(1).trans
    out = false;
else
    out = true;
    for k =1: numel(F1)
        out = out && norm(F1(k)-F2(k),inf) < 1e-15*min(F1(k).scl,F2(k).scl);
    end
end