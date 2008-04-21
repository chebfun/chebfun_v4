function val = get(a, propName)
% GET Get asset properties from the specified object
% and return the value
switch propName
    case 'vals'
        val = a.vals;
    case 'n'
        val = a.n;
    case 'scl'
        val = a.scl;
    case 'scl.v'
        val = a.scl.v;
    case 'scl.h'
        val = a.scl.h;
    otherwise
        error([propName,' Is not a valid fun property'])
end