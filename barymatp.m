function P = barymatp(Ny,dy,Nx,dx)
% BARYMATP Piecewise Barycentric Interpolation Matrix   
%  BARYMATP(Y,X) as with BARYMAT, but where X and possibly Y are piecewise
%  Chebyshev points, i.e. the result of X = chebpts([N1,N2,...],[e1 e2 ...]);
%  
%  The points Y are assumed to lie within the inteval [X(1) X(end)].
%
%  BARYMATP(NY,DY,NX,DX) is an alternative calling sequence, where NY and
%  NX are vectors for the number of points in subintervals of the domains
%  DY and DX respectively. DY and DX may also be vectors.
%
%  BARYMATP doesn't yet support maps or non-Chebyshev barycentric weights.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: hale $: $Rev: 1166 $:
%  $Date: 2010-08-02 10:03:38 +0100 (Mon, 02 Aug 2010) $:

if isempty(Ny), P = []; return, end

if nargin == 2
    % x and y are given.
    x = dy; y = Ny;
    % Compute Nx, Ny, dx, and dy.
    tol = 2e-14./abs(diff(x([1 end])));
    repx = find(abs(diff(x))<tol);
    dx = unique([x(1) ; x(repx) ; x(end)]);
    Nx = diff([0 ; repx ; length(x)]);
    repy = find(abs(diff(y))<tol);
    dy = unique([y(1) ; y(repy) ; y(end)]);
    Ny = diff([0 ; repy ; length(y)]);
elseif nargin == 4
    % Ny, Nx, dy, and dx are given. Compute x and y.
    x = chebpts(Nx,dx);    y = chebpts(Ny,dy);
end

% if dy(1) ~= dx(1) || dy(end) ~= dx(end)
%     error('CHEBFUN:barymatp:dom','Inconsistent domains.'); 
% end

% The non-piecewise case simply calls barymat.m
if numel(Nx) == 1
    P = barymat(y,x);
    return
end

if isa(dx,'domain'), dx = dx.endsandbreaks; end

% Find the blocksizes
upr = zeros(numel(Nx),1);
lwr = zeros(numel(Nx),1);
for k = 1:numel(Nx)-1
    tmp = find(y>dx(k+1),1);
    if ~isempty(tmp)
       upr(k) = tmp; 
    else
       upr(k) = 2;
    end
    tmp = find(y<=dx(k),1,'last');
    if ~isempty(tmp)
       lwr(k) = tmp; 
    else
       lwr(k) = 1;
    end
end
lwr([1 end]) = [lwr(1)-1 find(y<=dx(end-1),1,'last')];
upr(end) = sum(Ny)+1;
if numel(Nx)==1, lwr(1) = 0; end

% Check to see if there is a common point in each domains.
dx([1 end]) = []; dy([1 end]) = [];
[C ignored IB] = intersect(dx,dy);
if ~isempty(C)  % If there is, shift to take one value from either side.
    lwr(IB+1) = lwr(IB+1) - 1;
    upr(IB) = upr(IB) - 1;
end

% Construct the global matrix
P = zeros(sum(Ny),sum(Nx));     % Initialise P.
cNx = [0 ; cumsum(Nx(:))];           % Used for indexing.
for k = 1:numel(Nx)
    indyk = lwr(k)+1:upr(k)-1;
    indxk = cNx(k)+(1:Nx(k));
    if ~isempty(indyk) && ~isempty(indxk)
        P(indyk,indxk) = barymat(y(indyk),x(indxk));
    end
end
