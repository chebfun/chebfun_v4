function Fout = times(F1,F2)
% .*	Chebfun multiplication
% F.*G multiplies chebfuns F and G or a chebfun by a scalar if either F or G is
% a scalar.

% Chebfun Version 2.0
        
if (isempty(F1) || isempty(F2)), Fout = chebfun; return; end

% scalar times chebfun
if isa(F1,'double') || isa(F2,'double')
    
    Fout = F1 * F2;

else 
% product of two chebfuns

    if size(F1)~=size(F2)
        error('Quasi-matrix dimensions must agree')
    end
      
    Fout = F1;
    for k = 1:numel(F1)
        Fout(k) = timescol(F1(k),F2(k));
    end

end

% -------------------------------
function h = timescol(f,g)

% product of two chebfuns
[f,g] = overlap(f,g);
h = f;
for k = 1:length(f.ends)-1
    h.funs(k) = f.funs(k).*g.funs(k);
end

% impulses
indf=find(f.imps); indg=find(g.imps);
rows=size(f.imps,1);
if any(indf)
    gvals=repmat(feval(g,h.ends),rows);
    h.imps(indf) = f.imps(indf).*gvals(indf);
end
if any(indg)
    fvals=repmat(feval(f,h.ends),rows);
    h.imps(indg) = g.imps(indg).*fvals(indg);
    [trash,indboth] = intersect(indf,indg);
    imps_cp = h.imps;
    h.imps(indboth) = nan;
    h.imps(1,:) = imps_cp(1,:); %fix first row since these are funct. vals.
end
