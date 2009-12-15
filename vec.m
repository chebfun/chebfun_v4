function g = vec(f)
%VEC  Vectorize a function or string expression.
%   VEC(F), if F is a function handle or anonymous function, returns a 
%   function that returns vector outputs for vector inputs by wrapping F
%   inside a loop.
%
%   VEC(F), if F is a string or inline function, applies VECTORIZE to F. 
%   It replaces arithmetic operators with vectorized counterparts.
%
%   See also VECTORIZE, FUNCTION_HANDLE.
%
%   See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team. 


if isa(f,'function_handle')
  g = @loopwrapper;
elseif ischar(f) || isa(f,'inline')
  g = vectorize(f);
end

% ----------------------------
    function v = loopwrapper(x)
        v = zeros(size(x));
        for j = 1:numel(v)
            v(j) = f(x(j));
        end
    end
% ----------------------------

end