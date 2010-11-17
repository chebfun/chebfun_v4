function [B,c,rowidx] = bdyreplace_sys(A,ns,map,breaks)
% Each boundary condition in A corresponds to a constraint row of the form 
% B*u=c. This function finds all rows of B and c, and also the indices of
% rows of A*u=f that should be replaced by them.

% Copyright 2008 by Toby Driscoll.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author: hale $: $Rev: 1160 $:
%  $Date: 2010-07-21 15:48:29 +0100 (Wed, 21 Jul 2010) $:

n = [ns{:}];
m = size(A,2);
B = zeros(A.numbc,sum(n));
c = zeros(A.numbc,1);
rowidx = zeros(1,A.numbc);
if A.numbc==0, return, end

if nargin < 3, map = []; end
if nargin < 4, breaks = []; end

% elimnext = cumsum([1 n(1:m-1)]);  % in each variable, next row to eliminate
q = 1;
for k = 1:length(A.lbc)
  op = A.lbc(k).op;
  if size(op,2)~=m && ~isa(op,'varmat')
    error('LINOP:bdyreplace:systemsize',...
      'Boundary conditions not consistent with system size.')
  end
  if isa(op,'function_handle')
      T = NaN(1,sum(n));
  else
      T = [];
      for l = 1:m
        if isa(op,'varmat')
            Tl = feval(op,{ns{l},map,breaks{l}});
        else
            Tl = feval(op,ns{l},0,map,breaks{l});
        end
        if size(Tl,1)>1, Tl = Tl(1,:); end   % at left end only
        nsl = ns{l}; snsl = sum(nsl);
        blockcolindx = (l-1)*snsl+1:l*snsl;
        Tl = Tl(blockcolindx);
        T = [T Tl];
      end
  end
  B(q,:) = T;
  c(q) = A.lbc(k).val;
%   nz = logical(T);    % nontrivial variables
%   j = find(nz,1,'first');     % eliminate from the first
%   j = find(j-n<0,1,'first');        % which variable is this in?
%   rowidx(q) = elimnext(j);
%   elimnext(j) = elimnext(j)+1;
  q = q+1;
end

% elimnext = cumsum(n);  % in each variable, next row to eliminate
for k = 1:length(A.rbc)
  op = A.rbc(k).op;
  if size(op,2)~=m && ~isa(op,'varmat')
    error('LINOP:bdyreplace:systemsize',...
      'Boundary conditions not consistent with system size.')
  end
  if isa(op,'function_handle')
      T = NaN(1,n*m);
  else
      T = [];
      for l = 1:m
        if isa(op,'varmat')
            Tl = feval(op,{ns{l},map,breaks{l}});
        else
            Tl = feval(op,ns{l},0,map,breaks{l});
        end
        if size(Tl,1)>1, Tl = Tl(sum(ns{l}),:); end   % at right end only
        nsl = ns{l}; snsl = sum(nsl);
        blockcolindx = (l-1)*snsl+1:l*snsl;
        Tl = Tl(blockcolindx);
        T = [T Tl];
      end
  end
  B(q,:) = T;
  c(q) = A.rbc(k).val;
%   nz = logical(T);    % nontrivial variables 
%   j = find(nz,1,'last');      % eliminate from the last
%   j = find(j-n>0,1,'last');        % which variable is this in?
%   rowidx(q) = elimnext(j);
%   elimnext(j) = elimnext(j)-1;
  q = q+1;
end
end