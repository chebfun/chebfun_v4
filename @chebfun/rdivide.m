function Fout = rdivide(F1,F2)
% ./	Right chebfun division
% F./G is the chebfun division of G into F.

% Chebfun Version 2.0

if (isempty(F1) || isempty(F2)), Fout = chebfun; return; end

if isa(F1,'chebfun')&&isa(F2,'chebfun')
    if size(F1)~=size(F2)
        error('Quasi-matrix dimensions must agree')
    end
    Fout = F1;
    for k = 1:numel(F1)
        Fout(k) = rdividecol(F1(k),F2(k));
    end
elseif isa(F1,'chebfun')
    Fout = F1;
    for k = 1:numel(F1)
        Fout(k) = rdividecol(F1(k),F2);
    end
else
    Fout = F2;
    for k = 1:numel(F2)
        Fout(k) = rdividecol(F1,F2(k));
    end
end
    
% ----------------------------------------------------
function fout = rdividecol(f1,f2)

if (isempty(f1) || isempty(f2)), fout=chebfun; return; end

if isa(f2,'double')
    if f2 ==  0, error('CHEBFUN:rdivide:DivisionByZero','Division by zero'), end
    fout = f1*(1/f2);  
elseif ~isempty(roots(f2))
       error('CHEBFUN:rdivide:DivisionByZero','Division by zero')
elseif isa(f1,'double')    
    if f1 == 0, fout =chebfun(0); 
    else        
        fout = comp(f2,@(x) rdivide(f1,x));
        %fout = chebfun(@(x) f1./feval(f2,x), f2.ends);
        %fout.trans = f2.trans;
    end
else
    if f1.trans~=f2.trans
        error('CHEBFUN:rdivide:trans','The .trans field of the two functions must agree')
    end
    fout = comp(f1, @rdivide, f2);
    %chebfun(@(x) feval(f1,x)./feval(f2,x), union(f1.ends,f2.ends));
    %fout.trans = f1.trans;
end

