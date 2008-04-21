function F = flipud(F)
% FLIPUD Flip/reverse a chebfun.
%
% G = FLIPUD(F) returns a chebfun G with the same domain as F but reversed;
% that is, G(x)=F(a+b-x), where the domain is [a,b].
% Remark: If F is a single row chebfun, then FLIPUD(F) returns F. 
% 
% If F is a column quasi-matrix, FLIPUD(F) is the same as 
% [ FLIPUD(F(:,1)) ...  FLIPUD(F(:,end)) ]
%
% If F is a row quasi-matrix, FLIPUD(F) is the same as 
% [ F(end,:); ...  ; F(1,:)]
%


% Deal with quasi-matrices
if size(F,1)>1
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
    % Reverse and translate the breakpoints.
    domf = domain(f);
    f.ends = -fliplr(f.ends) + sum(domf(:));
    f.imps = fliplr(f.imps);
end
