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
% The breakpoints of H are all pairwise differences of the breakpoints of F
% and G.
%
% EXAMPLE
%
%   f=chebfun(1/2); g=f;
%   subplot(2,2,1), plot(f)
%   for j=2:4, g=conv(f,g); subplot(2,2,j), plot(g), end
%   figure, for j=1:4, subplot(2,2,j), plot(g), g=diff(g); end

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

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
    
if isempty(f) || isempty(g), h=chebfun; return, end
    
fimps = f.imps(2:end,:);
gimps = g.imps(2:end,:);
if any(fimps(:)~=0) || any(gimps(:)~=0)
  error('chebfun:conv:nodeltas','Impulses not implemented for convolution.')
end

h = chebfun;

% Find all breakpoints in the convolution.
[A,B] = meshgrid(f.ends,g.ends);
h.ends = unique( A(:) - B(:) ).';

% Coalesce breaks that are close due to roundoff.
h.ends( diff(h.ends) < 10*eps ) = [];
h.nfuns = length(h.ends)-1;

% Define g(-t).
gm = flipud(g); 
[gleft gright] = domain(g);
gm.ends = gm.ends - (gleft + gright);

% In each smooth interval, auto-construct the fun.
for k = 1:h.nfuns
  interval = h.ends([k k+1]);
  h.funs = [h.funs fun( @(x) conv_val(x,f,gm,interval) )];
end

% function values in imps % kludge!
imps = 0*h.ends;
for k = 1:h.nfuns
    imps(k) = h.funs(k).vals(1);
end
imps(k+1) =  h.funs(k).vals(end);
h.imps = imps; 
h = update_vscl(h);
h.trans = f.trans;

end   % conv()


% For each x, integrate f(t)*g(x-t). Note that we may not assume that f and
% g are single funs over the integraion interval.
function I = conv_val(x,f,gm,interval)
x = scale(x,interval(1),interval(2));  % from [-1,1] to f, gm variable
I = NaN(size(x));
for j = 1:numel(x)
  g1 = gm;  g1.ends = g1.ends+x(j);    % translate to g(x-t)
  dom = domain(g1);
  dom = [ max(dom(1),f.ends(1)), min(dom(2),f.ends(end)) ];
  I(j) = sum( restrict(f,dom).*restrict(g1,dom) );
end

end   % conv_val()

