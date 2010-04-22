function Fout = exp(F)
% EXP Exponential of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

for k = 1:numel(F)
    if any(F(:,k).imps(1,:) == inf), error('CHEBFUN:exp:inf',...
        'chebfun cannot handle exponential blowups'); end
end

% Check for blowups (+inf)
pos_blowup = false;
for k = 1:numel(F)
    for j = 1:F(k).nfuns
        if get(F(k).funs(j),'lval') == inf || get(F(k).funs(j),'rval') == inf
            pos_blowup = true;
            break
        end
    end
end
if pos_blowup
     error('CHEBFUN:exp:inf',...
        'chebfun cannot handle exponential blowups'); 
end

Fout = comp(F, @(x) exp(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(exp(F))*diff(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();
end
