function f = subsasgn(f,index,g)
% SUBSASGN  Subscripted assignment.
%
% F{A,B} = G is equivalent to F = DEFINE(F,[A,B],G). 
%
% F{:} = G is equivalent to F = DEFINE(F,DOMAIN(F),G). 
%
% See also CHEBFUN/DEFINE, CHEBFUN/SUBSREF.

% Toby Driscoll, 9 February 2008. 

switch index(1).type
  case '.'
    error('chebfun:subsasgn:dotreference','Dot reference not understood.')
  case '()'
    error('chebfun:subsasgn:parenreference','() reference not understood.')
  case '{}'
    s = [];
    if length(index.subs)==1
      if isequal(index.subs{1},':')
        s = domain(f);
      elseif isa(index.subs{1},'domain')
        s = index.subs{1};
      end
    elseif length(index.subs)==2
      s = cat(2,index.subs{:});
    end
    if ~( isa(s,'domain') || (isnumeric(s) && length(s)==2) )
      error('chebfun:subsasgn:badreference','Invalid assignment syntax.')
    end
    f = define(f,s,g);
  otherwise
    error('chebfun:subsasgn:panic',['Unexpected index.type of ' index(1).type]);
end

end