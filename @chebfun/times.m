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
ffuns = [];
for k = 1:length(f.ends)-1
    ffuns = [ffuns f.funs(k).*g.funs(k)];
end

% Deal with impulse matrix:
%------------------------------------------------
% Look for deltas in f
hfimps = 0*f.imps;
deg_delta = find(sum(abs(f.imps),2)>eps*f.scl , 1, 'first')-1;
dg = g;
for j = 2:deg_delta+1
    hfimps(j,:) = (-1)^j * feval(dg,f.ends) .* f.imps(j,:) + hfimps(j-1,:);
    dg = diff(dg);
end

% Look for deltas in g
hgimps = 0*g.imps;
deg_delta = find(sum(abs(g.imps),2)>eps*g.scl , 1, 'first')-1;
df = f;
for j = 2:deg_delta+1
    hgimps(j,:) = (-1)^j * feval(df,g.ends) .* g.imps(j,:) + hgimps(j-1,:);
    df = diff(df);
end

% Contributions of both f and g.
imps = hfimps + hgimps;

% INF if deltas at a common point
indf = find(f.imps); indg = find(g.imps);
if any(indg)
     [trash,indboth] = intersect(indf,indg);
     imps(indboth) = inf*sign(f.imps(indboth).*g.imps(indboth));
end

% Update first row of h.imps (function values)
imps(1,:) = feval(f,f.ends).*feval(g,g.ends);

% % If there are deltas, then function value is + or - inf. (or should it
% be nan in some cases?)
% if size(imps,1)>1
%     for k = 1:f.nfuns+1
%         ind = find(imps(2:end,k),1,'first');
%         if ~isempty(ind)            
%             imps(1,k) = inf*sign(imps(ind+1,k));
%         end
%     end
% end

% Set chebfun:
h = set(chebfun, 'funs', ffuns,'ends', f.ends, 'imps', imps, 'trans', f.trans);