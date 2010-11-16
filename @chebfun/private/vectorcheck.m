function [f ends] = vectorcheck(f,x,pref)
% Try to determine whether f is vectorized or maybe returns a system. 
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

ends = [];
if isfield(pref,'vectorize') % force vectorization
    f = vec(f);
end

if isfield(pref,'vectorcheck') && pref.vectorcheck == false
    return              % Skip the check
end

dbz_state = warning;    % Store warning state
try
    warning off         % Turn off warnings off
    v = f(.99*x(:));    % Evaluate a vector of (near the) endpoints
    warning(dbz_state); % Restore warnings
%     if any(size(v) ~= size(x(:)))
    sv = size(v);    sx = size(x(:));
    if ( all(sv>1) || ~any(sv==sx(1) | sv ==sx(2)) )
        if nargout == 1 && ~isfield(pref,'vectorize')
            warning('CHEBFUN:vectorcheck:shape',...
                    ['Function failed to evaluate on array inputs; ',...
                    'vectorizing the function may speed up its evaluation and avoid ',...
                    'the need to loop over array elements. Use ''vectorize'' flag in ',...
                    'the chebfun constructor call to avoid this warning message.'])
            f = vec(f);
            vectorcheck(f,x,pref);
        else
            warning('CHEBFUN:vectorcheck:shapeauto',...
                'Automatic vectorization may not have been successful.')
        end
    elseif any(size(v) ~= size(x(:)))
        f = @(x) f(x)';
    end
    
catch %ME
    
    try 
        % Perhaps it's a system?
        s = size(f(repmat({.99*x(:)},1,1e4)));
        ends = repmat({x(:).'},1,length(s));
    catch
        if nargout == 1 && ~isfield(pref,'vectorize')
            warning('CHEBFUN:vectorcheck:vecfail',...
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
warning(dbz_state); % Restore warnings


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
