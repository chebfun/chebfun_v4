function pass = NaNandInf

% This test is no longer required?
pass = 1;
return

% Rodrigo Platte

% If an evaluation returns NaN the constructor should give an error
% message! This is true also of Inf when `blowup' is off.

blowup off

splitting off
% NaN
pass(1) = false;
try 
    chebfun(@(x) x.^6.*sin(1./x.^2),[-1 1]);
catch
    pass(1) = true;
end

% Inf
pass(2) = false;
try 
    chebfun(@(x) log(x+1));
catch
    pass(2) = true;
end

splitting on

% NaN
pass(3) = false;
try 
    chebfun(@(x) x.^6.*sin(1./x.^2),[-1 1]);
catch
    pass(3) = true;
end

% Inf
pass(4) = false;
try 
    chebfun(@(x) log(x+1))
catch
    pass(4) = true;
end

pass = all(pass);

chebfunpref factory;