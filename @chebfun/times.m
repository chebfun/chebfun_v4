function Fout = times(F1,F2)
% .*   Chebfun multiplication.
% F.*G multiplies chebfuns F and G or a chebfun by a scalar if either F or G is
% a scalar.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information. 
        
if (isempty(F1) || isempty(F2)), Fout = chebfun; return; end

% scalar times chebfun
if isa(F1,'double') || isa(F2,'double')
    Fout = F1 * F2;
else 
% product of two chebfuns

    if any(size(F1)~=size(F2))
        error('CHEBFUN:times:quasi','Quasimatrix dimensions must agree')
    end
      
    Fout = F1;
    for k = 1:numel(F1)
        Fout(k) = timescol(F1(k),F2(k));
    end

end

% -------------------------------
function f = timescol(f,g)


% product of two chebfuns
[f,g] = overlap(f,g);
ffuns = [];
scl = 0;
for k = 1:length(f.ends)-1
    ffuns = [ffuns f.funs(k).*g.funs(k)];
    scl = max(scl,ffuns(end).scl.v); % update scale variable
end

% Deal with impulse matrix:
%------------------------------------------------
% Look for deltas in f
hfimps = zeros(size(f.imps));
deg_delta = find(sum(abs(f.imps),2)>eps*f.scl , 1, 'last')-1;
dg = g;
for j = 2:deg_delta+1
    hfimps(j,:) = (-1)^j * feval(dg,f.ends) .* f.imps(j,:) + hfimps(j-1,:);
    if j<deg_delta+1, dg = diff(dg); end
end

% Look for deltas in g
hgimps = zeros(size(g.imps));
deg_delta = find(sum(abs(g.imps),2)>eps*g.scl , 1, 'last')-1;
df = f;
for j = 2:deg_delta+1
    hgimps(j,:) = (-1)^j * feval(df,g.ends) .* g.imps(j,:) + hgimps(j-1,:);
    if j<deg_delta+1, df = diff(df); end
end

% Contributions of both f and g.
imps = hfimps + hgimps;

% INF if deltas at a common point
indf = find(f.imps); indg = find(g.imps);
if any(indg(2:end,:))
     [indboth,trash] = intersect(indf,indg);
     imps(indboth) = inf*sign(f.imps(indboth).*g.imps(indboth));
end

% Update first row of h.imps (function values)
% this seems to be slow:
% imps(1,:) = feval(f,f.ends).*feval(g,g.ends);
% replaced with
tmp = f.imps(1,:).*g.imps(1,:);

tol = 10*f.scl.*chebfunpref('eps');
if any(isinf(tmp))
    for k = 1:length(tmp)
        if isinf(tmp(k)) && (f.imps(1,k)<tol || g.imps(1,k)<tol)
            tmp(k) = NaN;
        end
    end   
end
imps(1,:) = tmp;
    
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

% Set chebfun: (use f)
f.jacobian = anon('[Jfu nonConstJfu] = diff(f,u,''linop''); [Jgu nonConstJgu] = diff(g,u,''linop''); der = diag(f)*Jgu + diag(g)*Jfu; nonConst = (~Jfu.iszero & ~Jgu.iszero) | (nonConstJgu | nonConstJfu);',{'f' 'g'},{f g},1);
f.ID = newIDnum();

% update scales in funs:
for k = 1:f.nfuns-1
    funscl = ffuns(k).scl.v;
    ffuns(k).scl.v = scl;      % update scale field
    if  funscl < 10*scl        % if scales are significantly different, simplify!
        ffuns(k) = simplify(ffuns(k));
    end
end

f.funs= ffuns; f.imps=imps; f.scl = scl;