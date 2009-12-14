% Chebops has some limited support for infinte domains,
% However this is quite experimental. 
% Below are some examples.

%%

% u' + 2x = 0,
% u(0) = 1, u(inf) = 0

d = domain([0 inf]);
A = diff(d) + diag(@(x) 2*x,d) ;
A.lbc = 1;
A.rbc = 0;

u = A\0;                                        % computed soln
f = chebfun('exp(-x.^2)',d);                    % true soln
plot(u,'b',f,'--r');
legend('computed','true')
norm(u-f,inf)

%%

% u'' + 1/x-1/4 = 0,
% u'(0) = 1, u(inf) = 0

d = domain(0,inf);
A = diff(d,2)+diag(@(x) 1./x-1/4,d);
bc.left = struct('op','neumann','val',1);
bc.right = struct('op','dirichlet','val',0);
A.bc = bc;

u = A\0;                                        % computed soln
f = chebfun(@(x) exp(-x/2)*x,d);                % tru soln

plot(u,'b',f,'--r')
legend('computed','true')
axis([0 10 0,1])
norm(u-f,inf)

%%

% u'' + xu' + ((n pi)^2 + 2(1+2x^2))u  = 0,
% u(0) = 1, u'(0) = 0, u(inf) = 0

d = domain(0,inf);
n = 4;

A = diff(d,2) + diag(@(x) 4*x, d)*diff(d) + diag(@(x) n.^2*pi^2+2*(1+2*x.^2), d);
bc.left = struct('op',{'dirichlet','neumann'},'val',{1 0});
bc.right = struct('op','dirichlet','val',0);
A.bc = bc;

u = A\0;                                        % computed soln
f = chebfun(@(x) cos(n*pi*x).*exp(-x.^2),d);    % true soln

plot(u,'b',f,'--r')
legend('computed','true')
axis([0 5 -1,1])
norm(u-f,inf)


%%

% u'' + u' + exp(-x^2) u = tanh(2*x+sin(10*x))+exp(-x),
% u(0) = 1, u(inf) = 1

d = domain(0,inf);

A = diff(d,2)+diff(d)+diag(@(x) exp(-x.^2),d);
A.lbc = 1; A.rbc = +1;

f = chebfun('tanh(2*x+sin(10*x))+exp(-x)',d);  % true soln
u = A\diff(f,2);                               % computed soln

plot(u,'b')












