function varargout = semilogy(varargin)
%SEMILOGY Semi-log scale plot.
%   SEMILOGY(...) is the same as PLOT(...), except a
%   logarithmic (base 10) scale is used for the Y-axis.
%
%   See also PLOT, SEMILOGX, LOGLOG.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

h = plot(varargin{:});
set(gca,'YScale','log');

if nargout > 0
    varargout = {h};
end
    
