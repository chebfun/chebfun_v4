function f = vectorcheck(f,x)
% Try to determine whether f is vectorized. 

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/
try
  v = f(x(:));
  if any(size(v) ~= size(x(:)))
    if nargout == 1
        warning('chebfun:vectorwrap:shape',...
          'Your function may need to be vectorized. Attempting to vectorize it.')
        f = vec(f);
        vectorcheck(f,x);
    else
        warning('chebfun:vectorwrap:shapeauto',...
          'Automatic vectorization may not have been successful.')
    end
  end
catch %ME
    if nargout == 1
        warning('chebfun:vectorwrap:vecfail',...
          'Your function gives an error for vector input. Attempting to vectorize it.')
        f = vec(f);
        vectorcheck(f,x);
    else
        rethrow(lasterror) 
    end
  
end

end
