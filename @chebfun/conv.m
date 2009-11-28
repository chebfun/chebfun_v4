function Fout = conv(F1,F2)
% CONV   Convolution of chebfuns.
% H = CONV(F,G) produces the convolution of chebfuns F and G:
% 
%                   - 
%                  /
%         H(x) =   |    F(t) G(x-t) dt,
%                  /
%                 -
% 
% defined for x in [a+c,b+d], where domain(F) is [a,b] and domain(G) is
% [c,d]. The integral is taken over all t for which the integrand is
% defined: max(a,x-d) <= t <= min(b,x-c).
%
% The breakpoints of H are all pairwise sums of the breakpoints of F
% and G.
%
% EXAMPLE
%
%   f=chebfun(1/2); g=f;
%   subplot(2,2,1), plot(f)
%   for j=2:4, g=conv(f,g); subplot(2,2,j), plot(g), end
%   figure, for j=1:4, subplot(2,2,j), plot(g), g=diff(g); end
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

% Deal with quasi-matrices
if size(F1) ~= size(F2)
    error('Quasi-matrix dimensions must agree')
end
Fout = F1;
for k = 1:numel(F1)
    Fout(k) = convcol(F1(k),F2(k));
end

end %conv()

% Deal with single column chebfun
% ---------------------------------
function h = convcol(f,g)

% Note: f and g may be defined on different domains!
    
if isempty(f) || isempty(g), h=chebfun; return, end
    
fimps = f.imps(2:end,:);
gimps = g.imps(2:end,:);
if any(fimps(:)~=0) || any(gimps(:)~=0)
  error('chebfun:conv:nodeltas','Impulses not implemented for convolution.')
end

h = chebfun;

% Find all breakpoints in the convolution.
[A,B] = meshgrid(f.ends,g.ends);
ends = unique( A(:) + B(:) ).';

% Coalesce breaks that are close due to roundoff.
ends( diff(ends) < 10*eps*max(abs(ends([1,end]))) ) = [];
ends(isnan(ends)) = [];

a = f.ends(1); b = f.ends(end); c = g.ends(1); d = g.ends(end);
funs = [];

scl.h = max(hscale(f),hscale(g));
scl.v = 2*max(g.scl,f.scl);

% Avoid resampling for speed up!
%res = chebfunpref('resampling');
pref = chebfunpref;
pref.sampletest = false;
pref.resampling = false;
pref.splitting = false;
prof.blowup = false;

% Construct funs
for k =1:length(ends)-1  
    newfun = fun(@(x) integral(x,a,b,c,d,f,g,pref,scl), ends(k:k+1), pref, scl);
    scl.v = max(newfun.scl.v, scl.v); newfun.scl = scl;
    funs = [funs simplify(newfun)];
end

% Construct chebfun
h.scl = scl.v;
h.funs = funs;
h.ends = ends;
h.nfuns = length(ends)-1;

% function values in imps 
imps = 0*h.ends;
for k = 1:h.nfuns
    imps(k) = get(funs(k),'lval');
end
imps(k+1) =  get(funs(k),'rval');
h.imps = imps; 
h = update_vscl(h);
h.trans = f.trans;

end   % conv()


function out = integral(x,a,b,c,d,f,g, pref,scl)

pref.blowup = false; % avoid checking for blowup exponents.
out = 0.*x;
for k = 1:length(x)
    A = max(a,x(k)-d); B = min(b,x(k)-c);
    if A < B      
        ends = union(x(k)-g.ends,f.ends);
        ee = [A ends(A<ends & ends< B)  B];
        for j = 1:length(ee)-1
            u = fun(@(t) feval(f,t).*feval(g,x(k)-t), ee(j:j+1), pref, scl);
            u.scl.v = 1;
            out(k) = out(k) + sum(u);
        end
    end
end
end

