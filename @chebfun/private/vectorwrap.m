function g = vectorwrap(f,x)

% Try to determine whether f is vectorized. If not, wrap it in a loop.

g = f;
try
  f(x(:));
catch
  g = @loopwrapper;
end

  function v = loopwrapper(x)
    v = zeros(size(x));
    for j = 1:numel(v)
      v(j) = f(x(j));
    end
  end
end
