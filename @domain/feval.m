function E = feval(d,s)
% FEVAL  Evaluation functional.
% E = FEVAL(D,S) returns a linop representing the functional of evaluation
% of a chebfun at the points in vector S. If f is a chebfun also defined on
% the domain D, then E*f will return a length(S)-by-1 vector equal to 
% f(S(:)).
%
% Example:
%
% E = feval(domain(-1,2),[-1;0;2]);  % evaluate at endpoints and one other
% E(5)   % note first and last rows are like the identity
%   ans =
%      1.0000e+000  1.6653e-016 -5.5511e-017 -1.1102e-016            0
%     -1.7284e-001  6.1656e-001  6.9136e-001 -2.2150e-001  8.6420e-002
%                0 -1.9429e-016  8.3267e-017 -1.1102e-016  1.0000e+000
%
% f = chebfun(@(x) cos(x)./(1+x.^2),[-1 2]); 
% format long, [f([-1;0;2]), E*f]
%   ans =
%      0.270151152934070   0.270151152934070
%      1.000000000000000   1.000000000000000
%     -0.083229367309428  -0.083229367309428
%
% See also linop, chebfun/feval.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2010 by Toby Driscoll.

%  Last commit: $Author$ $Rev$
%  $Id$

a = d.ends(1);  b = d.ends(2);
x = 2*(s(:)-a)/(b-a) - 1;
E = linop(@mat,@(u) feval(u,s(:)),d);

  function A = mat(N)
    C = cd2cpm(N);   % Cheb point values to polynomial coeffs
    T = cos( acos(x)*(0:N-1) );    % poly coeffs to values at points
    A = T*C;
  end

end


function C = cd2cpm(N)
% Matrix to convert values at Cheb points to Cheb poly coefficients.

% Three steps: Double the data around the circle, apply the DFT matrix,
% and then take half the result with 0.5 factor at the ends.
N1 = N-1;
theta = (pi/N1)*(0:2*N1-1)';
F = exp( -1i*theta*(0:2*N1-1) );  % DFT matrix
rows = 1:N;  % output upper half only
% Impose symmetries on data and coeffs.
C = real( [ F(rows,N) F(rows,N1:-1:2)+F(rows,N1+2:2*N1) F(rows,1) ] );
C = C/N1;  C([1 N],:) = 0.5*C([1 N],:);
end