function val = get(f, propName)
% GET   Get chebfun properties.
% P = GET(F,PROP) returns the property P specified in the string PROP from
% the chebfun F. The string PROP can be 'funs', 'ends' or 'imps', to
% retrieve the cell array of funs, the vector with endpoints or the matrix
% with Dirac impulses respectively. Or 'nfuns', 'points', 'scl', 'vals',
% 'exps', or 'trans'. If F is a row (column) quasimatrix, GET will only return the 
% property of the first row (column).
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

val = [];

if numel(f) > 1
    if strcmpi(propName,'trans'), val = f(1).trans; return
    elseif strcmpi(propName,'domain'), val = f(1).ends([1 end]); return
    else
        warning('CHEBFUN:get:quasi','''Get'' should not be called with quasimatrices');
    end
end

switch propName
    case 'funs'
        val = f.funs;
    case 'map'
        if f.nfuns == 1
            val = f.funs(1).map;
        end
    case 'ends'
        val = f.ends;
    case 'domain'
        val = f.ends([1 end]);        
    case 'imps'
        val = f.imps;
    case 'nfuns'
        val = f.nfuns;        
    case 'scl'
        val = f.scl;
    case {'vals','exps','points','pts'}
        funs = f(1).funs;
        for j = 1:f(1).nfuns
            val = [val;get(funs(j),propName)];
        end
    case 'trans'
        val = f(1).trans;
    case {'jacobian','jac'}
        val = f.jacobian;
    otherwise
        error('CHEBFUN:get:propnam',[propName,' is not a valid chebfun property.'])
end
