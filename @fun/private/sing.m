function m = sing(pars)
ends = pars(1:2);
pos = pars(3);

if length(pars) == 3
    pow = .25;
elseif length(pars) > 3
    pow = pars(4:end);
end
if ~pos && length(pow)==1, pow = [pow pow]; end
powi = 1./pow;

L = linear(ends);

switch pos
       
    case -1 % Left point singularity
        m.for = @(y) L.for( 2*( .5*(y+1) ).^powi - 1 );
        m.der = @(y) L.der(1) * powi * ( (y+1)/2 ).^(powi-1);
        m.inv = @(x) 2*( (L.inv(x)+1)/2 ).^pow - 1;
    case 1 % Right point singularity
        m.for = @(y) L.for( 1 - 2*( .5*(1-y) ).^powi);
        m.der = @(y) L.der(1) * powi * ( (1-y)/2 ).^(powi-1);
        m.inv = @(x) 1 - 2*( (1-L.inv(x))/2 ).^pow;
    case 0 % Both points sigularities
        m.for = @(y) L.for(sin(pi/2*sin(pi/2*y)));
        m.inv = @(x) 2/pi*asin(2/pi*asin(L.inv(x)));
%         m.inv = @(x) -2i/pi*log(1i*x+(1-x).^powi(1).*(1+x).^powi(2));
        m.der = @(y) L.der(1)*(1/4)*cos((1/2)*pi*sin((1/2)*pi*y)).*pi^2.*cos((1/2)*pi*y);
end

m.name = 'sing';
m.par = pars; 
m.inherited = true;


% switch pos
%     
%     case -1 % Left point singularity
%         m.for = @(y) L.for((y+1).^4/8-1);
%         m.der = @(y) L.der(1)*(y+1).^3/2;
%         m.inv = @(x) (8*(L.inv(x)+1)).^.25 -1;
%     case 1 % Right point singularity
%         m.for = @(y) L.for(-(1-y).^4/8+1);
%         m.der = @(y) L.der(1)*(1-y).^3/2;
%         m.inv = @(x) 1-(8*(1-L.inv(x))).^.25;
%     case 0 % Both points sigularyties
%         m.for = @(y) L.for(sin(pi/2*sin(pi/2*y)));
%         m.inv = @(x) 2/pi*asin(2/pi*asin(L.inv(x)));
%         m.der = @(y) L.der(1)*(1/4)*cos((1/2)*pi*sin((1/2)*pi*y)).*pi^2.*cos((1/2)*pi*y);
% end
% 
% m.name = 'sing';
% m.par = pars; 
% m.inherited = true;