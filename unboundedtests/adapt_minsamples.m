function pass = adapt_minsamples

shift = 1e3;
f = @(x) exp(-10*((x-shift).^2));

mpref = mappref;
mappref('parinf',[1,0])
mappref('adaptinf',true)
f = chebfun(f,[-inf,inf],'minsamples',1024+1);
mappref('parinf',mpref.parinf); mappref('adaptinf',mpref.adaptinf);

pass = abs(sum(f)-sqrt(pi/10)) < chebfunpref('eps')*1e5;