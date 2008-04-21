function gout = prolong(g,nout)
% This function allows one to manually adjust the number of points.
% The output G has length(G) = nout (number of points).

m = nout - g.n;
if m == 0
    gout = g;
    return
end
gout = set(g,'vals',bary(chebpts(nout),g.vals));

% The following code was used when trying to reduce a fun to one with more
% than 200 points. What does it do?
% 
% c=chebpoly(g);
% c2=c(1:-m);
% c2=c2(end:-1:1);
% c=c(g.n-nout+1:end);
% nl=(g.n-nout)/length(c(2:end));
% c3=zeros(1,length(c(2:end)));
% for i=1:floor(nl)
%     c3=c3+c2(1:length(c3));
%     c2=c2(length(c3)+1:end);
% end
% c2=[c2 zeros(1,length(c3)-length(c2))];
% c3=c3+c2;
% c(2:end)=c(2:end)+c3;
% gout.vals=chebpolyval(c);