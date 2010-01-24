function Fout = rdivide(F1,F2)
% ./   Pointwise chebfun right divide.
% F./G returns a chebfun that represents the function F(x)/G(x). This may
% fail to converge if G is ever close to zero.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

if (isempty(F1) || isempty(F2)), Fout = chebfun; return; end

if isa(F1,'chebfun')&&isa(F2,'chebfun')
    if size(F1)~=size(F2)
        error('CHEBFUN:rdivide:quasi','Quasi-matrix dimensions must agree')
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
    ends = get(f2,'ends');
else
    ends = get(f1,'ends');
end

% Remove poles that are close to existing breakpoints
% (slow and hacky!)
tol = 100*chebfunpref('eps');
j = 1;
while j <= length(r)
    if any(abs(r(j)-ends)<tol)
        r(j) = [];
    else
        j = j+1;
    end
end
    
% The new breakpoints
newbkpts = setdiff(r,ends);

if ~isempty(newbkpts)
    d = union(ends,newbkpts);
    d = union(d,get(f2,'ends'));
    if isa(f1,'chebfun'), f1 = overlap(f1,d); end
    f2 = overlap(f2,d);
    fout = rdividecol(f1,f2);
%        error('CHEBFUN:rdivide:DivisionByZero','Division by zero')
elseif isa(f1,'double')    
    if f1 == 0
		fout = chebfun(0, f2.ends([1,end])); 
      	fout.jacobian = anon('@(u) 0*jacobian(f2,u)',{'f2'},{f2});
      	fout.ID = newIDnum();
    else   
        exps = get(f2,'exps');
        poles = false;
        for k = 1:f2.nfuns
            if abs(get(f2.funs(k),'lval'))<tol || abs(get(f2.funs(k),'rval'))<tol
                poles = true; break
            end
        end
        if ~poles && ~any(any(exps)) % No exps. Old school case
            fout = comp(f2,@(x) rdivide(f1,x));
        else % remove exps, compute without, and add back
            fout = chebfun;
            for k = 1:f2.nfuns
                f2k = f2.funs(k);
                f2k = extract_roots(f2k);
                expsk = f2k.exps;
                f2k.exps = [0 0];
                tmp = comp(chebfun(f2k,ends(k:k+1)),@(x) rdivide(f1,x));
                tmp.funs(1).exps(1) = -expsk(1);
                tmp.funs(end).exps(2) = -expsk(2);
                tmp.funs(1) = replace_roots(tmp.funs(1));
                tmp.funs(end) = replace_roots(tmp.funs(end));
                fout = [fout ; tmp];
            end
        end
        if fout.nfuns == f2.nfuns
            fout.imps = f1./f2.imps;
        end
        fout.jacobian = anon('@(u) diag(-f1./f2.^2)*jacobian(f2,u)',{'f1','f2'},{f1 f2});
        fout.ID = newIDnum();
    end
else
    if f1.trans~=f2.trans
        error('CHEBFUN:rdivide:trans','The .trans field of the two functions must agree')
    end

    exps1 = get(f1,'exps'); exps2 = get(f2,'exps');
    poles = false;
    for k = 1:f2.nfuns
        if abs(get(f2.funs(k),'lval'))<tol || abs(get(f2.funs(k),'rval'))<tol
            poles = true; break
        end
    end
    if ~poles && (~any(any(exps1)) && ~any(any(exps2))) % No exps. Old school case
        fout = comp(f1, @rdivide, f2);
    else % compute without exps (not surrently working)
        fout = chebfun;
        for k = 1:f2.nfuns
            f1k = f1.funs(k);   f2k = f2.funs(k);
            f2k = extract_roots(f2k);
            exps1k = f1k.exps;  exps2k = f2k.exps;
            f1k.exps = [0 0];   f2k.exps = [0 0];
            tmp = comp(chebfun(f1k,ends(k:k+1)), @rdivide, chebfun(f2k,ends(k:k+1)));
            tmp.funs(1).exps(1) = exps1k(1)-exps2k(1);
            tmp.funs(end).exps(2) = exps1k(2)-exps2k(2);
            tmp.funs(1) = replace_roots(tmp.funs(1));
            tmp.funs(end) = replace_roots(tmp.funs(end));
            fout = [fout ; tmp];
        end
    end
    if fout.nfuns == f2.nfuns
        fout.imps = f1.imps./f2.imps;
    end
    
    fout.jacobian = anon('@(u) diag(1./f2)*jacobian(f1,u) - diag(f1./f2.^2)*jacobian(f2,u)',{'f1','f2'},{f1 f2});
    fout.ID = newIDnum();
end

