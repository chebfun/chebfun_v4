function [lines marks jumps] = plotdata(f,g,h,numpts)
    
if ~isempty(h)
    error('chebfun:plotdata:plot3','plot3 not supported yet');
end

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
    fl = [reshape(repmat(ends,3,1),3*length(ends),1) ; fl];
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
        
        % breakpoints
        fjk = []; gjk = [];
        for j = 2:length(endsk)-1
            [TL loc] = ismember(endsk(j),ends);
            if TL
                % values on either side of jump
                jmpvls = [ g(:,k).funs(j-1).vals(end); NaN ; g(:,k).funs(j).vals(1) ];
                gl(indx2(3*(loc-1)+(1:3)),k) = jmpvls;
                
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
    
else
    % f and g are both chebfuns/quasimatrices
    nf = numel(f);
    ng = numel(g);
    
    if  nf~=ng && nf~=1 && ng~=1
        error('chebfun:plot:quasisize','Inconsistent quasimatrix sizes');
    end
    
    h = [f g];
    [lines marks jumps] = plotdata([],h,[],numpts);
    fl = lines{2}(:,1:nf);
    gl = lines{2}(:,(nf+1):end);

    lines = {fl, gl};
    marks = {fl(1), NaN*ones(1,ng)} 
    jumps = {fl(1), NaN}
    
end