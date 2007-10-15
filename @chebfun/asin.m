function F = asin(f)

F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = asin(F.funs{i});
end