function d = plus(d,a)

% Shift a domain by a scalar constant.

if isnumeric(d)
  t=a; a=d; d=t;
end

if ~isnumeric(a) || numel(a)~=1 || ~isreal(a)
  error('domain:plus:badoperand','Only real scalars can be added to domains.')
end

d.ends = d.ends+a;

end