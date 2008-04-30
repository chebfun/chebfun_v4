function g = vectorwrap(f,x)

% Try to determine whether f is vectorized. If not, wrap it in a loop.

if isa(f,'chebfun') || isa(f,'fun')
    g = f;
else
    g = f;
    try
        v=f(x(:));
        if any(size(v) ~= size(x(:)))
            g = @loopwrapper;
        end
    catch
        g = @loopwrapper;
    end
    

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
