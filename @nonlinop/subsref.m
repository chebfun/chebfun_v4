function varargout = subsref(f,index)
% SUBSREF   Evaluate a nonlinop
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

idx = index(1).subs;
switch index(1).type
    case '.'
        varargout = { get(f,idx) };
        if length(index)>1
          fun = @(v) subsref(v,index(2:end));
          varargout = cellfun(fun,varargout,'uniform',false);
        end
    case '()'
        varargout = {feval(f,idx{1})};
    otherwise
        error(['??? Unexpected index.type of ' index(1).type]);
end