function Fout = mean(F1,F2)
% MEAN	Average or mean value
% MEAN(F) is the mean value of the chebfun F.
%
% MEAN(F,G) is the average chebfun between chebfuns F and G.

if nargin == 1
    Fout = zeros(size(F1));
    for k = 1:numel(F1)
        Fout(k) = sum(F1(k))/length(domain(F1(k)));
    end
else
    Fout = (F1+F2)/2;
end
