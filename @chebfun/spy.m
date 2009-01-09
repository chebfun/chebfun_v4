function spy(A)
% SPY   spy of a chebfun
%

% Copyright 2002-2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

hold off
[m,n] = size(A);
[a,b] = domain(A);

if isinf(m) & ~isinf(n)            % column quasimatrix
   for j = 1:n
      plot([j j],[a b],'-b'), hold on
   end
   set(gca,'ytick',[a b])
   set(gca,'ydir','reverse')
   if n<10, set(gca,'xtick',1:n)
      else, set(gca,'xtick',[1 n]), end
   axis([0 n+1 a b])
   ar = get(gca,'plotboxaspectratio');
   ar(1) = .5*ar(1);
   set(gca,'plotboxaspectratio',ar)
end

if ~isinf(m) & isinf(n)            % row quasimatrix
   for i = 1:m
      plot([a b],[i i],'-b'), hold on
   end
   set(gca,'xtick',[a b])
   if m<10, set(gca,'ytick',1:m)
      else, set(gca,'ytick',[1 m]), end
   set(gca,'ydir','reverse')
   axis([a b 0 m+1])
   ar = get(gca,'plotboxaspectratio');
   ar(2) = .4*ar(2);
   set(gca,'plotboxaspectratio',ar)
end
