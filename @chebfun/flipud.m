function F = flipud(F)
% FLIPUD   Flip/reverse a chebfun or quasimatrix.
% If F is a column chebfun, G = FLIPUD(F) returns a column chebfun G with
% the same domain as F but reversed; that is, G(x)=F(a+b-x), where the
% domain is [a,b]. 
% 
% If F is a column quasimatrix, FLIPUD(F) applies the above operation is to
% each column of F.
%
% If F is a row chebfun, FLIPUD(F) has no effect. If F is a row
% quasimatrix, FLIPUD(F) reverses the order of the rows. 
%
% See also chebfun/fliplr.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

% Deal with quasi-matrices
if F(1).trans
    F = F(end:-1:1);
else
    for k = 1:numel(F)
        F(k) = flipudcol(F(k));
    end
end

% -------------------------
function f = flipudcol(f)

if ~f.trans
    % Reverse the order of funs, and the funs themselves.
    for k = 1:f.nfuns, f.funs(k) = flipud(f.funs(k)); end
    f.funs = fliplr(f.funs);
    % Reverse and translate the breakpoints.
    domf = domain(f);
    f.ends = -fliplr(f.ends) + sum(domf.ends);
    f.imps = fliplr(f.imps);
end
