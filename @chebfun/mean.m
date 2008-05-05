function Fout = mean(F1,F2)
% MEAN	Average or mean value
% MEAN(F) is the mean value of the chebfun F.
%
% MEAN(F,G) is the average chebfun between chebfuns F and G.
%

if nargin == 1
    
    if F1(1).trans
        Fout = transpose(mean(transpose(F1)));
    else
        Fout = zeros(1,size(F1,2));
        for k = 1:size(F1,2)
            Fout(k) = sum(F1(:,k))/length(domain(F1(:,k)));
        end
    end
        
else
    
    Fout = (F1+F2)/2;
    
end
