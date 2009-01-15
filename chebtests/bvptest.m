function pass = bvptest

% Rodrigo Platte Jan 2009
% This routine tests BVP solvers bvp4c and bvp5c

[d,x] = domain(0,4);
y0 = [ x.^0, 0 ];

solinit = bvpinit([0 1 2 3 4],[1 0]); 

% Test bvp4c using default tolerance (RelTol = 1e-3)
y = bvp4c(@twoode,@twobc,y0);         % Chebfun solution
sol = bvp4c(@twoode,@twobc,solinit);  % Matlab's solution

pass1 = max(max(abs(sol.y' - feval(y,sol.x')))) < 2e-2;

% Test bvp5c using default tolerance (RelTol = 1e-3)
y = bvp5c(@twoode,@twobc,y0);         % Chebfun solution
sol = bvp5c(@twoode,@twobc,solinit);  % Matlab's solution

pass2 = max(max(abs(sol.y' - feval(y,sol.x')))) <2e-2;

% Set new tolerance:
opts = odeset('RelTol', 1e-6);

% Test bvp4c 
y = bvp4c(@twoode,@twobc,y0,opts);         % Chebfun solution
sol = bvp4c(@twoode,@twobc,solinit,opts);  % Matlab's solution

pass3 = max(max(abs(sol.y' - feval(y,sol.x')))) < 1e-4;

% Test bvp5c 
y = bvp5c(@twoode,@twobc,y0,opts);         % Chebfun solution
sol = bvp5c(@twoode,@twobc,solinit,opts);  % Matlab's solution

pass4 = max(max(abs(sol.y' - feval(y,sol.x')))) < 1e-4;

pass = pass1 && pass2 && pass3 && pass4;