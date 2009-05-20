function varargout = decay(u,varargin)
% DECAY    Display chebyshev coefficients
%  DECAY(U) plots the chebyshev coefficients of a chebfun U on a 
%  semilogy scale. If U is a chebfun with more than one piece, only 
%  the coefficients of the first will be displayed.
%
%  DECAY(U,k) plots the coefficients of the kth fun.
%
%  H = DECAY(U) returns a handle H to the figure.
%
%  DECAY(U,C) allows the choice of a linestyle and colour.
%
%  See also chebfun/chebpoly
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: $: $Rev: $:
%  $Date: $:

c = '-b';               % default linestyle/color
k = 1;                  % plot first fun by default

% check inputs
if nargin > 1
    if isa(varargin{1},'double'), k = varargin{1}; end
    if isa(varargin{1},'char'),   c = varargin{1}; end
    if length(varargin) == 2,
        if isa(varargin{2},'double'), k = varargin{2}; end
        if isa(varargin{2},'char'),   c = varargin{2}; end
    end
end

if k > u.nfuns
    error('chebfun/decay: input chebfun has only %d pieces', u.nfuns);
end

uk = chebpoly(u,k);         % coefficients of kth fun
uk = uk(end:-1:1);          % flip
h = semilogy(abs(uk),c);    % plot

if nargout ~=0
    varargout = {h};
end
