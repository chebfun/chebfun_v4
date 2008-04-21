function F = fliplr(F)
% FLIPLR Flip/reverse a chebfun.
%
% G = FLIPLR(F) returns a chebfun G with the same domain as F but reversed;
% that is, G(x)=F(a+b-x), where the domain is [a,b]. 
% Remark: If F is a single column chebfun, then FLIPLR(F) returns F. 
% 
% If F is a row quasi-matrix, FLIPLR(F) is the same as 
% [ FLIPLR(F(1,:)); ...;  FLIPLR(F(end,:)) ]
%
% If F is a column quasi-matrix, FLIPLR(F) is the same as 
% [ F(:,end) ...  F(:,1)]
%

F = flipud(F')';