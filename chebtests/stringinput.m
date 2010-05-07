function pass = stringinput
% Nick Hale

f = chebfun(@sin);

f1 = chebfun('sin(x)');
pass(1) = ~norm(f-f1,inf);

f1 = chebfun('sin(y)');
pass(2) = ~norm(f-f1,inf);

try
    pass(3) = 0;
    f1 = chebfun('sin(x*y)');
catch
    pass(3) = 1;
end

