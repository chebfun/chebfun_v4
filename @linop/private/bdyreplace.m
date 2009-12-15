function [B,c,rowidx] = bdyreplace(A,n)
% Each boundary condition in A corresponds to a constraint row of the form 
% B*u=c. This function finds all rows of B and c, and also the indices of
% rows of A*u=f that should be replaced by them.

% Copyright 2008 by Toby Driscoll.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

m = size(A,2);
B = zeros(A.numbc,n*m);
c = zeros(A.numbc,1);
rowidx = zeros(1,A.numbc);
if A.numbc==0, return, end

elimnext = 1:n:m*n;  % in each variable, next row to eliminate
q = 1;
for k = 1:length(A.lbc)
  op = A.lbc(k).op;
  if size(op,2)~=m
    error('LINOP:bdyreplace:systemsize',...
      'Boundary conditions not consistent with system size.')
  end
  if isa(op,'function_handle')
      T = NaN(1,n*m);
  else
      T = feval(op,n);
      if size(T,1)>1, T = T(1,:); end   % at left end only
  end
  B(q,:) = T;
  c(q) = A.lbc(k).val;
  nz = any( reshape(T,n,m)~=0 );    % nontrivial variables
  j = find(full(nz),1,'first');     % eliminate from the first
  rowidx(q) = elimnext(j);
  elimnext(j) = elimnext(j)+1;
  q = q+1;
end

elimnext = n:n:n*m;  % in each variable, next row to eliminate
for k = 1:length(A.rbc)
  op = A.rbc(k).op;
  if size(op,2)~=m
    error('LINOP:bdyreplace:systemsize',...
      'Boundary conditions not consistent with system size.')
  end
  if isa(op,'function_handle')
      T = NaN(1,n*m);
  else
      T = feval(op,n);
      if size(T,1)>1, T = T(n,:); end   % at right end only
  end
  B(q,:) = T;
  c(q) = A.rbc(k).val;
  nz = any( reshape(T,n,m)~=0 );    % nontrivial variables 
  j = find(full(nz),1,'last');      % eliminate from the last
  rowidx(q) = elimnext(j);
  elimnext(j) = elimnext(j)-1;
  q = q+1;
end

end
