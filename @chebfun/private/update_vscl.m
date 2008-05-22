function f = update_vscl(f)
% Updates the vertical scale field of a chebfun.
% Goes through funs to find the largest vertical scale and updates the 
% global scale accordingly.

% Copyright 2002-2008 by The Chebfun Team. 
% See www.comlab.ox.ac.uk/chebfun.html

vscl = 0;
for k = 1:f.nfuns
    vscl = max(vscl, get(f.funs(k),'scl.v'));
end

for k = 1:f.nfuns
    f.funs(k) = set(f.funs(k),'scl.v',vscl);
end
f.scl = vscl;