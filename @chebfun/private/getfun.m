function [g, hpy, scl] = getfun(op, interval, maxn, scl)

global htol

a = interval(1); b = interval(2);
funscl = scl;
funscl.h = scl.h*2/(b-a);

if (b-a) < 2*htol
    g = fun(op((b+a)/2));
    scl.v=max(scl.v,g.scl.v);
    g=set(g,'scl.v',scl.v);
    hpy = true;    
else   
    %%% extrpolate to get values of v at end points %%%%%
     vne = op([a+htol, a+2*htol, b-htol, b-2*htol]'); 
     vb = 2*vne(3)-vne(4); va = 2*vne(1)-vne(2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    g = fun(@(x) [va; op(.5*((b-a)*x(2:end-1)+b+a)); vb], maxn, funscl);
    hpy = (length(g) < maxn);  
    scl.v = g.scl.v;
end