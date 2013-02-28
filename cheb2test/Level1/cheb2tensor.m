function pass = cheb2tensor
% Test to check that chebfun2 to tensor coefficients is working. 

n=10; 
f = chebpoly(n); g = chebpoly(n); h = chebfun2(@(x,y) f(x).*g(y)); 
X = chebpoly2(h); 

pass(1)  = (abs( X(end-10,end-10) -1) < 20*eps) ;  X(end-10,end-10)=X(end-10,end-10)-1;
pass(2) =  (norm(X) <100*eps); 

% Is cheb2poly and cheb2polyval inverses. 
f = @(x,y) cos(x+y); f=chebfun2(f); 
lenc = length(f.fun2.C); lenr = length(f.fun2.R);
[xx yy]=meshgrid(chebpts(lenc),chebpts(lenr)); vals = f(xx,yy); 
X = chebpolyval2(chebpoly2(f)); 
pass(3) = ((norm(X-vals))<100*eps);

if all(pass)
    pass = 1; 
end

end