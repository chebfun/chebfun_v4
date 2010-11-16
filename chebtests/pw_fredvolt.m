function pass = pw_fredvolt
% Test the construction of piecewise fred and volt matrices

pass = true(1,4);
tol = 1e3*chebfunpref('eps');

%% Fred
d = domain([-1 0.5 1]);
K = @(x,y) sin(x-y);
V = fred(K,domain(-1,1));

% % With breaks
% f = chebfun({@cos,@sin},d);
% vf = V(f);
% 
% N = zeros(1,f.nfuns);
% for k = 1:f.nfuns
%     N(k) = length(f.funs(k));
% end
% 
% VN = V(N,d);
% vNf = VN*f.vals;
% err = norm(vf(f.pts) - vNf,inf);
% pass(1) = err < tol;

% With maps and breaks
m = maps('kte',.25,d(1:2));
m(2) = maps('kte',.25,d(2:3));
f = chebfun(@cos,'map',{'kte',.25},d);
vf = V(f);

for k = 1:f.nfuns
    N(k) = length(f.funs(k));
end

VN = V(N,m,d);
vNf = VN*f.vals;
err = norm(vf(f.pts) - vNf,inf);
pass(2) = err < tol;

%% VOLT
d = domain([-1 0.5 1]);
K = @(x,y) sin(x-y);
V = volt(K,domain(-1,1));

% With breaks
f = chebfun({@cos,@sin},d);
vf = V(f);

N = zeros(1,f.nfuns);
for k = 1:f.nfuns
    N(k) = length(f.funs(k));
end

VN = V(N,d);
vNf = VN*f.vals;
err = norm(vf(f.pts) - vNf,inf);
pass(3) = err < tol;

% % With maps and breaks
% m = maps('kte',.25,d(1:2));
% m(2) = maps('kte',.25,d(2:3));
% f = chebfun(@cos,'map',{'kte',.25},d);
% vf = V(f);
% 
% for k = 1:f.nfuns
%     N(k) = length(f.funs(k));
% end
% 
% VN = V(N,m,d);
% vNf = VN*f.vals;
% err = norm(vf(f.pts) - vNf,inf);
% pass(4) = err < tol;


