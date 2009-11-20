function varargout = subsasgn(f,index,varargin)
% SUBSASGN   Modify a nonlinop
%
%     See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

idx = index(1).subs;
vin = varargin{:};
switch index(1).type
    case '.'
        varargout = {set(f,idx,vin)};
    otherwise
        error(['??? Unexpected index.type of ' index(1).type]);
end