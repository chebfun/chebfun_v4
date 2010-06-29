function S = sum(d)
% SUM  Integral functional.
% S = SUM(D) returns a linop representing the integration functional on the
% domain D. 
%
% Example:
%
% S=sum(domain(-1,1));
% S(5) % Clenshaw-Curtis weights
%   ans =
%      6.6667e-002  5.3333e-001  8.0000e-001  5.3333e-001  6.6667e-002
% f = chebfun(@(x) cos(x)./(1+x.^2),[-1 1]); 
% format long, [sum(f) S*f]
%   ans =
%      1.365866063614065   1.365866063614065
%
% See also linop, chebpts, chebfun/sum.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2010 by Toby Driscoll.

%  Last commit: $Author: hale $: $Rev: 1069 $:
%  $Date$:

S = linop(@mat,@sum,d);

  function A = mat(N)
    [x,A] = chebpts(N,d);
  end

end