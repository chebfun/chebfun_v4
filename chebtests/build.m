function pass = build

% build a series of mfuns and check of the exponents are correct
% Mark Richardson

pass = 1;

for i = 0:0.75:5

    f = chebfun(@(x) sin(100*x)./((1+x).^i.*(2-x).^(i+1)),[-1 2],'blowup',2);
    if f.exps ~= [-i -i-1]
        pass = 0;
    end

end

