function f = vectorcheck(f,x,warnoff)
% Try to determine whether f is vectorized. 

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/
try
  v = f(x(:));
  if any(size(v) ~= size(x(:)))
    if nargout == 1
        if ~warnoff
            warning('chebfun:vectorwrap:shape',...
            ['Warning: Function failed to evaluate on array inputs; ',...
             'vectorizing the function may speed up its evaluation and avoid ',...
             'the need to loop over array elements.'])
        end
        f = vec(f);
        vectorcheck(f,x);
    elseif ~warnoff
        warning('chebfun:vectorwrap:shapeauto',...
          'Automatic vectorization may not have been successful.')
    end
  end
catch %ME
    if nargout == 1
        if ~warnoff
            warning('chebfun:vectorwrap:vecfail',...
            ['Warning: Function failed to evaluate on array inputs; ',...
             'vectorizing the function may speed up its evaluation and avoid ',...
             'the need to loop over array elements.'])
        end
        f = vec(f);
        vectorcheck(f,x);
    else
        rethrow(lasterror) 
    end
  
end

end
