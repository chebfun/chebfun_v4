function h = conv(f,g)
% CONV Convolution of chebfuns.
%
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

% Toby Driscoll, 11 February 2008.

if any(f.imps~=0) || any(g.imps~=0)
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
gm.ends = gm.ends - sum(domain(g));

% In each smooth interval, auto-construct the fun.
for k = 1:h.nfuns
  interval = h.ends([k k+1]);
  h.funs{k,1} = fun( @(x) conv_val(x,f,gm,interval) );
end

h.imps = 0*h.ends;  % kludge!

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

