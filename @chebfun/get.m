function val = get(f, propName)
% GET   Get chebfun properties.
% P = GET(F,PROP) returns the property P specified in the string PROP from
% the chebfun F. The string PROP can be 'funs', 'ends' or 'imps', to
% retrieve the cell array of funs, the vector with endpoints or the matrix
% with Dirac impulses respectively.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

switch propName
    case 'funs'
        val = f.funs;
    case 'ends'
        val = f.ends;
    case 'imps'
        val = f.imps;
    case 'points'
        % If f consists of many chebfuns, just use the first one. Check
        % what will happen if splitting is on and the solution is piecewise
        % contious.
        f1 = f(:,1);
        ends = f1.ends;              % Get the endpoints of the function
        intlen = ends(2)-ends(1);   % Get the interval length
        % Map from [-1,1] to the correct interval
        % Begin by shrinking/expanding the interval, then translate it
        val =  chebpts(length(f1))*intlen/2 + (ends(1)+intlen/2);
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
