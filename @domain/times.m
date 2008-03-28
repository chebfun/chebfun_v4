function d = times(d,a)

% Scale a domain. Reverse points if scaling factor is negative.

if isnumeric(d)
  t=a; a=d; d=t;
end

if ~isnumeric(a) || numel(a)~=1 || a==0 || ~isreal(a)
  error('domain:times:badoperand',...
    'Only nonzero real scalars can multiply domains.')
end

d.ends = d.ends*a;
if a<0
  d.ends = d.ends(end:-1:1);
end

end

  