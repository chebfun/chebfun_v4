function F = isnan(F)
%  ISNAN True for Not-a-Number chebfuns.
%     ISNAN(X) operates on the continuous dimension of a chebfun X and
%     returns a chebfun which is 1 when the elements of X are NANs and
%     0's where they are not. Typically NaN values of X are only
%     permitted at breakpoints of X.
%  
%     For a complex-valued chebfun X, ISNAN(X) returns 1 if either of the
%     real and imaginary parts of X are NaN. For any real X, exactly one
%     of ISFINITE(X), ISINF(X), or ISNAN(X) is 1 for each element.
%  
%     See also ISNAN, ISINF.

for k = 1:numel(F)
    F(k) = isnancol(F(k));          % Loop over quasimatrix rows
end

function Fout = isnancol(F)

if ~isreal(F)
    Fout = isnancol(real(F)) | isnancol(imag(F));
    return
end

Fout = chebfun(0,F.ends([1 end]));  % Make a chebfun of ones

% % Deal with the case of infinite constant chebfuns
% chebone = chebfun(one);                   
% for k = 1:F.nfuns
%    if isinf(F.funs(k).vals(1))
%        Fout = define(Fout,domain(F.ends(k:k+1)),chebone);
%    end
% end
% Fout.imps = zeros(1,size(Fout.imps,2));

idx = isnan(F.imps);                % Find infinite imps of F
Fout = define(Fout,F.ends(idx),1);  % Assign to 0 in Fout


