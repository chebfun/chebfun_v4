function varargout = plot3(varargin)
% PLOT3 Plot a chebfun in 3-D space
%    PLOT3(x,y,z), where x,y,z are three chebfuns, plots a curve in 3-space
%    where z=f(x,y).
%
%   PLOT3(X,Y,Z), where X, Y and Z are three chebfun quasimatrices, plots
%   several curves obtained from the columns (or rows) of X, Y, and Z. 
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

k = 1;

dummyarg= varargin;
while k < nargin
    if isa(varargin{k}, 'chebfun')
        % Replace chebfun with vectors (evaluation at 1000 points)
        [lines, marks, jumps] = plotdata(varargin{k:k+2},1000);
        varargin{k} = lines{1};
        varargin{k+1} = lines{2};
        varargin{k+2} = lines{3};
        dummyarg{k} = lines{1}(1);
        dummyarg{k+1} = NaN;
        dummyarg{k+2} = NaN;
        k = k+3;
    else
        k = k+1;
    end
end

h = ishold;

% dummy plot for legends
hdummy = plot3(dummyarg{:}); hold on

% plot lines
h1 = plot3(varargin{:},'handlevis','off'); 

% plot markers
h2 = plot3(marks{:},'linestyle','none','handlevis','off');

% Set markers in h2 and remove them from h1
for k = 1:length(h1)
    set(h2(k),'color',get(h1(k),'color'));
    set(h2(k),'marker',get(h1(k),'marker'));
    set(h1(k),'marker','none');
end
h3 = plot3(jumps{:},'k:','handlevis','off');

if ~h, hold off; end

if nargout == 1
    varargout = {[h1 h2 h3 hdummy]};
end    