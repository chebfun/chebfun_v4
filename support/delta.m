function d = delta(imps, ends)

if nargin == 0 % default Dirac's delta
    imps = [0 1 0]; ends = [-1 0 1];
end
d = chebfun(num2cell(zeros(length(ends)-1,1)),ends);
d = set(d,'imps',imps);
