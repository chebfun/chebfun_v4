function constructorExps

for k = 1:2
    
    f = chebfun(@(x) 1./x,'blowup','on','splitting','on');

    f = chebfun(@(x) 1./sin(7*x),'blowup','on','splitting','on');

end

for k = 1:5
    
    f = chebfun(@(x) sqrt(x).*exp(x), 'blowup',2, [0 1]);

end
