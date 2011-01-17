function varargout = subsasgn(cg,index,varargin)
% SUBSREF   Modify a chebgui
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

idx = index(1).subs;
vin = varargin{:};
switch index(1).type
    case '.'
        varargout = {set(cg,idx,vin) };
    otherwise
        error('CHEBGUI:subsasgn:indexType',['Unexpected index.type of ' index(1).type]);
end