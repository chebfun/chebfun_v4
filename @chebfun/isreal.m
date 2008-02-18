function isr=isreal(f)
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
%     Reference page in Help browser
%        doc isreal

%   Rodrigo Platte, 18 Feb 2008

isr=isreal(get(f,'vals'));