function Fout = rdivide(F1,F2)
% ./   Pointwise chebfun right divide.
% F./G returns a chebfun that represents the function F(x)/G(x). This may
% fail to converge if G is ever close to zero.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

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
    return
end
    
r = roots(f2);    
if isa(f1,'double')
    [ends(1) ends(2)] = domain(f2);
else
    ends = get(f1,'ends');
end
newbkpts = setdiff(r,ends);

if ~isempty(newbkpts)
    d = union(ends,newbkpts);
    d = union(d,get(f2,'ends'));
    f1 = chebfun(f1,d);
    f2 = chebfun(f2,d);
    fout = rdividecol(f1,f2);
%        error('CHEBFUN:rdivide:DivisionByZero','Division by zero')
elseif isa(f1,'double')    
    if f1 == 0
		fout = chebfun(0, f2.ends([1,end])); 
      	fout.jacobian = anon('@(u) 0*jacobian(f2,u)',{'f2'},{f2});
      	fout.ID = newIDnum();
    else        
        fout = comp(f2,@(x) rdivide(f1,x));
        %fout = chebfun(@(x) f1./feval(f2,x), f2.ends);
        %fout.trans = f2.trans;

        fout.jacobian = anon('@(u) diag(-f1./f2.^2)*jacobian(f2,u)',{'f1','f2'},{f1 f2});
		fout.ID = newIDnum();
    end
else
    if f1.trans~=f2.trans
        error('CHEBFUN:rdivide:trans','The .trans field of the two functions must agree')
    end
    fout = comp(f1, @rdivide, f2);
    %chebfun(@(x) feval(f1,x)./feval(f2,x), union(f1.ends,f2.ends));
    %fout.trans = f1.trans;
    fout.jacobian = anon('@(u) diag(1./f2)*jacobian(f1,u) - diag(f1./f2.^2)*jacobian(f2,u)',{'f1','f2'},{f1 f2});
    fout.ID = newIDnum();
end

