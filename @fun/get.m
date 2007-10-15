function val = get(a, propName)
% GET Get asset properties from the specified object
% and return the value
switch propName
    case 'val'
        val = a.val;
    case 'n'
        val = a.n;
    case 'trans'
        val = a.trans;
    case 'td'
        val = a.td;
    otherwise
        error([propName,' Is not a valid fun property'])
end