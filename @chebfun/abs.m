function F = abs(f)
% ABS   Absolute value of a chebfun.
% ABS(f) is the absolute value of the chebfun f.
 
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if isreal(get(f,'vals'))
  F = sign(f).*f;
else
  F = f;
  nfuns = length(f.funs);
  for i = 1:nfuns
      F.funs{i} = abs(F.funs{i});
  end
end
