function val = get(a, propName)
% GET Get chebfun properties.
% P = GET(F,PROP) returns the property P specified in the string PROP from
% the chebfun F. The string PROP can be 'funs', 'ends' or 'imps', to
% retrieve the cell array of funs, the vector with endpoints or the matrix
% with Dirac impulses respectively.
 
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
switch propName
    case 'funs'
        val = a.funs;
    case 'ends'
        val = a.ends;
    case 'imps'
        val = a.imps;
    case 'vals'
        funs = a.funs;
        nfuns = length(funs);
        val = [];
        for i = 1:nfuns
           val = [val;get(funs{i},'val')];
        end
    otherwise
        error([propName,' Is not a valid chebfun property'])
end
