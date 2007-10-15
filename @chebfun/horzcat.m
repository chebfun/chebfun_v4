function F = horzcat(f1,f2)
% Concatenates adjacent chebfuns
ends1 = f1.ends;
ends2 = f2.ends
if ends1(end)~=ends2(1)
    error('Cannot concatenate separated chebfuns');
end
tmp = chebfun(f1.funs{end},f2.funs{1},[ends1(end-1:end) ends2(1)]);
[f,happy] = grow(tmp,domain(f12));
F = chebfun;
if happy
    F = set(F,'funs',[f1.funs{1:end-1},f.funs,f2.funs{2:end}],...
        'ends', [ends1(1:end-1) ends2(2:end)],...
        'imps', [f1.imps(:,1:end-1) f2.imps(:,2:end)]);
else
    F = set(F,'funs',[f1.funs;f2.funs],'ends',[ends1 ends2(2:end)],...
    'imps',[f1.imps f2.imps]); % check imps matrices before!
end