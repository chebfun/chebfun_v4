function pass = webexamples
% Test the examples that are on the chebfun website
tol = 10*chebfunpref('eps');


%% Front page
% What's the integral of sin(sin(x)) from 0 to 10? 
x = chebfun('x',[0 10]);
sum(sin(sin(x)));
pass(1) = abs(ans - 1.629603118459496) < tol;

% What's the maximum of sin(x)+sin(x2) over the same interval?
max(sin(x)+sin(x.^2));
pass(2) = abs(ans - 1.985446580874097) < tol;

% How many roots does the Bessel function J0(x) have between 0 and 1000?
length(roots(chebfun(@(x) besselj(0,x),[0 1000])));
pass(3) = ~(ans-318);

%% The below can be added if the examples folder is added to the trunk.

% %% EXAMPLES
% curdir = pwd;
% cd ../examples
% 
% % -- Roots and optimization
% %% besselcount.m  Counts the number of roots of J0(x) in interval [a,b]
% n = besselcount(0,15);
% pass(4) = ~(n-5);
% 
% % -- Quasimatrices
% %% avoidance.m  Non-crossing eigenvalue curves as matrix A is morphed to matrix B
% pass(5) = true;
% try
%     A = [-0.969140355828830  -0.618593355360547
%           0.208715601272198   0.512015643736454];
%     B = [ 0.503780785776156   0.877048723385044
%           0.489594338723354   0.353141812938956];
%     E = avoidance(A,B);
% catch
%     pass(5) = false;
% end
% 
% % -- Complex chebfuns
% %% complexplot.m  Plots the image of a grid in the unit square under a function f
% % complexplot
% 
% %% contourint.m  A complex "keyhole contour" integral
% % contourint
% % pass(6) = abs(I-Iexact;) < tol;
% 
% % -- Differential equations and chebops
% %% resonance.m  Resonance of the 1D Helmholtz equation near certain wave numbers
% %% packet.m     Wave packet (pseudo)resonance of a space-dependent operator
% %% erosion.m    Solution of 1D heat equation via chebop operator exponential expm(L)
% %% carrier.m    Solution of a nonlinear ODE BVP by Newton iteration
% %% orrsomm.m    Eigenvalues of the Orr-Sommerfeld operator for plane Poiseuille flow
% 
% cd(curdir)