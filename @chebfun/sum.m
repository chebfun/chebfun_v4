function out = sum(F,dim)
% SUM	Definite integral or chebfun sum.
% If F is a chebfun, SUM(F) is the integral of F in the interval 
% where it is defined.
%
% If F is a quasimatrix, SUM(F,DIM) sums along the dimension DIM. Summing 
% in the chebfun dimension computes a definite integral of each chebfun; 
% summing in the indexed dimension adds together all of the chebfuns to
% return a single chebfun.
%
% For a column quasimatrix, SUM(F) is the same as SUM(F,1).
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
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if isempty(F), out = 0; return, end    % empty chebfun has sum 0

F_trans = F(1).trans;                  % default sum along columns
if nargin < 2
    if min(size(F))==1 && F_trans
       dim = 2;                        % ...except for single row chebfun
    else
       dim = 1;
    end 
end

if F_trans
  F = transpose(F);
  dim = 3-dim;
end

if dim==1
  out = zeros(1,size(F,2));
  for k = 1:size(F,2);
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

if isempty(f), out = 0; return, end

exps = get(f,'exps');
if any(exps(:)<=-1),
    out = inf; % We could probably figure out the sign though?
    warning('CHEBFUN:sum:inf',['Integrand diverges to infinity on domain. ', ...
        'Assuming integral is infinite.']);
    return
end

% if any(exps(:))
%     warning('CHEBFUN:sum:inf','Sum does not yet support chebfuns which diverge on the domain.');
% end

out = 0;
for i = 1:f.nfuns
    out = out + sum(f.funs(i));
end
if not(isempty(f.imps(2:end,:)))
    out = out + sum(f.imps(end,:));
end
