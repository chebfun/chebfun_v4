function f = vectorcheck(f,x,warn)
% Try to determine whether f is vectorized. 

% Copyright 2002-2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

dbz_state = warning;    % store warning state
try
    warning off         % turn off warnings off
    v = f(x(:));
    if any(size(v) ~= size(x(:)))
        if nargout == 1
            if warn
                warning('CHEBFUN:vectorwrap:shape',...
                    ['Warning: Function failed to evaluate on array inputs; ',...
                    'vectorizing the function may speed up its evaluation and avoid ',...
                    'the need to loop over array elements.'])
            end
            f = vec(f);
            vectorcheck(f,x);
        elseif warn
            warning('CHEBFUN:vectorwrap:shapeauto',...
                'Automatic vectorization may not have been successful.')
        end
    end
catch %ME
    if nargout == 1
        if warn
            warning('CHEBFUN:vectorwrap:vecfail',...
                ['Warning: Function failed to evaluate on array inputs; ',...
                'vectorizing the function may speed up its evaluation and avoid ',...
                'the need to loop over array elements.'])
        end
        f = vec(f);
        vectorcheck(f,x);
    else
        rethrow(lasterror)
    end
    
    warning(dbz_state);     % restore warnings
    
end

warning(dbz_state);     % restore warnings

end

function g = vec(f)
%VEC  Vectorize a function or string expression.
%   VEC(F), if F is a function handle or anonymous function, returns a 
%   function that returns vector outputs for vector inputs by wrapping F
%   inside a loop.
%
%   See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team. 

g = @loopwrapper;

% ----------------------------
    function v = loopwrapper(x)
        v = zeros(size(x));
        for j = 1:numel(v)
            v(j) = f(x(j));
        end
    end
% ----------------------------

end
