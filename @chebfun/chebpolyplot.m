function varargout = chebpolyplot(u,varargin)
% CHEBPOLYPLOT    Display chebyshev coefficients graphically.
%   CHEBPOLYPLOT(U) plots the chebyshev coefficients of a chebfun U 
%   on a semilogy scale. If U is a chebfun with more than one piece, 
%   only the coefficients of the first will be displayed. If U is a
%   row (or column) quasimatrix, only the fist row (column) will be used.
%
%   CHEBPOLYPLOT(U,K) plots the coefficients of the funs indexed by the vector K.
%
%   CHEBPOLYPLOT(U,0) plots the coefficients of all the funs in U.
%
%   H = CHEBPOLYPLOT(U) returns a handle H to the figure.
%
%   CHEBPOLYPLOT(U,S) and CHEBPOLYPLOT(U,K,S) allow further plotting 
%   options, such as linestyle, linecolor, etc. If K is a vector, then
%   use CHEBPOLYPLOT(U,K,'MARKER','.','LINESTYLE','none'), etc to alter
%   plot styles for all of the funs given by K. If S contains a string 
%   'LOGLOG', the coefficients will be displayed on a log-log scale.
%
%   Example
%     u = chebfun({@sin @cos @tan @cot},[-2,-1,0,1,2]);
%     chebpolyplot(u,0,'marker','.','linestyle','none');
%
%   See also chebfun/chebpoly, plot
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team. 
%   Last commit: $Author$: $Rev$:
%   $Date$:

s = {};                     % default linestyle/color
k = 1;                      % plot first fun by default
ll = false;                 % default to semilogy plot

% check inputs
if nargin > 1
    if isa(varargin{1},'double'), 
        k = varargin{1};
        varargin(1) = [];
    end
    for j = 1:length(varargin)
        if strcmpi(varargin{j},'loglog')
            ll = true; 
            varargin(j) = [];
            break
        end
    end
end

if k == 0, k = 1:u.nfuns; end

if numel(u) > 1
    if u(1).trans, u = u(1,:);
    else           u = u(:,1);
    end
end
if any(k > u.nfuns)
    error('chebfun:chebpolyplot:outofbounds', 'input chebfun has only %d pieces', u.nfuns);
end

UK = {};
for j = k
    uk = chebpoly(u,j);             % coefficients of kth fun
    uk = abs(uk(end:-1:1));         % flip
    uk(~uk) = eps*max(uk);          % remove zeros for LNT
    UK = [UK, {1:length(uk), uk}, varargin]; % store
end
if ~ll
    h = semilogy(UK{:});            % semilogy plot
else
    h = loglog(UK{:});              % loglog plot
end
    
if j > 1
    legend(int2str(k.'))
end

% output handle
if nargout ~=0
    varargout = {h};
end
