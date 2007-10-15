function F = chebvals(f)

nfuns = length(f.funs);
F=[];
for i = 1:nfuns
    F = [get(f.funs{i},'val'); F];
end
F = flipdim(F,1);
