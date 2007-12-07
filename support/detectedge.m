function [edge]=detectedge(f,a0,b0,hs)

a=a0; b=b0;
Nls=20;  
xl=[-1+(0:Nls-2)*(2)/(Nls-1) 1]';          %xl=linspace(-1,1,Nls)';
[Q,R]=qr(cos(acos(xl)*(0:8)),0);
vs=norm(f(linspace(a,b,40)));
        
while ((b-a)>5e-16*hs)
    
    xm=[a+(0:Nls-2)*(b-a)/(Nls-1) b]';     %xm=linspace(a,b,Nls)';
    [maxerr,ind]=max(abs(Q*(Q'*f(xm))-f(xm)));
    if ind+2<Nls, b=xm(ind+2); end
    if ind-2>1,   a=xm(ind-2); end
    if maxerr<1e-17*vs
        edge=(a+b)/2;
        return
    end
end

edge=(a+b)/2;