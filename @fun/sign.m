function F = sign(f)
% SIGN	Sign function
% For a fun, SIGN(F) returns a fun which is 1 if F is
% positive throughout [-1,1], -1 if F is negative throughout [-1,1]
% and empty if F has roots in [-1,1].

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (~isreal(f.val)), F=exp(i*imag(log(f))); return; end
F=f;
r=introots(f);
if (isempty(r))
  F.val=sign(bary(0,f.val));
  F.n=0;
else
  F.val=[];
  F.n=0;
end
