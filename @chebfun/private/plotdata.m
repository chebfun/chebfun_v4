function [lines marks jumps jval] = plotdata(f,g,h,numpts)
% PLOTDATA returns data (double) for plotting chebfuns.
% This function is used in PLOT, PLOT3, WATERFALL, ...
%
% INPUT: F,G,H are quasimatrices (F and H are optional). NUMPTS is the
% number of data points to be generated.
%
% OUTPUT: LINES cell array with line data. MARKS cell array for markers at
% chebyshev data. JUMPS cell array to generate jump lines. JVAL function
% value at jump points.
%

%  Copyright 2002-2009 by The Chebfun Team.
%  Last commit: $Author$: $Rev$:
%  $Date$:

% Check domains: f,g,h must have the same domain
if ~isempty(f)
    if any(f(1).ends([1,end]) ~= g(1).ends([1,end]))
        error('chebfun:plot:domain','Inconsistent domains');
    end
    if ~isempty(h)
        if any(f(1).ends([1,end]) ~= h(1).ends([1,end]))
            error('chebfun:plot:domain','Inconsistent domains');
        end
    end
end

marks = {}; jumps = {}; jval = {};
if isempty(f) && isempty(g)
    lines = {};
    return
end

% Simple restriction for plotting on unbounded domains
if isinf(g(1).ends(1)) || isinf(g(1).ends(end))   
    if isinf(g(1).ends(1)) && isinf(g(1).ends(end))    
        newd = domain(-10,10);
    elseif isinf(g(1).ends(end))
        newd = domain(g(1).ends(1),g(1).ends(1)+10);
    elseif isinf(g(1).ends(1))
        newd = domain(-10+g(1).ends(end),g(1).ends(end));
    end  
    g = restrict(g,newd);
    if ~isempty(f)
        f = restrict(f,newd);
    end
    if ~isempty(h)
        h = restrict(h,newd);
    end 
end

if isempty(f)
    % one real chebfun (or quasimatrix) input
    
    % is g real?
    greal = isreal(g);
    
    if g(1).trans
        g = g.';
    end
    
    % equispaced points over domain
    [a b] = domain(g);
    fl = linspace(a,b,numpts).';
    
    % find all the ends
    ends = [];
    for k = 1:numel(g)
        ends = [ends g(:,k).ends];
    end
    ends = unique(ends);         ends = ends(2:end-1);

    % evaluation points
    fl = [a ; reshape(repmat(ends,3,1),3*length(ends),1) ; b ; setdiff(fl,[a ; ends.' ; b])];
    [fl indx] = sort(fl);    [ignored indx2] = sort(indx);
    
    % line values of g
    gl = feval(g,fl);

    % deal with marks breakpoints
    for k = 1:numel(g)
        gk = g(:,k);
        endsk = get(gk,'ends');
        
        % get the marks
        fmk = get(gk,'points');
        gmk = get(gk,'vals');
        
        gl(1,k) = gk.funs(1).vals(1);
        gl(end,k) = gk.funs(gk.nfuns).vals(end);
        
        % breakpoints
        for j = 2:length(endsk)-1
            [TL loc] = ismember(endsk(j),ends);
            if TL
                % values on either side of jump
                jmpvls = [ g(:,k).funs(j-1).vals(end); NaN ; g(:,k).funs(j).vals(1) ];
                gl(indx2(3*(loc-1)+(1:3)+1),k) = jmpvls;
             end
        end

        % Jump lines (fjk,gjk) and jump values (jvalf,jvalg)
        nends = length(endsk(2:end-1));
        if nends > 0
            fjk = reshape(repmat(endsk(2:end-1),3,1),3*nends,1); 
        else
            fjk = NaN(3,1);
        end
        [gjk jvalg isjg] = jumpvals(g(k),endsk);
        jvalf = endsk.';

        % Remove continuous breakpoints from jumps:
        for j = 1:length(endsk)
            if ~isjg(j)
                jvalg(j) = NaN;
                jvalf(j) = NaN;
            end
        end
        if greal
            jval = [jval jvalf jvalg];
        else
            jval = [jval NaN NaN];
            % do not plot jumps
            fjk = NaN;
            gjk = NaN;
            
            % x = real data, y = imag data
            fmk = real(gmk);
            gmk = imag(gmk);
        end
        
        % store jumps and marks
        jumps = [jumps, fjk, gjk];
        marks = [marks, fmk, gmk];
    end
    
    % store lines
    if ~greal
        fl = real(gl);
        gl = imag(gl);
    end
    
    lines = {fl, gl};
    
elseif isempty(h) % Two quasimatrices case
    
    % f and g are both chebfuns/quasimatrices
    nf = numel(f);
    ng = numel(g);
    
    % Check size
    if  nf~=ng && nf~=1 && ng~=1
        error('chebfun:plot:quasisize','Inconsistent quasimatrix sizes');
    end
    
    % Deal with row quasimatrices
    if f(1).trans ~= g(1).trans
        error('chebfun:plot:quasisize','Inconsistent quasimatrix sizes');
    end
    if f(1).trans
        f = f.'; g = g.';
    end
    
    if nf == 1
        couples = [ones(1,ng) ; 1:ng].';
    elseif ng == 1
        couples = [1:nf ; ones(1,nf)].';
    else
        couples = [1:nf ; 1:ng].';
    end
    
    % lines 
    h = [f g];
    lines = plotdata([],h,[],numpts);
    fl = lines{2}(:,1:nf);
    gl = lines{2}(:,(nf+1):end);
    lines = {fl, gl};
    
    % Jump lines:
    jumps = {}; jval = {};
    for k = 1:max(nf,ng)
        kf = couples(k,1); kg = couples(k,2);
        ends = unique([f(kf).ends,g(kg).ends]);
        [jumps{2*k-1} jval{2*k-1} isjf] = jumpvals(f(kf),ends);
        [jumps{2*k} jval{2*k} isjg] = jumpvals(g(kg),ends); 
        % Remove continuous breakpoints from jumps:
        for j = 1:length(ends)
            if ~isjf(j) && ~isjg(j)
                jval{2*k-1}(j) = NaN;
                jval{2*k}(j) = NaN;
            end
        end
    end
       
    % marks
    marks = {};
    for k = 1:max(nf,ng)
        if nf == 1
            [fk,gk] = overlap(f(1),g(k));
        elseif ng == 1
            [fk,gk] = overlap(f(k),g(1));
        else
            [fk,gk] = overlap(f(k),g(k));
        end
        fm = []; gm = [];
        for j = 1:fk.nfuns
            if fk.funs(j).n > gk.funs(j).n
                fm = [fm; fk.funs(j).vals];
                gkf = prolong(gk.funs(j), fk.funs(j).n);
                gm = [gm; gkf.vals];
            else
                gm = [gm; gk.funs(j).vals];
                fkf = prolong(fk.funs(j), gk.funs(j).n);
                fm = [fm; fkf.vals];
            end
        end
        marks{2*k-1} = fm;
        marks{2*k} = gm;
    end
    
else % Case of 3 quasimatrices (used in plot3)
    
    nf = numel(f); ng = numel(g); nh = numel(h);
    if  nf~=ng && nf~=1 && ng~=1 && nh~=1
        error('chebfun:plot:quasisize','Inconsistent quasimatrix sizes');
    end
        
    % Deal with row quasimatrices
    if  f(1).trans ~= g(1).trans || f(1).trans ~= h(1).trans
        error('chebfun:plot:quasisize','Inconsistent quasimatrix sizes');
    end
    if f(1).trans
        f = f.'; g = g.'; h = h.';
    end
    
    % lines
    lines = plotdata([],[f g h], [], numpts);
    fl = lines{2}(:,1:nf);
    gl = lines{2}(:,(nf+1):(nf+ng));
    hl = lines{2}(:,(nf+ng+1):end);
    lines = {fl, gl, hl};
    
    n = max([nf,ng,nh]);
    if nf == 1, f = repmat(f,1,n); end
    if ng == 1, g = repmat(g,1,n); end
    if nh == 1, h = repmat(h,1,n); end
    
    % marks
    marks = {};
    for k = 1:n
        [fk,gk] = overlap(f(k),g(k));
        [fk,hk] = overlap(fk, h(k));
        [gk,fk] = overlap(gk, fk);
        fm = []; gm = []; hm = [];
        for j = 1:fk.nfuns
            maxn = max([fk.funs(j).n, gk.funs(j).n, hk.funs(j).n]);
            if fk.funs(j).n == maxn
                fm = [fm; fk.funs(j).vals];
                gkf = prolong(gk.funs(j), fk.funs(j).n);
                gm = [gm; gkf.vals];
                hkf = prolong(hk.funs(j), fk.funs(j).n);
                hm = [hm; hkf.vals];
            elseif gk.funs(j).n == maxn
                gm = [gm; gk.funs(j).vals];
                fkf = prolong(fk.funs(j), gk.funs(j).n);
                fm = [fm; fkf.vals];
                hkf = prolong(hk.funs(j), gk.funs(j).n);
                hm = [hm; hkf.vals];
            else
                hm = [hm; hk.funs(j).vals];
                fkf = prolong(fk.funs(j), hk.funs(j).n);
                fm = [fm; fkf.vals];
                gkf = prolong(gk.funs(j), hk.funs(j).n);
                gm = [gm; gkf.vals];
            end
        end
        marks{3*k-2} = fm;
        marks{3*k-1} = gm;
        marks{3*k} = hm;
    end
    
    % Jump lines and values:
    jumps = {}; jval = {};
    for k = 1:n
        ends = unique([f(k).ends,g(k).ends,h(k).ends]);
        [jumps{3*k-2} jval{3*k-2} isjf] = jumpvals(f(k),ends);
        [jumps{3*k-1} jval{3*k-1} isjg] = jumpvals(g(k),ends); 
        [jumps{3*k} jval{3*k} isjh] = jumpvals(h(k),ends); 
        % Remove continuous breakpoints from jumps:
        for j = 1:length(ends)
            if ~isjf(j) && ~isjg(j) && ~isjh(j)
                jval{3*k-2}(j) = NaN;
                jval{3*k-1}(j) = NaN;
                jval{3*k}(j) = NaN;
            end
        end
    end
    
end



function [fjump jval isjump] = jumpvals(f,ends)
% JUMPVALS returns the vaules of F at jumps (JVAL) and the left and right 
% limits (FJUMP) for plotting jump lines.
% ISJUMP is true if the difference of multiple values at a jump location is
% larger than a tolerace. 
% ENDS is the vector with possible jump locations.

if length(ends) == 2
    fjump = [NaN; NaN; NaN];
else
    fjump = zeros(3*(length(ends)-2),1);
end

hs = max(abs(f.ends([1 end])));
jval = zeros(length(ends),1);
isjump = jval;

tol = 1e-4*f.scl;

jval(1) = f.imps(1,1);
if abs(jval(1)-f.funs(1).vals(1)) < tol
    isjump(1) = false;
else
    isjump(1) = true;
end

for j = 2:length(ends)-1
    [MN loc] = min(abs(f.ends-ends(j)));
    if MN < 1e4*eps*hs
        lval = f.funs(loc-1).vals(end); rval = f.funs(loc).vals(1);
        fjump(3*j-(5:-1:3)) = [lval; rval; NaN];
        jval(j) = f.imps(1,loc);
        if abs(lval-rval) < tol && abs(jval(j)-lval) < tol
            isjump(j) = false;
        else
            isjump(j) = true;
        end
    else
        fval = feval(f,ends(j));
        fjump(3*j-(5:-1:3)) = [fval; fval; NaN];
        jval(j) = fval;
        isjump(j) = false;
    end
end

jval(end) = f.imps(1,end);
if abs(jval(end)-f.funs(end).vals(end)) < tol
    isjump(end) = false;
else
    isjump(end) = true;
end
