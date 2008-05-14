function [B,c,rowidx] = bdyreplace(A,n)
% Each boundary condition in A corresponds to a constraint row of the form 
% B*u=c. This function finds all rows of B and c, and also the indices of
% rows of A*u=f that should be replaced by them.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

% Scalar case
B = zeros(A.numbc,n);
c = zeros(A.numbc,1);
rowidx = zeros(1,A.numbc);
if A.numbc==0, return, end

q = 1;
for k = 1:length(A.lbc)
  T = feval( A.lbc(k).op, n );   % realize boundary operator
  if size(T,1)>1, T = T(1,:); end   % select row at left end
  B(q,:) = T;
  c(q) = A.lbc(k).val;
  rowidx(q) = k;
  q = q+1;
end
for k = 1:length(A.rbc)
  T = feval( A.rbc(k).op, n );   % realize boundary operator
  if size(T,1)>1, T = T(n,:); end  % select row at right end
  B(q,:) = T;
  c(q) = A.rbc(k).val;
  rowidx(q) = n+1-k;
  q = q+1;
end



end
