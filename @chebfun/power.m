function Fout = power(F1,F2)
% .^	Chebfun power
% F.^G returns a chebfun F to the scalar power G, a scalar F to the
% chebfun power G, or a chebfun F to the chebfun power G

% Chebfun Version 2.0

if isa(F1,'chebfun') && isa(F2,'chebfun')
    if size(F1)~=size(F2)
        error('Chebfun quasi-matrix dimensions must agree.')
    end
    Fout = F1;
    for k = 1:numel(F1)
         Fout(k) = powercol(F1(k),F2(k));
    end
elseif isa(F1,'chebfun')
       Fout = F1;
       for k = 1:numel(F1)
            Fout(k) = powercol(F1(k),F2);
       end
else
       Fout = F2;
       for k = 1:numel(F2)
        	Fout(k) = powercol(F1,F2(k));
       end
end

% -----------------------------------------------------    
function fout = powercol(f,b)

if (isa(f,'chebfun') && isa(b,'chebfun'))
    if f.ends(1)~=b.ends(1) ||  f.ends(end)~=b.ends(end)
        error('F and G must be defined in the same interval')
    end
    ends = union(f.ends,b.ends);
    fout = chebfun(@(x) feval(f,x).^feval(b,x) , ends);

else

    if isa(f,'chebfun') 
        if b == 0
            fout = chebfun(1,[f.ends(1) f.ends(end)]);
        elseif b==2
            fout = f.*f;
        else
            fout = chebfun(@(x) feval(f,x).^b, f.ends);
        end
    else
        fout = chebfun(@(x) f.^feval(b,x), b.ends);
    end
    
end

fout.trans = f.trans; 