%% coeff_compare
% Show that obtaining Chebyshev coefficients by evaluating the integral 
% formula gives the same results as those obtained via chebpoly.m

f = @(x) exp(cos(8*x-1));
n = 30;               % number of coeffs to compare

ff = chebfun(f);
a = chebpoly(ff)';
if n <= length(a)
    a = a(end-n+1:end);
end

aa = zeros(n,1);
for i=1:n
    T = chebpoly(i-1);
    GG = chebfun(@(x) f(x).*T(x)./sqrt(1-x.^2),'exps',[-.5 -.5]);
    if i~=1
        aa(n-i+1) = 2*sum(GG)/pi;
    else
        display('     chebpoly coeff        chebfun sum            error ')       
        display(' i        a(i)                aa(i)            a(i)-aa(i)')    
        fprintf('\n')
        aa(n-i+1) = sum(GG)/pi;
    end
    fprintf('%2d  %+9.15f  %+9.15f  %+9.15f\n',i-1,a(n-i+1),aa(n-i+1),a(n-i+1)-aa(n-i+1))
end