function varargout = subsref(cg,index)
% SUBSREF   Obtain info from chebgui
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

idx = index(1).subs;
switch index(1).type
    case '.'
        varargout = { get(cg,idx) };
    otherwise
        error('CHEBGUI:subsref:indexType',['Unexpected index.type of ' index(1).type]);
end