function pass = build

% build a series of mfuns and check of the exponents are correct
% Mark Richardson
pass = [];
for j = 0:0.75:5

    f = chebfun(@(x) sin(100*x)./((1+x).^j.*(2-x).^(j+1)),[-1 2],'blowup',2);
    if ~all(f.exps == [-j -j-1])
        pass = [pass 0];
    else
	pass = [pass 1];
    end

end

