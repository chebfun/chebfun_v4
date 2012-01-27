function constructorBasic

for k = 1:10
    
    f = chebfun(@(x) x);

    f = chebfun(@(x) sin(x));

    f = chebfun(@(x) exp(x));

    f = chebfun(@(x) sin(x).^2 + sin(x.^2),[0 10]);

end
