function pass = subspacetest
% test the subspace function (angle between subspaces). Also calls vander.m
% Rodrigo Platte, October 2008.

pass = true;
[d,theta] = domain(0,2*pi);
A = [vander(exp(-1i*theta), 3) vander(exp(1i*theta), 2)];
f = sin(10*theta); f = f/norm(f);
A(:,1) = A(:,1)/norm(A(:,1));
alpha = [1e-10 pi/5 pi/2-1e-10];
for k = 1:length(alpha)
    B = cos(alpha(k))*A(:,1)+sin(alpha(k))*f;
    angle = subspace(A,B);
    pass = pass && (abs(angle-alpha(k)) < 1e4*chebfunpref('eps'));
end