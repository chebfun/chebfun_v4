function fout = jacreset(fin)
% JACRESET Resets the Jacobian field of a chebfun such that the .jac field
% of the output function is an empty anon. FIN can be a quasimatrix in 
% which case FOUT will be a quasimatrix as well.
%
% See also DIFF
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

fout = fin;
for funCounter = 1:numel(fin)
    fout(funCounter).jacobian = anon('@(u) []','',[]);
end