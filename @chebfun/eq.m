function fout = eq(F1,F2)
% ==   Equal.
%  F1 == F2 returns a chebfun which is zero almost everywhere except at the
%  intersection points of F1 and F2. 
%

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

% Make sure F1 is a chebfun
if ~isa(F1,'chebfun')
    Ftemp = F1;
    F1 = F2;
    F2 = Ftemp;
end

if isa(F2,'double')
    % if F2 is a scalar repeat to match number of columns in F1
    F2 = repmat(F2,1,numel(F1));
elseif size(F1) ~= size(F2) 
    % two quasimatrices must have the same size
    error('CHEBFUN:eq:wrongsize','Quasimatrix dimensions must agree')
end

fout = chebfun;
for k = 1:min(size(F1)) % Do it for each column of F1.
      fout = [fout  eqcol(F1(k), F2(k))];
end

function fout = eqcol(f1,f2)
% Eq for two single chebfuns or one chebfun and one scalar
% Note: f1 must be a chebfun, f2 may be a scalar

r = roots(f1-f2); % Find points where f1 == f2
ends = f1.ends;
fout = chebfun;
newends = union(r,ends);
fout.scl = 1;
fout.ends = newends;
fout.imps = 1+newends*0;
fout.nfuns = length(fout.ends)-1;
fout.trans = f1.trans;
funs =[];
for k = 1:fout.nfuns
    funs = [funs fun(0)];
end
fout.funs = funs;

% Check whehter endpoints are also roots:
if r(1) ~= ends(1)
    fout.imps(1) = 0;
end
if r(end) ~= ends(end)
    fout.imps(end) = 0;
end
