function pass = harder_arithmetic
% This test simple arithmetic the simple operations: +,-,.* and
% isequal.

% These function chosen so that scl does not change. 
f = @(x,y) cos(x); f=chebfun2(f); 
g = @(x,y) sin(y); g=chebfun2(g); 
% exact answers. 
plus_exact = @(x,y) cos(x) + sin(y); plus_exact=chebfun2(plus_exact); 
minus_exact = @(x,y) cos(x) - sin(y); minus_exact=chebfun2(minus_exact); 
mult_exact = @(x,y) cos(x).*sin(y); mult_exact=chebfun2(mult_exact); 
pow_exact = @(x,y) cos(x).^sin(y); pow_exact=chebfun2(pow_exact);
try 
    pass(1) = isequal(f + g , plus_exact);
    pass(2) = isequal(f - g , minus_exact);
%     pass(3) = isequal(f.*g , mult_exact);
%     pass(4) = isequal(f.^g , pow_exact);
    pass = all(pass); 
catch
    pass = 0;
end
end