function H = plus(F1,F2)
% +	  Plus.
% F + G adds chebfuns F and G, or a scalar to a chebfun if either F or G is 
% a scalar.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if (isempty(F1) || isempty(F2)), H=chebfun; return; end

if isa(F1,'double')
    H = F2;
    for k = 1:numel(F2)
        H(k) = pluscol(F1,F2(k));
    end
elseif isa(F2,'double')
    H = F2 + F1;
else
    if size(F1)~=size(F2)
        error('size(F1)~=size(F2)')
    end
    H = F2;
    for k = 1:numel(F2)
        H(k) = pluscol(F1(k),F2(k));
    end
end        



% --------------------------------------------
function h =  pluscol(f1,f2)

% scalar + chebfun
if isa(f1,'double')
    h = f2;
    for i = 1: f2.nfuns
          h.funs(i) = f1 + f2.funs(i);  
    end
    h.imps(1,:) = f1 + f2.imps(1,:);
    
elseif isa(f2,'double')
    h=f1;
    for i = 1: f1.nfuns
        h.funs(i)=f1.funs(i) + f2;
    end
    h.imps(1,:) = f2 + f1.imps(1,:);

else    

    % chebfun + chebfun
    [f1,f2] = overlap(f1,f2);   
    h = f1;
    for k = 1:f1.nfuns
        h.funs(k) = f1.funs(k) + f2.funs(k);
    end
    h = set(h,'imps',f1.imps+f2.imps);

end

h = update_vscl(h);


