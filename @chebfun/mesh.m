function varargout = mesh(u,varargin)
%MESH Waterfall plot for quasimatrices.
%
%  MESH(U) or MESH(U,T) where LENGTH(T) = MIN(SIZE(U))
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

numpts = 51;

trans = u(:,1).trans;
if trans
    u = u.';
end
n = min(size(u,2));
t = 1:n;

if nargin > 1 && isnumeric(varargin{1}) && length(varargin{1}) == size(u,2)
    t = varargin{1}; t = t(:);
    varargin = {varargin{2:end}};
end

if length(t)~=n
    error('chebfun:mesh:szet', ...
        'Length of T should equal the number of quasimatrices in U');
end

if ~isreal(u) || ~all(isreal(t))
    warning('chebfun:mesh:imaginary',...
        'Imaginary parts of complex T and/or U arguments ignored');
    u = real(u); t = real(t);
end

% get the data
data = plotdata([],u,[],numpts);
uu = data{2:end};
xx = repmat(data{1},1,n);
tt = repmat(t,length(xx(:,1)),1);

% mask the NaNs
mm = find(isnan(uu));
uu(mm) = .5*(uu(mm+1)+uu(mm-1));

% plot the mesh
if ~trans
    h = mesh(xx.',tt.',uu.',varargin{:});
else
    h = mesh(xx,tt,uu,varargin{:});
end

if nargout > 0
    varargout{1} = h;
end