function F = prolong(f,n)
% This function allows one to manually adjust the number of points.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
[m,q]=size(f.val);
nf=n-f.n;
F=f; F.n=n;
if (~f.trans & nf>=0)
    F.val=funpolyval([zeros(nf,q);transpose(funpoly(f))]);
elseif (~f.trans &nf<0)
    cn=cheb(n);
    if (n==0)
        F.val=funpolyval(sum(funpoly(f)));
    elseif (n<=200)
        F.val=bary(cn,f.val);
    else
        c=funpoly(f);
        c2=c(1:f.n-n);
        c2=c2(end:-1:1);
        c=c(f.n-n+1:end);
        nl=(f.n-n)/length(c(2:end));
        c3=zeros(1,length(c(2:end)));
        for i=1:floor(nl)
            c3=c3+c2(1:length(c3));
            c2=c2(length(c3)+1:end);
        end
        c2=[c2 zeros(1,length(c3)-length(c2))];
        c3=c3+c2;
        c(2:end)=c(2:end)+c3;
        F.val=funpolyval(transpose(c));
    end
else
    cn=cheb(n);
    F.val=transpose(bary(cn,f.val));
end