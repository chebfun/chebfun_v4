function varargout = find(f)
%FIND  Find locations of nonzeros in a chebfun.
%  FIND(F) returns a vector of all values at which the chebfun F is nonzero. 
%
%  [R,C] = FIND(F) returns two column vectors of the same length such that
%  [ F(R(n),C(n)) for all n=1:length(R) ] is the list of all nonzero
%  values of the quasimatrix F. One of the outputs holds dependent variable
%  values, and the other holds quasimatrix row or column indices. 
%
%  If the set of nonzero locations is not finite, an error is thrown.
%
%  Example:
%    f = chebfun(@sin,[0 2*pi]);
%    format long, find( f==1/2 )
%    
%  See also chebfun/roots, chebfun/eq, find.

% Copyright 2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if numel(f) > 1 && nargout<2
  error('chebfun:find','Use two output arguments for quasimatrices.')
end

x = [];  idx = [];
for n = 1:numel(f)
  for k = 1:f(n).nfuns
    if any(f(n).funs(k).vals)
      error('chebfun:find','Nonzero locations are not a finite set.')
    end
  end

  xnew = f(n).ends( f(n).imps(1,:)~=0 );
  x = [ x xnew ];
  idx = [ idx repmat(n,size(xnew)) ];
end

if nargout==1
  if ~f(1).trans, x=x.'; end
  varargout = {x};
else
  if ~f(1).trans
    varargout = {x.',idx.'};
  else
    varargout = {idx.',x.'};
  end
end

end
  