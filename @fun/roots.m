function out = roots(g)
% ROOTS	Roots in the interval [-1,1]
% ROOTS(G) returns the roots of the FUN G in the interval [-1,1].

epstol = 1e-14;
if (g.n<101)                                    % for small length funs
    c=chebpoly(g);                              % compute Cheb coeffs
    if abs(c(1)) < realmin
        ind= find(abs(c)>realmin,1,'first');
        if isempty(ind), out = zeros(length(c),1);
            return
        end
        c=c(ind:end);
    end
    if (g.n<3)
        r=roots(chebpoly(g));
    else
        c=.5*c(end:-1:2)/(-c(1));               % assemble colleague matrix A
        c(end-1)=c(end-1)+.5;
        oh=.5*ones(length(c)-1,1);
        A=diag(oh,1)+diag(oh,-1);
        A(1,2)=1;
        A(end,:)=c;
        r=eig(A);                               % compute roots as eig(A)
    end
    mask=abs(imag(r))<epstol*g.scl.h;           % filter imaginary roots
    r = real( r(mask) );
    out = sort(r(abs(r) <= 1+epstol*g.scl.h));  % keep roots inside [-1 1]
    if ~isempty(out)
        out(1) = max(out(1),-1);                % correct root -1
        out(end) = min(out(end),1);             % correct root  1
    end
else
    c = rand*.2-.1;                             % split at a random point
    g1 = restrict(g,[-1,c]);
    g2 = restrict(g,[ c,1]);
    out = [-1+(roots(g1)+1)*.5*(1+c);...          % find roots recursively 
        c+(roots(g2)+1)*.5*(1-c)];              % and rescale them
end
