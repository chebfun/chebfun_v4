function [lines marks jumps] = plotdata(f,g,h,numpts)
    
if ~isempty(h)
    error('chebfun:plotdata:plot3','plot3 not supported yet.');
end

if isempty(f) && isreal(g)
    % one real chebfun (or quasimatrix) input

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
    
    % values of g
    gl = feval(g,fl); 
    
    % deal with breakpoints
    for k = 1:numel(g)
        endsk = get(g(:,k),'ends');
        for j = 2:length(endsk)-1
            [TL loc] = ismember(endsk(j),ends);
            if TL
                gl(indx2(3*(loc-1)+(1:3)),k) = ...
                    [ g(:,k).funs(j-1).vals(end); NaN ; g(:,k).funs(j).vals(1) ];
            end
        end
    end
    
    lines = {fl, gl};
    marks = {}; 
    jumps = {};
    
elseif ~isreal(g) 
    % complex chebfun
    fl = real(g);
    gl = imag(g);
    
    lines = {fl, gl};
    marks = {}; 
    jumps = {};

else
    % f and g are both chebfuns/quasimatrices
    nf = numel(f);
    ng = numel(g);
    
    if (nf~=1  || ng~=1)&& nf~=ng
        error('chebfun:plot:quasisize','Inconsistent quasimatrix sizes');
    end
    
    fl = f;
    gl = g;
    
    lines = {fl, gl};
    marks = {}; 
    jumps = {};
    
end