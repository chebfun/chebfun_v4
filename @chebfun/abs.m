function Fout = abs(F)
% ABS   Absolute value of a chebfun.
% ABS(F) is the absolute value of the chebfun F.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = F;
for k = 1:numel(F)
    Fout(k) = abscol(F(k));
    Fout(k).jacobian = anon('diag1 = diag(sign(Fout)); der2 = diff(Fout,u); der = diag1*der2; nonConst = ~der2.iszero;',{'Fout'},{Fout(k)},1);
    Fout(k).ID = newIDnum;
end

end

function Fout = abscol(F)

if isempty(F)                % Empty case
    
    Fout = F;
    
elseif isreal(F)             % Real case
    
    r = roots(F);            % Abs is singular at roots 
    r = setdiff(r,F.ends).'; % ignore if already an endpoint
    if ~isempty(r)           % Avoid adding new breaks where not needed
        tol = 1000*chebfunpref('eps').*max(min(diff(F.ends)),1);
        Fbks = feval(F,repmat(r,1,2)+repmat([-1 1]*tol,length(r),1));
        r(logical(sum(sign(Fbks),2))) = [];
    end
    % Add the new breaks
    Fout = add_breaks_at_roots(F,[],r);
    % Loop through funs
    for k = 1:Fout.nfuns
        Fout.funs(k).vals = abs(Fout.funs(k).vals);
    end
    
elseif isreal(1i*F)          % Imaginary case
    
    Fout = abscol(1i*F);
    
else                         % Complex case
    
    Fout = add_breaks_at_roots(F);
    Fout = sqrt(conj(Fout).*Fout);

end

Fout.imps = abs(Fout.imps);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OLD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% function Fout = abs(F)
% % ABS   Absolute value of a chebfun.
% % ABS(F) is the absolute value of the chebfun F.
% %
% % See http://www.maths.ox.ac.uk/chebfun for chebfun information.
% 
% % Copyright 2002-2009 by The Chebfun Team. 
% 
% 
% % Quasi-matrix
% Fout = F;
% for k = 1:numel(F)    
%     if isempty(F(k)), Fout(k) = chebfun; return, end
%     
%     % Real case
%     if isreal(F(k))
%         Fout(k) = sign(F(k)).*F(k);
%         % Imaginary case
%     elseif isreal(1i*F(k))
%         Fout(k) = abs(1i*F(k));
%         % Complex case
%     else
%         r = roots(F(k));
%         F(1)
%         if isempty(r)
%             Fout(k) = comp(F(k),@abs);
%         else
%             % Break points are the union of roots and F.ends
%             ends = F(k).ends;
%             hs =  hscale(F(k));
%             for j = 1:length(r)
%                 % Make sure a root is not too close to a bkpoint
%                 if min(abs(ends-r(j))) > 1e-14*hs 
%                     ends = union(ends,r(j));
%                 end
%             end            
%             f1 = ones(domain(ends),1);
%             newf = overlap(F(k),f1);
%             Fout(k) = sqrt(conj(newf).*newf);                
%         end
%     end
%     % This is really the new type of anon constructor
%     Fout(k).jacobian = anon('diag1 = diag(sign(Fout)); der2 = diff(Fout,u); der = diag1*der2; nonConst = ~der2.iszero;',{'Fout'},{Fout(k)},1);
% 	Fout(k).ID = newIDnum;
%     
% end
