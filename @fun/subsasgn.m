function g = subsasgn(g, A, B)

g = builtin('subsasgn', g, A, B);

% switch index(1).type
%     case '.'
%         error('fun:subsasgn:dotreference','Dot reference not understood.')
%     case '()'
%          g = builtin('subsasgn',g,index,varargin);
%   %      error('fun:subsasgn:parenreference','() reference not understood.')
%     case '{}'
%         error('fun:subsasgn:brackreference','{} reference not understood.')
% end