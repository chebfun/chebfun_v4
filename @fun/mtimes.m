function F = mtimes(f,g)
% *	Scalar multiplication
% F*G multiplies a fun by a scalar.
% If F is a row fun and G a column fun, F*G returns
% the integral from -1 to 1 of F.*G.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (isempty(f) | isempty(g)), F=fun; return; end
if (isa(f,'double'))
  F=g;
  F.val=f*g.val;
elseif (isa(g,'double'))
  if (f.trans)
    F=g*sum(f);
  else
    F=f;
    F.val=f.val*g;
  end
elseif (f.trans)
  n=size(f.val,1);
  n2=size(g.val,2);
  fg=f.n+g.n;
  f=prolong(f.',fg);
  g=prolong(g,fg);
  fn=f.val;
  gn=g.val;
  temp=g;
  F=zeros(n,n2);
  for i=1:n
    temp.val=fn(:,i*ones(n2,1)).*gn;
    F(i,:)=sum(temp);
  end
elseif (g.trans)
  F=f;
  F.val=f.val*g.val;
  F.td=1;
elseif (f.td)
  f=f.';
  temp=fun;
  temp2=g;
  [m,n]=size(f.val);
  [m2,n2]=size(g);
  temp.n=m-1;
  for i=1:n
    temp.val=f.val(:,i);
    for j=1:n2
      temp2.val=g.val(:,j);
      temp3(i,j)=sum(temp.*temp2);
    end
  end
  F=fun;
  F.val=temp3;
  F.n=n-1;
elseif(isa(f,'fun') & isa(g,'fun'))
  error('Use .* to multiply funs.');
end
