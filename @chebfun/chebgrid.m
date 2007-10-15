function X = chebgrid(f)

nfuns = length(f.funs);
ends = f.ends;
X = [];
for i = 1:nfuns
    n = length(get(f.funs{i},'val'))-1;
    if n==0, x=1; 
    else x = sin(pi*(-n:2:n)/(2*n)); end
    a = ends(i); b = ends(i+1);
    X = [X;scale(x,a,b)']; % i might be wrong
end     