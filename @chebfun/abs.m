function Fout = abs(F)
% ABS   Absolute value of a chebfun.
% ABS(F) is the absolute value of the chebfun F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 


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
        Fout(k) = comp(F(k),@abs);
    end
    
end
