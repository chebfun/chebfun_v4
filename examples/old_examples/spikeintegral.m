%Spikeintegral
% Demonstrates the adaptive capabilites of chebfun 
% by integrating a 'spike' function
%    sech(10*(x-0.2))^2 + sech(100*(x-0.4))^4 + ...
%    sech(1000*(x-0.6))^6 + sech(1000*(x-0.8)).^8
% over [0 1]

f = @(x) sech(10*(x-0.2)).^2 + sech(100*(x-0.4)).^4 + ...
         sech(1000*(x-0.6)).^6 + sech(1000*(x-0.8)).^8;
ff = chebfun(f,[0 1], 'splitting','on','minsamples',129);
sum(ff)
plot(ff,'r'); 