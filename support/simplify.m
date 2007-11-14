function [c,flag] = simplify(c)

epss = 1e-13;
condition = max(epss,epss*norm(c,'inf'));
firstbig = min(find(abs(c)>= condition));
flag = 0;
if firstbig > 3
    c = c(firstbig:end);
    flag = 1;
end
