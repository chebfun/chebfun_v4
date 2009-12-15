function varargout = subsasgn(f,index,varargin)
% SUBSASGN   Modify a chebop.
%
%     See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

idx = index(1).subs;
vin = varargin{:};
switch index(1).type
    case '.'
        varargout = {set(f,idx,vin)};
    otherwise
        error('CHEBOP:subsasgn:indexType',['Unexpected index.type of ' index(1).type]);
end