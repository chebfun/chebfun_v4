function H = plus(F1,F2)
% +	  Plus.
% F + G adds chebfuns F and G, or a scalar to a chebfun if either F or G is 
% a scalar.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

if (isempty(F1) || isempty(F2)), H=chebfun; return; end

if isa(F1,'double')
    H = F2;
    if numel(F1) == 1, F1 = repmat(F1,numel(F2),1); end
    if numel(F1) ~= 1 && ~all(size(F1) == size(F2))
        error('CHEBFUN:plus:sclsize','Matrix dimensions do not agree.'); 
    end
    for k = 1:numel(F2)
        H(k) = pluscol(F1(k),F2(k));
    end
elseif isa(F2,'double')
    H = F2 + F1;
else
    if any(size(F1)~=size(F2))
        error('CHEBFUN:plus:size','Quasimatrix dimensions must agree.')
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
    h.scl = max(h.scl, abs(f1+h.scl));
    
elseif isa(f2,'double')
    h=f1;
    for i = 1: f1.nfuns
        h.funs(i)=f1.funs(i) + f2;
    end
    h.imps(1,:) = f2 + f1.imps(1,:);
    h.scl = max(h.scl, abs(f2+h.scl));

else    

    % chebfun + chebfun
    [f1,f2] = overlap(f1,f2);   
    h = f1;
    scl = h.scl;
    for k = 1:f1.nfuns
        h.funs(k) = f1.funs(k) + f2.funs(k);
        scl = max(scl, h.funs(k).scl.v);
    end
    h.imps=f1.imps+f2.imps;

    % update scale
    for k = 1:f1.nfuns
        h.funs(k).scl.v = scl;
    end
    h.scl = scl;

    h.jacobian = anon('@(u) jacobian(f1,u)+jacobian(f2,u)',{'f1' 'f2'},{f1 f2});
    h.ID = newIDnum();
    
end


