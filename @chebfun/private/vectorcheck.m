function f = vectorcheck(f,x,warn)
% Try to determine whether f is vectorized. 

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/
try
    dbz_state = warning('off','MATLAB:divideByZero');   % turn off warning because of removable sings
    v = f(x(:));
    warning(dbz_state);
    if any(size(v) ~= size(x(:)))
        if nargout == 1
            if warn
                warning('chebfun:vectorwrap:shape',...
                    ['Warning: Function failed to evaluate on array inputs; ',...
                    'vectorizing the function may speed up its evaluation and avoid ',...
                    'the need to loop over array elements.'])
            end
            f = vec(f);
            vectorcheck(f,x);
        elseif warn
            warning('chebfun:vectorwrap:shapeauto',...
                'Automatic vectorization may not have been successful.')
        end
    end
catch %ME
    if nargout == 1
        if warn
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
