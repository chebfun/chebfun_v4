function edge=detectedge(f,a,b,y,hs)
% Detects a blowup in second or fourth derivatives of f in [a,b].
% hs is the horizontal scale.
% If no edge is detected, edge=[] is returned.
%

% Rodrigo Platte, 2007.

test=1;
N=15;  
a=a+eps*hs;
b=b-eps*hs;

x=cheb(length(y)-1,a,b);
d=diff(y)./diff(x);
x=.5*(x(2:end)+x(1:end-1));
d=diff(d)./diff(x);
x=.5*(x(2:end)+x(1:end-1));

[maxd1,ind]=max(abs(d)); 
if ind+1<length(x), a=x(ind+1); end            
if ind-1>1,         b=x(ind-1); end

yab=f([a; b]);

while ((b-a)>5e-16*hs)&&test==1
    
    dx=(b-a)/(N-1);
    xm=[a+(0:N-2)*(b-a)/(N-1) b]'; 
    y=[yab(1); f(xm(2:end-1)); yab(2)];
                         
    [maxd2,ind]=max(abs(y(1:end-2)-2*y(2:end-1)+y(3:end)));             
    ind=ind+1; maxd2=maxd2/dx^2;

    if  maxd1>maxd2*.9                
        test=2;                
        a=x(end); b=x(1);            
    else
        maxd1=maxd2;                
        if ind+2<N, b=xm(ind+1); yab(2)=y(ind+1); end                            
        if ind-1>1, a=xm(ind-1); yab(1)=y(ind-1); end            
    end    
            
end

if test==2

    d=diff(d)./diff(x);
    x=.5*(x(2:end)+x(1:end-1));
    d=diff(d)./diff(x);
    x=.5*(x(2:end)+x(1:end-1));

    [maxd1,ind]=max(abs(d)); 
    if ind+2<length(x), a=x(ind+2); end            
    if ind-2>1,         b=x(ind-2); end  
    
    yab=f([a; b]);

    while ((b-a)>1e-15*hs)
  
        dx=(b-a)/(N-1);
        xm=[a+(0:N-2)*(b-a)/(N-1) b]'; 
        y=[yab(1); f(xm(2:end-1)); yab(2)];
    
        [maxd2,ind]=max(abs(y(1:end-4)-4*y(2:end-3)+6*y(3:end-2)-4*y(4:end-1)+y(5:end)));     
        %plot(xm(3:end-2),abs(y(1:end-4)-4*y(2:end-3)+6*y(3:end-2)-4*y(4:end-1)+y(5:end)))
        ind=ind+2;  maxd2=maxd2/dx^4;   
       % maxd2
       % maxd1
       % a
       % b
        if  maxd1>maxd2*.9                 
            edge=[];                 
            return             
        else
            maxd1=maxd2;                 
            if ind+3<N, b=xm(ind+1); yab(2)=y(ind+1); end                             
            if ind-1>1, a=xm(ind-1); yab(1)=y(ind-1); end             
        end                   

    end 

end

edge=(a+b)/2;