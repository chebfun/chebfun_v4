function [out,pos] = max(f,g)
% MAX   Maximum value or pointwise max function.
% MAX(F) returns the maximum value of the chebfun F. 
% 
% H = MAX(F,G), where F and G are chebfuns defined on the same domain,
% returns a chebfun H such that H(x) = max(F(x),G(x)) for all x in the
% domain of F and G.

%  Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if numel(f)>1 
    error('max and min do not handle chebfun quasi-matrices')
end

if nargin == 1
    
    % If there is an impulse, return inf
    ind = find(max(f.imps(2:end,:),[],1)>0,1,'first');
    if ~isempty(ind), out = inf; pos = f.ends(ind); return, end
    
    ends = f.ends;
    out = zeros(1,f.nfuns); pos = out;
    for i = 1:f.nfuns
        a = ends(i); b = ends(i+1);
        [o,p] = max(f.funs(i));
        out(i) = o;
        pos(i) = scale(p,a,b);
    end
    [out I] = max(out);
    pos = pos(I);
    
    %Check values at end break points
    ind = find(f.imps(1,:)>out);
    if ~isempty(ind)
       [out, k] = max(f.imps(1,ind));
       pos = ends(ind(k));
    end
    
else
    Fs = sign(f-g);
    out = ((Fs+1)/2).*f + ((1-Fs)/2).*g ;
    pos = [];
end

