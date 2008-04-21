function out = sum(F)
% SUM	Definite integral
% SUM(F) is the integral of F in the interval where it is defined.

% Chebfun Version 2.0

if isempty(F), out = nan; return, end

out = zeros(size(F));
for k = 1:numel(F)
    out(k) = sumcol(F(k));
end

% ------------------------------------------
function out = sumcol(f)

if isempty(f), out = nan; return, end

ends = f.ends;
out = 0;
for i = 1:f.nfuns
    a = ends(i); b = ends(i+1);
    out = out + (b-a)*sum(f.funs(i))/2;
end
if not(isempty(f.imps(2:end,:)))
    out = out + sum(f.imps(end,:));
end
