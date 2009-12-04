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

% Things can go wrong with blowups.
exps = get(f,'exps');
if any(any(exps<=-1)),

   % get the sign at these blowups
   expsl = find(exps(:,1)<=-1);
   expsr = find(exps(:,2)<=-1);
   sgn = zeros(length(expsl)+length(expsr),1);
   for k = 1:length(expsl), sgn(k) = sign(f.funs(expsl(k)).vals(1)); end
   for k = 1:length(expsr), sgn(length(expsl)+k) = sign(f.funs(expsr(k)).vals(end)); end
   
   % If these aren't all the same, then we can't compute
   if length(unique(sgn)) > 1 || any(isinf(get(f,'ends')))
       out = NaN;
%         warning('CHEBFUN:sum:NaN',['Integrand diverges to infinity on domain ', ...
%         'and chebfun cannot compute its sum. (Principal value integrals are not ', ...
%         'currently supported).']);
   else
       % Here we can determine the sign of the blowup
       out = sgn(1).*inf;
   end
   
   return
    
end

out = 0;
% Sum on each fun
for i = 1:f.nfuns
    out = out + sum(f.funs(i));
    if isnan(out), return, end % This shouldn't happen, but if it does, bail out.
end

% Deal with impulses
if not(isempty(f.imps(2:end,:)))
    out = out + sum(f.imps(end,:));
end
