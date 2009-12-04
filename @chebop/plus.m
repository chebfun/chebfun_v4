function Nout = plus(N1,N2)

if ~(N1.dom == N2.dom)
    error('chebop:plus:domain','Domains of operators do not match');
end

if ~strcmp(N1.optype,N2.optype)
    error('chebop:plus:opType','Operators must be of same type (handle or linop)');
end

if strcmp(N1.optype,'anon_fun')
    Nout = chebop(N1.dom, @(u) N1.op(u)+N2.op(u));
    Nout.optype = 'anon_fun';
else
    Nout = chebop(N1.dom, N1.op+N2.op);
    Nout.optype = 'linop';
end


end

