function varargout = subsref(cg,index)
% SUBSREF   Obtain info from chebgui
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

% Allow calls on the form guifile.options.plotting
idx1 = index(1).subs;
if size(index,2) > 1
    idx2 = index(2).subs;
else
    idx2 = [];
end
switch index(1).type
    case '.'
        varargout = { get(cg,idx1,idx2) };
    otherwise
        error('CHEBGUI:subsref:indexType',['Unexpected index.type of ' index(1).type]);
end