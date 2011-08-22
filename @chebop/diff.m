function [J linbc] = diff(N,u,flag)
%DIFF    Jacobian (Frechet derivative) of nonlinear operator.
%
% Please note this method is experimental in Chebfun version 4.0.
%
% J = DIFF(N,U) for a chebop N and chebfun U, returns a linop
% representing the Jacobian (i.e., the Frechet derivative) of N evaluated at
% U. More specifically, J is the operator such that
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
%   N = chebop(d,@(u)diff(u,2)-exp(u),lbc,rbc);
%   for k = 1:6
%     r = N(u);  J = diff(N,u);
%     delta = -J\r;  u = u+delta;
%   end
%   plot(u), title(sprintf('|| residual || = %.3e',norm(N(u))))
%
% See also chebfun/diff, chebop/linop.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Initialise
if nargin < 3, flag = 0; end

[J linbc isLin affine] = linearise(N,u,flag);

if nargout == 1
    J = J & linbc;
end

% No flag, so return a chebop
% F = J;
% J = chebop(get(L,'fundomain'));
% J.op = L;
% 
% if ~isempty(inputname(1)) && ~isempty(inputname(2))
%     s = ['diff(' inputname(1) ',' inputname(2) ')'];
% else
%     s = '';
% end
% J = set(J,'opshow',s);
% 
% if ~isempty(linBC.left)
%     J.lbc = linBC.left;
%     J.lbcshow = 'Linear operator';
% end
% if ~isempty(linBC.right)
%     J.rbc = linBC.right;
%     J.rbcshow = 'Linear operator';
% end