function pass = ad_systems
% A test that checks whether AD works currectly for multiple variables

x = chebfun('x',[0 2]);

u = sin(x);
v = u.^2;

% Diff. quasimatrix w.r.t. one function
der1 = diff([u v],x);
pass(1) = all(der1.blocksize == [2 1]);

% Diff one function w.r.t. quasimatrix
der2 = diff(x,[x u v]);
pass(2) = all(der2.blocksize == [1 3]);

% Quasimatrix w.r.t. quasimatrix
der3 = diff([u v],[x u v]);
pass(3) = all(der3.blocksize == [2 3]);