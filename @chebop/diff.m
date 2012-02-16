function [N isLin] = diff(N,u)
%DIFF    Jacobian (Frechet derivative) of nonlinear operator.
%
% J = DIFF(N,U) for a chebop N and chebfun U, returns a linop representing
% the Jacobian (i.e., the Frechet derivative) of N evaluated at U. More
% specifically, J is the operator such that
%
%   || N(u+delta) - N(u) - J*delta || / ||delta|| -> 0
%
% in the limit ||delta|| -> 0. If U is a quasimatrix and/or N.op is a
% quasimatrix with multiple chebfun columns, then J has a block operator
% structure.
%
% Note that J includes boundary conditions, if any are specified for N.
% Each condition, given in the form g(u)=0, produces a linear boundary
% condition in J in the form g'(u)*delta. The operator g'(u) is assigned
% as a corresponding boundary condition of J.
%
% Example: A basic Newton iteration to solve u''-exp(u)=0, subject to
%          u(0)=1, u(1)*u'(1)=1
%
%   [d,x] = domain(0,1);
%   u = 1-x;
%   lbc = @(u) u-1;  rbc = @(u) u.*diff(u)-1;
%   N = chebop(d,@(u) diff(u,2)-exp(u),lbc,rbc);
%   for k = 1:6
%     r = N(u);  J = diff(N,u);
%     delta = -J\r;  u = u+delta;
%   end
%   plot(u), title(sprintf('|| residual || = %.3e',norm(N(u))))
%
% See also chebfun/diff, chebop/linop.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

[J BC isLin] = linearise(N,u);

% if nargout == 1
%     J = J & BC;
% end

N.op = J;
N.jumplocs = N.jumplocs;
N.domain = get(J,'domain');
if ~isempty(BC)
    N.lbc = BC.left;
    N.rbc = BC.right;
    N.bc = BC.other;
end

if ~isLin(1)
    N.opshow = [];
end
if ~isLin(2)
    N.lbcshow = [];
end
if ~isLin(3)
    N.rbcshow = [];
end
if ~isLin(4)
    N.bcshow = [];
end
