function varargout = loglog(varargin)
%LOGLOG Log-log scale plot.
%   LOGLOG(...) is the same as PLOT(...), except logarithmic
%   scales are used for both the X- and Y- axes.
%
%   See also PLOT, SEMILOGX, SEMILOGY.
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

h = plot(varargin{:});
set(gca,'XScale','log','YScale','log');

if nargout > 0
    varargout = {h};
end
    