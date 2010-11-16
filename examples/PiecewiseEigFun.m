%% EIGENFUNCTIONS OF A PIECEWISE OPERATOR
% Nick hale, 1 November 2010

%%
% (Chebfun Example ode/PiecewiseEigenFun.m)

%%
% On the domain [-10 10]
[d x] = domain([-10,10]);
%%
% We seeks the eigenfunctions corresponding to the eigenvalues
% of the operator
D = -diff(d,2) + 100*diag(abs(x)>5) & 'dirichlet';
%% 
% with smallest real part.

%%
% EIGS can now handle this:
[V D] = eigs(D,4)
%%
% allowing us to plot the eigen states:
plot(V+repmat(1+0*x,1,length(D))*D)