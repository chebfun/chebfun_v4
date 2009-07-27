function val = get(f, propName)
% GET   Get chebfun properties.
% P = GET(F,PROP) returns the property P specified in the string PROP from
% the chebfun F. The string PROP can be 'funs', 'ends' or 'imps', to
% retrieve the cell array of funs, the vector with endpoints or the matrix
% with Dirac impulses respectively.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

switch propName
    case 'funs'
        val = f.funs;
    case 'ends'
        val = f.ends;
    case 'imps'
        val = f.imps;
    case 'nfuns'
        val = f.nfuns;        
    case 'points'
        % Returns mapped Chebyshev points (consistent with vals)
        val = [];
        for k = 1:f.nfuns
            val = [val; f.funs(k).map.for(chebpts(f.funs(k).n))];
        end
    case 'scl'
        val = f.scl;
    case 'vals'
        funs = f.funs;
        val = [];
        for i = 1:f.nfuns
            val = [val;get(funs(i),'vals')];
        end
    case 'trans'
        val = f(1).trans;
    otherwise
        error([propName,' is not a valid chebfun property'])
end
