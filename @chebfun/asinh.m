function F = asinh(f)

F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = asinh(F.funs{i});
end