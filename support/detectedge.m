function edge=detectedge(f,a,b,hs)
% Detects a blowup in second or fourth derivatives of f in [a0,b0].
% hs is the horizontal scale.
% If no edge is detected, edge=[] is returned.
%

% Rodrigo Platte, 2007.

test=1;
a0=a; b0=b;
N=20;  
maxd1=0;

while ((b-a)>5e-16*hs)
    
    xm=[a+(0:N-2)*(b-a)/(N-1) b]'; 
    y=f(xm);
    
    switch test
                                   
        case 1
            
            [maxd2,ind]=max(abs(y(1:end-2)-2*y(2:end-1)+y(3:end))); 
            ind=ind+2; maxd2=maxd2/(xm(2)-xm(1))^2;
            if  maxd1>maxd2*.9
                test=2;
                a=a0; b=b0;
            else
                maxd1=maxd2;
                if ind+3<N, b=xm(ind+2); end            
                if ind-3>1, a=xm(ind-2); end
            end
            
         case 2
             
             [maxd2,ind]=max(abs(y(1:end-4)-4*y(2:end-3)+6*y(3:end-2)-4*y(4:end-1)+y(5:end))); 
             ind=ind+4;  maxd2=maxd2/(xm(2)-xm(1))^4;
             if  maxd1>maxd2*.9
                 edge=[];
                 return
             else
                 maxd1=maxd2;
                 if ind+4<N, b=xm(ind+3); end            
                 if ind-4>1, a=xm(ind-3); end
             end       
            
    end

end 

edge=(a+b)/2;