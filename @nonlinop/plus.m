function Nout = plus(N1,N2)

if ~(N1.dom == N2.dom)
    error('Nonlinop: Domains of operators do not match');
end

if ~strcmp(N1.optype,N2.optype)
    error('Nonlinop: Operators must be of same type (anonymous function or chebops)');
end

if strcmp(N1.optype,'anon_fun')
    Nout = nonlinop(N1.dom, @(u) N1.op(u)+N2.op(u));
    Nout.optype = 'anon_fun';
else
    Nout = nonlinop(N1.dom, N1.op+N2.op);
    Nout.optype = 'chebop';
end


end

