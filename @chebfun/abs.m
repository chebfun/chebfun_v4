function Fout = abs(F)
% ABS   Absolute value of a chebfun.
% ABS(F) is the absolute value of the chebfun F.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 


% Quasi-matrix
Fout = F;
for k = 1:numel(F)
    
    if isempty(F(k)), Fout(k) = chebfun; return, end
    
    % Real case
    if isreal(F(k))
        Fout(k) = sign(F(k)).*F(k);
        % Imaginary case
    elseif isreal(1i*F(k))
        Fout(k) = abs(1i*F(k));
        % Complex case
    else
        r = roots(F(k));
        if isempty(r)
            Fout(k) = comp(F(k),@abs);
        else
            % Break points are the union of roots and F.ends
            ends = F(k).ends;
            hs =  hscale(F(k));
            for j = 1:length(r)
                % Make sure a root is not too close to a bkpoint
                if min(abs(ends-r(j))) > 1e-14*hs 
                    ends = union(ends,r(j));
                end
            end            
            f1 = ones(domain(ends),1);
            newf = overlap(F(k),f1);
            Fout(k) = sqrt(conj(newf).*newf);                
        end
    end
    
    Fout(k).jacobian = anon('@(u) diag(sign(fout))*jacobian(fout,u)',{'fout'},{Fout});
	Fout(k).ID = newIDnum;
    
end
