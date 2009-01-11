function pass = ivptest

% Rodrigo Platte Jan 2009
% This routine tests IVP solver: ode45, ode113, ode15s

% Test ode113 Using default tolerances (RelTol = 1e-3)
y = ode113(@vdp1,domain(0,20),[2;0]); % chebfun solution
[tm,ym] = ode113(@vdp1,[0,20],[2;0]); % Matlab's solution

pass1 = max(max(abs(ym - feval(y,tm)))) < 2e-2;

% Test ode45 Using default tolerances (RelTol = 1e-3)
y = ode45(@vdp1,domain(0,20),[2;0]); % chebfun solution
[tm,ym] = ode45(@vdp1,[0,20],[2;0]); % Matlab's solution

pass2 = max(max(abs(ym - feval(y,tm)))) < 1e-2;


% Test with different tolerance
opts = odeset('RelTol', 1e-6);

% Test ode113
y = ode113(@vdp1,domain(0,20),[2;0],opts); % chebfun solution
[tm,ym] = ode113(@vdp1,[0,20],[2;0],opts); % Matlab's solution

pass3 = max(max(abs(ym - feval(y,tm)))) < 1e-5;

% Test ode45 
y = ode45(@vdp1,domain(0,20),[2;0],opts); % chebfun solution
[tm,ym] = ode45(@vdp1,[0,20],[2;0],opts); % Matlab's solution

pass4 = max(max(abs(ym - feval(y,tm)))) < 1e-5;

% Test ode45 
y = ode15s(@vdp1,domain(0,20),[2;0],opts); % chebfun solution
[tm,ym] = ode15s(@vdp1,[0,20],[2;0],opts); % Matlab's solution

pass5 = max(max(abs(ym - feval(y,tm)))) < 1e-5;

pass = pass1 && pass2 && pass3 && pass4 && pass5;


