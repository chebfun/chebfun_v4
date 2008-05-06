function fout = merge(f, bkpts, maxn)
%MERGE     Chebfun merge
%   G = MERGE(F) returns a chebfun representation of F with the smallest 
%   number of breakpoints possible such that each smooth piece has at
%   most NMAX number of points. NMAX being specified in CHEBFUNPREF. 
%   In SPLITTING OFF mode, NMAX = 2^16 is used.
%  
%   G = MERGE(F, BKPTS) returns an equivalent chebfun representation of F
%   after attempting to eliminate the breakpoints specified in BKPTS. 
%   
%   G = MERGE(F, BKPTS, NMAX) restricts each smooth piece to at most NMAX
%   points as it attempts to eliminate break points.
%
%   In all cases, if elimination of break points is not successful, MERGE 
%   will return F itself.
%   Impulses will prevent merging at corresponding break points.
%
%   See also SPLITTING,  CHEBFUNPREF.
%

%   Chebfun Version 2.0
%

if numel(f) > 1
    error('MERGE does not handle chebfun quasi-matrices')
end

if nargin < 3
    if ~chebfunpref('splitting')
        maxn = chebfunpref('maxn'); % default 2^16+1
    else
        maxn = chebfunpref('nsplit'); % default 129
    end
end
if nargin < 2
    bkpts = 2:f.nfuns;
elseif isempty(bkpts)
    fout =f; 
    return
end

bkpts = unique(bkpts);
if  bkpts(1) < 1 || bkpts(end) > f.nfuns+1 || any(round(bkpts)~=bkpts)
    error('Break points must be integers between 1 and length(ends)')
end
if bkpts(1)==1, bkpts = bkpts(2:end); end
if bkpts(end)==length(f.ends), bkpts = bkpts(1:end-1); end

fout = f;
scl.v = f.scl;
scl.h = norm(f.ends,inf);

for k = bkpts  
    
    xk = f.ends(k);
    j = find(xk == fout.ends,1,'first');
    
    % Prevent merging if there are impulses or chebfun lengths add to more
    % than maxn
    if ~any(f.imps(2:end,k),1) && length(fout.funs(j-1))+length(fout.funs(j)) < 1.05*maxn
        v = feval(f, [xk, xk+eps(xk), xk-eps(xk)]);
        % Prevent merging if there are jumps (very loose tolerance)
        if  norm(v(1) - v(2:3),inf) < 1e-8*f.scl 
            [mergedfun, hpy] = getfun(@(x) feval(fout,x),  ... 
                               [fout.ends(j-1), fout.ends(j+1)], maxn, scl);
            % merging successful                  
            if hpy 
                fout.funs = [fout.funs(1:j-2) mergedfun fout.funs(j+1:end)];
                fout.ends = [fout.ends(1:j-1) fout.ends(j+1:end)];
                fout.imps = [fout.imps(:,1:j-1) fout.imps(:,j+1:end)];
                fout.nfuns = fout.nfuns - 1;
            end
        end
    end
    
end