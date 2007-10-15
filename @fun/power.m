function F = power(f,b)
% .^	Chebfun power
% F.^G returns a fun F to the scalar power G or a scalar F to the
% fun power G.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (isa(f,'fun') & isa(b,'fun'))
  error('Cannot raise a fun to the power of a fun.');
end
if (isa(f,'double'))
  F=exp(log(f)*b);
else
  F = auto(@power,f,b*fun('1'));
end
if (norm(imag(F.val))<eps), F.val=real(F.val); end
