function m = sing(ends,pos)

L = linear(ends);

switch pos
    
    case 'l' % Left point singularity
        m.for = @(y) L.for((y+1).^4/8-1);
        m.der = @(y) L.der(1)*(y+1).^3/2;
        m.inv = @(x) (8*(L.inv(x)+1)).^.25 -1;
        m.name = 'singl';
        m.par = [ends(1) ends(2)]; 
    case 'r' % Right point singularity
        m.for = @(y) L.for(-(1-y).^4/8+1);
        m.der = @(y) L.der(1)*(1-y).^3/2;
        m.inv = @(x) 1-(8*(1-L.inv(x))).^.25;
        m.name = 'singr';
        m.par = [ends(1) ends(2)]; 
    case 'b' % Both points sigularyties
        m.for = @(y) L.for(sin(pi/2*sin(pi/2*y)));
        m.inv = @(x) 2/pi*asin(2/pi*asin(L.inv(x)));
        m.der = @(y) L.der(1)*(1/4)*cos((1/2)*pi*sin((1/2)*pi*y)).*pi^2.*cos((1/2)*pi*y);
        m.name = 'singb';
        m.par = [ends(1) ends(2)];
        
end