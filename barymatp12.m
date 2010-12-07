function P = barymatp12(Ny,dy,Nx,dx,my,mx)
% BARYMATP12 Piecewise Barycentric Matrix from 2nd- to 1st-kind points.
%  BARYMATP12(NY,DY,NX,DX) returns a sum(NY) by sum(NX) matrix which projects 
%  data from NX(j) Chebyshev points of the 2nd-kind on the intervals [DX(j:j+1)] 
%  to NY(k) Chebyshev poionts of 1st-kind on the intervals [DY(k:k+1)].
%
%  NY and NX should be vectors. DY and DX maybe be vectors or domains.
%
%  BARYMATP12(NY,DY,NX,DX,MY,MX) uses the maps MY and MX on the Chebyshev
%  grids Y and X respectively. MY and MX should be map structures as
%  returned by maps.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: hale $: $Rev: 1166 $:
%  $Date: 2010-08-02 10:03:38 +0100 (Mon, 02 Aug 2010) $:

if isa(dx,'domain'), dx = dx.endsandbreaks; end
if isa(dy,'domain'), dy = dy.endsandbreaks; end

if dy(1) ~= dx(1) || dy(end) ~= dx(end)
    error('CHEBFUN:barymatp:dom','Inconsistent domains.'); 
end


if nargin == 4 || (isempty(my) && isempty(my))
    % Ny, Nx, dy, and dx are given. Compute x and y.
    x = chebpts(Nx,dx,2);    
    y = chebpts(Ny,dy,1);
else
    % Maps are given, so we have to do some more work..
    x = [];
    numintsx = numel(dx)-1;
    if numel(mx) < numintsx,  mx = repmat(mx,numintsx); end
    if numel(Nx) < numintsx,  Nx = repmat(Nx,numintsx); end
    y = [];
    numintsy = numel(dy)-1;
    if numel(my) < numintsy,  my = repmat(my,numintsy); end
    if numel(Ny) < numintsy,  Ny = repmat(Ny,numintsy); end
    
    for j = 1:numintsx
        mxj = mx{j};
        x = [x ; mxj.for(chebpts(Nx(j),[-1 1],2))];
    end
    for k = 1:numintsy
        myk = my{k};
        y = [y ; myk.for(chebpts(Ny(k),[-1 1],1))];
    end
end

% The non-piecewise case simply calls barymat.m
if numel(Nx) == 1
    P = barymat(y,x);
    return
end

% Find the block sizes
upr = zeros(numel(Nx),1);
lwr = zeros(numel(Nx),1);
for k = 1:numel(Nx)-1
    upr(k) = find(y>dx(k+1),1);
    tmp = find(y<=dx(k),1,'last');
    if ~isempty(tmp)
       lwr(k) = tmp; 
    else
       lwr(k) = 1;
    end
%     lwr(k) = find(y<=dx(k),1,'last');
end
lwr([1 end]) = [lwr(1)-1 find(y<=dx(end-1),1,'last')];
upr(end) = sum(Ny)+1;
if numel(Nx)==1, lwr(1) = 0; end

% Construct the global matrix
P = zeros(sum(Ny),sum(Nx));          % Initialise P.
cNx = [0 ; cumsum(Nx(:))];           % Used for indexing.
for k = 1:numel(Nx)
    indyk = lwr(k)+1:upr(k)-1;
    indxk = cNx(k)+(1:Nx(k));
    P(indyk,indxk) = barymat(y(indyk),x(indxk));
end