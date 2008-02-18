function F = acsch(f)
% ACSCH	Inverse hyperbolic cosecant.
% ACSCH(F) is the inverse hyperbolic cosecant of F. Effect of impulses is 
% ignored.
 
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = acsch(F.funs{i});
end
