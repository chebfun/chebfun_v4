function Nout = plus(N1,N2)

if ~(N1.dom == N2.dom)
    error('Nonlinop: Domains of operators do not match');
end

Nout = nonlinop(N1.dom, @(u) N1.op(u)+N2.op(u));


end

