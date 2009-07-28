function [lines marks jumps indx2] = plotdata(f,g,h,numpts)


marks = {}; jumps = {};
if isempty(f)
    % one real chebfun (or quasimatrix) input
    
    % is g real?
    greal = isreal(g);
    
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
        fjk = []; gjk = [];
        for j = 2:length(endsk)-1
            [TL loc] = ismember(endsk(j),ends);
            if TL
                % values on either side of jump
                jmpvls = [ g(:,k).funs(j-1).vals(end); NaN ; g(:,k).funs(j).vals(1) ];
%                 jmpvls = [ g(:,k).funs(j-1).vals(end); g(:,k).funs(j).vals(1) ; g(:,k).funs(j).vals(1) ];
                gl(indx2(3*(loc-1)+(1:3)+1),k) = jmpvls;
                
                % collect jumps
                fjk = [fjk ; endsk(j)*ones(3,1)];
                gjk = [gjk ; jmpvls([1 3 2].')];
            end
        end
        
        % for complex plots
        if ~greal
            % do not plot jumps
            fjk = [];
            gjk = [];
            
            % x = real data, y = imag data
            fmk = real(gmk);
            gmk = imag(gmk);
        end
        
        if isempty(fjk)
            fjk = NaN;
            gjk = NaN;
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
    
elseif isempty(h)
    
    % f and g are both chebfuns/quasimatrices
    nf = numel(f);
    ng = numel(g);
    
    %     if  nf~=ng && nf~=1 && ng~=1
    %         error('chebfun:plot:quasisize','Inconsistent quasimatrix sizes');
    %     end
    
    if nf == 1
        couples = [ones(1,ng) ; 1:ng].';
    elseif ng == 1
        couples = [1:nf ; ones(1,nf)].';
    else
        couples = [1:nf ; 1:ng].';
    end
    
    h = [f g];
    [lines marks jumps indx2] = plotdata([],h,[],numpts);
    fl = lines{2}(:,1:nf);
    gl = lines{2}(:,(nf+1):end);
    lines = {fl, gl};
    
    tmp = jumps;
    jumps = {};
    for k = 1:nf
        tmpk = tmp{2*k-1};
        [i j v] = find(couples(:,1)==k);
        for l = 1:length(i)
            jumps = [jumps tmp{2*k} myfeval(g(:,couples(i(l),2)),tmpk)];
        end
    end
    
    for k = nf+1:nf+ng
        [i j v] = find(couples(:,2)==k-nf);
        for l = 1:length(i)
            tmpk = tmp{2*k-1};
            jumps = [jumps myfeval(f(:,couples(i(l),1)),tmpk) tmp{2*k}];
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
    
    % Check domains
    if any(f.ends([1,end]) ~= g.ends([1,end]) & f.ends([1,end]) ~= h.ends([1,end]))
        error('chebfun:plot:domain','Inconsistent quasimatrix domains');
    end
    
    % Deal with row quasimatrices
    if length(unique([f(1).trans g(1).trans h(1).trans]))>1
        error('chebfun:plot:quasisize','Inconsistent quasimatrix sizes');
    end
    if f(1).trans
        f = f.'; g = g.'; h = h.';
    end
    
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
    
    % Jump lines:
    for k = 1:n
        ends = unique([f(k).ends,g(k).ends,h(k).ends]);
        jumps{3*k-2} = jumpvals(ends,f(k));
        jumps{3*k-1} = jumpvals(ends,g(k));
        jumps{3*k} = jumpvals(ends,h(k));
    end
  
end

function fjump = jumpvals(ends,f)
[ism, loc] = ismember(ends,f.ends);
fjump = zeros(3*(length(ends)-2),1);
for j = 2:length(ends)-1
    if ism(j)
        fjump(3*j-5) = f.funs(loc(j)-1).vals(end);
        fjump(3*j-4) = f.funs(loc(j)).vals(1);
        fjump(3*j-3) = NaN;
    else
        fjump(3*j-5) = feval(f,ends(j));
        fjump(3*j-4) = fjump(3*j-5);
        fjump(3*j-3) = NaN;
    end
end
                

function out = myfeval(f,x)
fends = f.ends; 
fends = fends(2:end-1);
out = zeros(length(x),1);
for k = 1:3:length(x)
    [MN loc] = min(abs(fends-x(k)));
    if MN < 1e4*chebfunpref('eps'), TF = true; else TF  = false;
    if TF
        out(k:k+2) = [f.funs(loc).vals(end) f.funs(loc+1).vals(1) NaN];
    else
        out(k:k+2) = repmat(feval(f,x(k)),3,1);
    end
end

