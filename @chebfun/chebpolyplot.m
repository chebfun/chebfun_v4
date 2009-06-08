function varargout = chebpolyplot(u,varargin)
% CHEBPOLYPLOT    Display chebyshev coefficients graphically.
%   CHEBPOLYPLOT(U) plots the chebyshev coefficients of a chebfun U 
%   on a semilogy scale. If U is a chebfun with more than one piece, 
%   only the coefficients of the first will be displayed. If U is a
%   row (or column) quasimatrix, only the fist row (column) will be used.
%
%   CHEBPOLYPLOT(U,K) plots the coefficients of the Kth fun.
%
%   H = CHEBPOLYPLOT(U) returns a handle H to the figure.
%
%   CHEBPOLYPLOT(U,S) and CHEBPOLYPLOT(U,K,S) allow further plotting 
%   options, such as linestyle, linecolor, etc. 
%
%   See also chebfun/chebpoly, plot
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team. 
%   Last commit: $Author$: $Rev$:
%   $Date$:

s = {};                     % default linestyle/color
k = 1;                      % plot first fun by default

% check inputs
if nargin > 1
    if isa(varargin{1},'double'), 
        k = varargin{1};
        if nargin > 2, s = {varargin{2:end}}; end
    end
    if isa(varargin{1},'char'),  s = varargin; end
end
if numel(k) > 1
    error('chebfun:chebpolyplot:onefuns', 'can only plot one fun at a time');
end
if numel(u) > 1
%     error('chebfun:chebpolyplot:quasimatrix', 'no support for quasimatrices')
    if u(1).trans, u = u(1,:);
    else           u = u(:,1);
    end
end
if k > u.nfuns
    error('chebfun:chebpolyplot:outofbounds: input chebfun has only %d pieces', u.nfuns);
end


try
    uk = chebpoly(u,k);         % coefficients of kth fun
    uk = uk(end:-1:1);          % flip
    h = semilogy(abs(uk),s{:}); % plot
catch
    k = s{end};
    uk = chebpoly(u,k);         % coefficients of kth fun
    uk = uk(end:-1:1);          % flip
    h = semilogy(abs(uk),s{1:(end-1)}); % plot
end

% output handle
if nargout ~=0
    varargout = {h};
end
