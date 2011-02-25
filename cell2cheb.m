function [g flag] = cell2cheb(f)
% CELL2CHEB Convert a chebfun stored in a cell array to a quasimatrix
%  G = CELL2CHEB(F) where F is a cell array of chebfuns or quasimatrices
%  with matching domains, returns a quasimatrix G of the same functions.
%
%  [G FLAG] = CELL2CHEB(F) returns also a flag which is 1 when the
%  domains of F do not allow concatination in to a quasimatrix. In this
%  case G is identically F.

%  Copyright 2011 by The University of Oxford and The Chebfun Developers. 
%  See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

flag = 0; 
n = numel(f); 

if n == 0
    g = f;
    return
end

g = f{1};
ends = get(g,'domain');
trans = get(g,'trans');

for k = 2:n
    fk = f{k};
    if all(get(fk,'domain') == ends)
        if trans g = [g ;fk]; else g = [g fk]; end
    else
        g = f;
        flag = 1;
        return
    end
end
