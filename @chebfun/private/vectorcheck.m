function vectorcheck(f,x)
% Try to determine whether f is vectorized. 

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

try
  v=f(x(:));
  if any(size(v) ~= size(x(:)))
    warning('chebfun:vectorwrap:shape',...
      'Your function may need to be vectorized. Wrap it inside a call to ''vec''.')
  end
catch ME
  disp('Your function gives an error for vector input.')
  disp('Vectorize it, or wrap it inside a call to ''vec''.')
  rethrow(ME)  
end
    
end
