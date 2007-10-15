function F = asech(f)

F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = asech(F.funs{i});
end