function pass = chebopexpm
% Test for chebop expm method.
% Asgeir Birkisson, December 2010

%% With linops
d = domain(-1,1);  x = chebfun('x',d);
D = diff(d);  A = D^2 & 'dirichlet';
f = exp(-20*(x+0.3).^2);
t = [0.001 0.01 0.1 0.5 1];
for tCounter = 1:length(t);
    E = expm(t(tCounter)*A);
    Ef1(:,tCounter) = E*f;
end

%% With chebops
[d,x,N] = domain(-1,1);
N.op = @(u) diff(u,2);
N.bc = 'dirichlet';
for tCounter = 1:length(t);
    E = expm(t(tCounter)*N);
    Ef2(:,tCounter) = E*f;
end

pass = norm(Ef1-Ef2) < 1e-13;