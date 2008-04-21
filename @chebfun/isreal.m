function isr=isreal(F)
%  ISREAL True for real chebfun.
%     ISREAL(F) returns 1 if F does not have an imaginary part
%     and 0 otherwise.
%  
%     ~ISREAL(F) detects chebfuns that have an imaginary part even if
%     it is all zero.
%  
%  
%     See also CHEBFUN/REAL, CHEBFUN/IMAG.
% 
% 

%   Chebfun Version 2.0

isr = true;
for k = 1:numel(F)
    isr = isr && isreal(get(F(k),'vals'));
end