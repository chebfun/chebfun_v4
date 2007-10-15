function out = subsasgn(f,S,g)
% SUBSASGN	Subscripted assignment
% A(:,J)=F assigns the fun F to the J-th column of A.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if strcmp(S.type,'()')
  if (isempty(f) & ~g.trans)
    out = fun;
    out.val(S.subs{1},S.subs{2})=g.val;
    out.n=g.n;
  elseif (strcmp(S.subs{1},':') & ~f.trans)
    if (~isa(g,'double'))
      if (f.n>g.n)
        g=prolong(g,f.n);
      elseif (g.n>f.n)
        f=prolong(f,g.n);
      end
      out=f;
      out.val(S.subs{1},S.subs{2})=g.val;
    else
      out = f;
      out.val(S.subs{1},S.subs{2})=g;
    end
  elseif (strcmp(S.subs{2},':') & f.trans)
    if (~isa(g,'double'))
      if (f.n~=g.n)
        out = [f g];
        g.val=out.val(:,end);
        out.val=out.val(1:end-1,:);
      else
        out=f;
      end
      out.val(S.subs{1},S.subs{2})=g.val;
    else
      out = f;
      out.val(S.subs{1},S.subs{2})=g;
    end
  else
    error('Invalid call to subsasgn.')
  end
end
