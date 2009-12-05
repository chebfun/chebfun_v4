function Nout = uminus(N)
% -  Negate a chebop.
 
Nout = N;  %change if ID's are added!
Nout.op = @(u) -N.op(u);
Nout.opshow = cellfun(@(s) ['- (',s,')'],N.opshow,'uniform',false);

end