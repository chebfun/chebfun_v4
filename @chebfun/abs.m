function Fout = abs(F)
% ABS   Absolute value of a chebfun.
% ABS(F) is the absolute value of the chebfun F.
%

% Copyright 2002-2008 by The Chebfun Team. See www.chebfun.org.

% Quasi-matrix
Fout = F;
for k = 1:numel(F)
    Fout(k) = abscol(F(k));
end

% --------------------------------------------------------
% single chebfun
function fout = abscol(f)

if isempty(f), fout = chebfun; return, end

% Real case
if isreal(f)
  fout = sign(f).*f;
  
% Imaginary case  
elseif isreal(1i*f)
    fout = abscol(1i*f);
  
% Complex case    
else
%     hs = norm(f.ends,inf);
%     r = roots(f); 
%     ends = f.ends;
%     if isempty(r), 
%         r = [ends(1) ends(end)];       
%     else
%         if abs(r(1)  - ends(1)  ) > 1e-14*hs, r = [ends(1); r  ]; end
%         if abs(r(end)- ends(end)) > 1e-14*hs, r = [r; ends(end)]; end
%     end 
%     ind = find(abs(f.imps(2:end,:))>0);
%     if ~isempty(ind), r=union(r,ends(ind)); end
%     fout = chebfun(@(x) abs(feval(f,x)), r);   
%     fout.trans = f.trans;
%     
%     % Deal with deltas
%     foutimps = zeros(size(f.imps,1),length(fout.ends));      
%     [trash,findex,foutind]=intersect(f.ends,fout.ends);
%     foutimps(2:end,foutind)=abs(f.imps(2:end,findex));
%     foutimps(1,:)=fout.imps;
%     fout = set(fout, 'imps', foutimps);
       
      % All the above has been replaced with this (rodp, May 9 2008)
      fout = comp(f,@abs);

end
