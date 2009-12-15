function Nout = plus(N1,N2)

if ~(N1.dom == N2.dom)
    error('CHEBOP:plus:domain','Domains of operators do not match');
end

if ~strcmp(N1.optype,N2.optype)
    error('CHEBOP:plus:opType','Operators must be of same type (handle or linop)');
end

if strcmp(N1.optype,'anon_fun')
    Nout = chebop(N1.dom, @(u) N1.op(u)+N2.op(u));
    Nout.optype = 'anon_fun';
    Nout.opshow = cellfun(@combineshow,N1.opshow,N2.opshow,'uniform',false);
else
    Nout = chebop(N1.dom, N1.op+N2.op);
    Nout.optype = 'linop';
    Nout.opshow = cellfun(@combineshow,N1.opshow,N2.opshow,'uniform',false);
end


end

function s = combineshow(op1,op2)

if length(op1) + length(op2) < 70,
  s = [op1,' + ',op2];
else
  s = 'chebop + chebop';
end

end


% For possible future use? Right now it doesn't allow nested hyperlinks.
% These links are strings executed in the base workspace and so anonymous functions
% don't seem to help. 
function s = linktodisplay(N)

s = ['<a href="matlab:display(''',N.opshow,''')">chebop</a>'];

end

