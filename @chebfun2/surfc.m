function varargout = surfc(f,varargin)
%SURFC  Combination surf/contour plot for a chebfun2.
% 
% SURFC(...) is the same as SURF(...) except that a contour plot
% is drawn beneath the surface.
% 
% See SURFC, SURFL.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if ( isempty(f) ) % check for empty chebfun2.
    h=surf([]);  % call the empty surf command. 
    if nargout == 1
        varargout = {h}; 
    end
    return
end 

ish = ishold;
pref2=chebfun2pref;
numpts = pref2.plot_numpts; [xx,yy]=chebpts2(numpts,numpts,f.corners);
vals = f.feval(xx,yy);
defaultopts = {'facecolor','interp','edgealpha',.5,'edgecolor','none'};

if ( isempty(varargin) )
    h = surfc(xx,yy,vals,vals,defaultopts{:});
else
    h = surfc(xx,yy,vals,defaultopts{:},varargin{:});
end
    

if ( ~ish ), hold off; end 
if ( nargout >1 )
    varargout = {h}; 
end

end