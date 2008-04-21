function Fout = mtimes(F1,F2)
% *	Scalar multiplication
% F*G multiplies a chebfun by a scalar.

% Chebfun Version 2.0

% Quasi-matrices product
if (isa(F1,'chebfun') && isa(F2,'chebfun'))
    if size(F1,2) ~= size(F2,1)
        error('Quasi-matrix dimensions must agree.')
    end
    Fout = zeros(size(F1,1),size(F2,2));
    for k = 1:size(F1,1)
        for j = 1:size(F2,2)
            if F1(k).trans && ~F2(j).trans
                Fout(k,j) = sum(F1(k).*F2(j));
            else
                error('Chebfun dimensions must agree.')
            end
        end
    end

% Scalar product    
elseif isa(F1,'chebfun')
    Fout = F1;
    for k = 1:numel(F1)
        Fout(k) = mtimescol(F2,F1(k));
    end
else
    Fout = mtimes(F2,F1);
end

% ------------------------------------
function fout = mtimescol(a,f)

funs = f.funs;
for i = 1:f.nfuns
    funs(i) = a*funs(i);
end
fout = set(f, 'funs', funs, 'imps', a*f.imps);
