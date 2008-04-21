function out = var(F)
% VAR	Variance
% VAR(F) is the variance of the chebfun F.

out = zeros(size(F));
for k = 1:numel(F)
    out(k) = mean((F(k)-mean(F(k))).^2);
end

