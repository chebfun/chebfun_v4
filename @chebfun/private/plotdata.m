function [lines marks jumps jval misc] = plotdata(f,g,h,numpts,interval)
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

misc = []; infy = false;
if nargin < 5, interval = []; end

% Check domains: f,g,h must have the same domain
if ~isempty(f)
    if any(f(1).ends([1,end]) ~= g(1).ends([1,end]))
        error('CHEBFUN:plot:domain','Inconsistent domains');
    end
    if ~isempty(h)
        if any(f(1).ends([1,end]) ~= h(1).ends([1,end]))
            error('CHEBFUN:plot:domain2','Inconsistent domains');
        end
    end
end

marks = {}; jumps = {}; jval = {};
if isempty(f) && isempty(g)
    lines = {};
    return
end

% Set the plotting interval
dom = domain(g); % by default use the whole domain
if ~isempty(interval)
    % user defined
    if isa(interval,'domain'); interval = interval.ends; end
    if interval(1) < dom(1), interval(1) = dom(1); end
    if interval(2) > dom(2), interval(2) = dom(2); end
    dom = domain(interval);
elseif any(isinf(g(1).ends([1 end]))) 
    % defaults for unbounded domains
    if all(isinf(g(1).ends([1 end])))
        dom = domain(-10,10);
    elseif isinf(g(1).ends(end))
        dom = domain(g(1).ends(1),g(1).ends(1)+10);
    elseif isinf(g(1).ends(1))
        dom = domain(-10+g(1).ends(end),g(1).ends(end));
    end     
end
% Don't exclude anything
if isempty(interval), interval = dom.ends([1 end]); end

if isempty(f)
    % one real chebfun (or quasimatrix) input
    
    % is g real?
    greal = isreal(g);
    
    % Make g a column chebfun
    if g(1).trans
        g = g.';
    end
    
    % initialise y limits (auto adjusted if there are exps)
    top = -inf; bot = inf;
    
    % equispaced points over domain
    ab = dom.ends; a = ab(1); b = ab(2);
    fl = linspace(a,b,numpts).';
    
    % find all the ends and get rid of high order imps
    ends = [];
    for k = 1:numel(g)
        % old
        ends = [ends g(:,k).ends];
        g(:,k).imps = g(:,k).imps(1,:);
        % new
%         endsk = g(:,k).ends;       
%         endsk(endsk<a | endsk>b) = [];
%         ends = [ends g(:,k).ends];
%         g(:,k).imps = g(:,k).imps(1,:);
    end
    ends = unique(ends);         ends = ends(2:end-1);
    ends(ends<a | ends>b) = [];

    % evaluation points
    fl = [reshape(repmat(ends,3,1),3*length(ends),1) ; setdiff(fl,ends.')];
    if greal
        % remove values outside interval
        mask = (fl < a) | (fl > b);
        fl(mask) = [];
    end
    % sort
    [fl indx] = sort(fl);    [ignored indx2] = sort(indx);

    % line values of g
    gl = feval(g,fl);

    if fl(1) == a, 
        for k = 1:size(gl,2)
            gl(1,k) = get(g(:,k).funs(1),'lval'); 
        end
    end
    if fl(end) == b, 
        for k = 1:size(gl,2)
            gl(end,k) = get(g(:,k).funs(end),'rval'); 
        end
    end
    
    % Who put this here?
    dg = domain(g);
    if a~=dg(1), gl(1,:) = feval(g,a);   end
    if b~=dg(end), gl(end,:) = feval(g,b);   end
    
    % deal with marks breakpoints
    for k = 1:numel(g)
        gk = g(:,k);
        endsk = get(gk,'ends');
        endsmask = endsk(endsk<a | endsk > b);

        % With markfuns we need to adjust the vals when getting marks
        fmk = []; gmk = []; expsk = [];
        for j = 1:gk.nfuns
            fmkj = get(gk.funs(j),'points');
            gmkj = get(gk.funs(j),'vals');
            expskj = get(gk.funs(j),'exps');
            
            mask = (fmkj < a) | (fmkj > b);
            fmkj(mask) = [];
            gmkj(mask) = [];

            if all(isfinite(endsk(j:j+1)))
                rescl = (2/diff(gk.funs(j).map.par(1:2)))^sum(expskj);
                gmkj = rescl*gmkj.*((fmkj-endsk(j)).^expskj(1).*(endsk(j+1)-fmkj).^expskj(2)); % adjust using exps
            else
                x = gk.funs(j).map.inv(fmkj);
                s = gk.funs(j).map.par(3);
                if all(isinf(endsk)), rescl = .5/(5*s);
                else                 rescl = .5/(15*s);               end
                rescl = rescl.^sum(expskj);
                gmkj = rescl*gmkj.*((x+1).^expskj(1).*(1-x).^expskj(2)); 
            end
            
            expsk = [expsk ; expskj(1)];

            fmk = [fmk ; fmkj]; % store global x-marks
            gmk = [gmk ; gmkj]; % store global y-marks
        end 
        expsk = [expsk ; expskj(2)];
        
        % Auto adjust y limits based upon standard deviation
        if any(expsk<0)
            infy = true;
            val = 0.1; mintrim = 3;
            
            % Find the break points for the current quasimatrix
            breaksk = zeros(length(endsk),1);
            for l = 1:length(endsk)
                if endsk(l) < a
                    breaksk(l) = 1;
                elseif endsk(l) > b
                    breaksk(l) = length(fl);
                elseif isinf(endsk(l))
                    breaksk(l) = length(fl)*(1+sign(endsk(l)))/2;
                else
                    breaksk(l) = find(fl==endsk(l),1);
                end
            end
            dbk = diff(breaksk);
            
            nnl = max(round(-val*dbk.*expsk(1:end-1)),mintrim);
            nnr = max(round(-val*dbk.*expsk(2:end)),mintrim);
            mask = [];
            for j = 1:length(breaksk)-1
                mask = [mask breaksk(j)+nnl(j):breaksk(j+1)-nnr(j)];
            end
            if ~isempty(mask)
                mask([1 end]) = [];
            end
            masked = gl(mask,k);
            sd = std(masked);
            bot = min(bot,min(masked)-sd);
            top = max(top,max(masked)+sd);
        end

        % Jump lines (fjk,gjk) and jump values (jvalf,jvalg)
        nends = length(endsk(2:end-1));
        if nends > 0
            fjk = reshape(repmat(endsk(2:end-1),3,1),3*nends,1); 
        else
            fjk = NaN(3,1);
        end
        [gjk jvalg isjg] = jumpvals(g(k),endsk);
        gjk2 = gjk;
        jvalf = endsk.';
        
        % remove jval data outside of 'interval'
        if greal
            mask = jvalf<a | jvalf>b;
            jvalf(mask) = NaN; jvalg(mask) = NaN;
        end

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
            
%             mask = (fmk < interval(1)) | (fmk > interval(2));
%             fmk(mask) = []; gmk(mask) = [];
        end
        
        % breakpoints
        for j = 2:length(endsk)-1
            if endsk(j) >= interval(1) && endsk(j) <= interval(2)
                [TL loc] = ismember(endsk(j),ends);
                if TL && ~any(isinf(gl(indx2(3*(loc-1)+(1:3)+1),k)))
                    % values on either side of jump
    %                 jmpvls = [ gk.funs(j-1).vals(end); NaN ; gk.funs(j).vals(1) ];
    %                 jmpvls = [  gk.funs(j-1).vals(end)*diff(endsk(j-1:j)).^sum(gk.funs(j-1).exps)
    %                             NaN
    %                             gk.funs(j).vals(1)*diff(endsk(j:j+1)).^sum(gk.funs(j).exps)];
    %                 [jmpvls ignored ignored] = jumpvals(g(k),endsk(j-1:j+1));
                    jmpvls = gjk2(3*(j-2)+[1:3]);
    %                 gl(indx2(3*(loc-1)+[1 3 2]+1),k) = jmpvls;
                    gl(fl==endsk(j),k) = jmpvls;
                end
            end
        end
        
        if greal
            % remove values outside interval
            mask = (fjk < a) | (fjk > b);
            fjk(mask) = []; gjk(mask) = [];
        end
        
        % store jumps and marks
        jumps = [jumps, fjk, gjk];
        % With 'interval', there might not actually be any marks.
        if numel(fmk) == 0, fmk = NaN; gmk = NaN; end
        marks = [marks, fmk, gmk];
    end

    % store lines
    if ~greal
        mask = (fl < a) | (fl > b);
            
        fl = real(gl);
        gl = imag(gl);
        
        fl(mask) = [];
        gl(mask) = [];
        
%         % remove data outside of real 'interval'
%         mask = (fl < interval(1)) | (fl > interval(2));
%         fl(mask) = []; gl(mask) = [];
    end
    
    lines = {fl, gl};
    misc = [infy bot top];
    
elseif isempty(h) % Two quasimatrices case
    
    % f and g are both chebfuns/quasimatrices
    nf = numel(f);
    ng = numel(g);
    
    % Check size
    if  nf~=ng && nf~=1 && ng~=1
        error('CHEBFUN:plot:quasisize','Inconsistent quasimatrix sizes');
    end
    
    % Deal with row quasimatrices
    if f(1).trans ~= g(1).trans
        error('CHEBFUN:plot:quasisize2','Inconsistent quasimatrix sizes');
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
        error('CHEBFUN:plot:quasisize3','Inconsistent quasimatrix sizes');
    end
        
    % Deal with row quasimatrices
    if  f(1).trans ~= g(1).trans || f(1).trans ~= h(1).trans
        error('CHEBFUN:plot:quasisize4','Inconsistent quasimatrix sizes');
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
if abs(jval(1)-get(f.funs(1),'lval')) < tol && f.funs(1).exps(1) >= 0
    isjump(1) = false;
else
    isjump(1) = true;
end

for j = 2:length(ends)-1
    [MN loc] = min(abs(f.ends-ends(j)));
    if MN < 1e4*eps*hs
        lval = get(f.funs(loc-1),'rval');%*(ends(loc)-ends(loc-1)).^sum(f.funs(loc-1).exps);
        if f.funs(loc-1).exps(2) < 0, lval = sign(lval)/eps; end  % 1/eps should be inf or realmax, but this doesn't work?
        if f.funs(loc-1).exps(2) > 0, lval = 0; end  % This is a hack?
        rval = get(f.funs(loc),'lval');%*(ends(loc+1)-ends(loc)).^sum(f.funs(loc).exps);
        if f.funs(loc).exps(1) < 0, rval = sign(rval)/eps; end    % 1/eps should be inf or realmax, but this doesn't work?
        if f.funs(loc).exps(1) > 0, rval = 0; end    % This is a hack?  

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
