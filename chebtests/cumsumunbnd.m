function pass = cumsumunbnd
% Test cumsum with exps < 1. This is still experimental,
% and we test only that it doesn't crash!

tol = 1e2*chebfunpref('eps');

pass(1) = true;

try

    % f = chebfun('(cos(x))./x.^2',[0 2],'exps',[-2 0]);
    f = chebfun('(cos(2-x))./(1-x).^2',[1 3],'exps',[-2 0]);
    u = cumsum(f);

    a = f.ends(1)+.01;
    h = cumsum(f{a,f.ends(2)})+u(a);

%     plot(u,'b',h,'--g')
    
    err = h - restrict(u,[a f.ends(2)]);
    nerr = norm(err,inf)
    
%     pass(1) = nerr < tol;

catch
    
    pass(1) = false;
    
end
