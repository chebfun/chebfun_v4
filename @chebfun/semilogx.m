function varargout = semilogx(varargin)
%SEMILOGX Semi-log scale plot.
%   SEMILOGX(...) is the same as PLOT(...), except a
%   logarithmic (base 10) scale is used for the X-axis.
%
%   See also PLOT, SEMILOGY, LOGLOG.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

h = plot(varargin{:});
set(gca,'XScale','log');

if nargout > 0
    varargout = {h};
end
    