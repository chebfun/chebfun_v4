function B = blockeye(dom,m)
% Block identity operator of size m by m.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

Z = zeros(dom);  
I = eye(dom);
B = chebop([],[],dom,0);

for i = 1:m
  G = chebop([],[],dom,0);
  for j = 1:i-1
    G = [G Z];
  end
  G = [G I];
  for j = i+1:m
    G = [ G Z ];
  end
  B = [B; G];
end

end
