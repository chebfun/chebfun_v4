function f = vectorcheck(f,x,pref)
% Try to determine whether f is vectorized. 

% Copyright 2002-2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if isfield(pref,'vectorize') % force vectorization
    f = vec(f);
end

if isfield(pref,'vectorcheck') && pref.vectorcheck == false
    return              % Skip the check
end

dbz_state = warning;    % store warning state
try
    warning off         % turn off warnings off
    v = f(x(:));
    warning(dbz_state); % restore warnings
    if any(size(v) ~= size(x(:)))
        if nargout == 1 && ~isfield(pref,'vectorize')
            warning
            warning('CHEBFUN:vectorwrap:shape',...
                    ['Function failed to evaluate on array inputs; ',...
                    'vectorizing the function may speed up its evaluation and avoid ',...
                    'the need to loop over array elements. Use ''vectorize'' flag in ',...
                    'the chebfun constructor call to avoid this warning message.'])
            f = vec(f);
            vectorcheck(f,x,pref);
        else
            warning('CHEBFUN:vectorwrap:shapeauto',...
                'Automatic vectorization may not have been successful.')
        end
    end
catch %ME
    warning(dbz_state);     % restore warnings (is this needed here?)
    if nargout == 1 && ~isfield(pref,'vectorize')
        warning('CHEBFUN:vectorwrap:vecfail',...
                ['Function failed to evaluate on array inputs; ',...
                'vectorizing the function may speed up its evaluation and avoid ',...
                'the need to loop over array elements. Use ''vectorize'' flag in ',...
                 'the chebfun constructor call to avoid this warning message.'])
        f = vec(f);
        vectorcheck(f,x,pref);
    else
        rethrow(lasterror)
    end
end



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
