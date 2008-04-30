function out = sum(F,dim)
% SUM	Definite integral or chebfun sum.
% If F is a chebfun, SUM(F) is the integral of F in the interval 
% where it is defined.
%
% If F is a quasimatrix, SUM(F,DIM) sums along the dimension DIM. Summing 
% in the chebfun dimension does a definite integral of each chebfun; 
% in the indexed dimension adds together all of the chebfuns to return a
% single chebfun.
%
% For a quasimatrix, SUM(F) is the same as SUM(F,1).
%
% Examples:
%   x = chebfun('x',[0 1]);
%   sum(x)      % returns 1/2
%   A = [x.^0 x.^1 x.^2];  
%   sum(A)      % integrates three functions
%   sum(A,2)    % returns the chebfun for 1+x+x^2
%   sum(A.',2)  % transpose of sum(A,1)
%
% See also SUM (built-in).

% Chebfun Version 2.0

if isempty(F), out = nan; return, end

if nargin < 2
  dim = 1;
end

F_trans = F.trans;
if F_trans
  F = transpose(F);
  dim = 3-dim;
end

if dim==1
  out = zeros(size(F));
  for k = 1:numel(F)
    out(k) = sumcol(F(k));
  end
else
  out = F*ones(size(F,2),1);
end
  
if F_trans
  out = transpose(out);
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
