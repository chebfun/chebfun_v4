function varargout = plot(varargin)
% PLOT  Linear chebfun plot.
% PLOT(F,G) plot chebfun G versus chebfun F. Quasimatrices are also
% supported in the natural way.
%
% PLOT(F) plots the chebfun F in the interval where it is defined. If F is
% a complex valued chebfun, PLOT(F) is equivalent to PLOT(real(F),imag(F)).
%
% Various line types, plot symbols and colors may be obtained with
% PLOT(F,G,S) where S i a character string made from one element from any
% or all the following 3 columns, similar as in the usual plot command
%
%          b     blue          .     point              -     solid
%          g     green         o     circle             :     dotted
%          r     red           x     x-mark             --    dashed
%          c     cyan          +     plus               -.    dashdot
%          m     magenta       *     star             (none)  no line
%          y     yellow        s     square
%          k     black         d     diamond
%                              v     triangle (down)
%                              ^     triangle (up)
%                              <     triangle (left)
%                              >     triangle (right)
%                              p     pentagram
%                              h     hexagram
%
% Markers show the chebfun value at Chebyshev points. For example,
% PLOT(F,G,'c+:') plots a cyan dotted line with a plus at each Chebyshev
% point; PLOT(F,G,'bd') plots blue diamond at each Chebyshev point but
% does not draw any line.
%
% The F,G pairs (or F,G,S triples) can be followed by parameter/value pairs
% to specify additional properties of the lines. For example,
% PLOT(F1,G1,'-',F2,G2,'--','LineWidth',2,'Color',[.6 0 0]) will plot dark
% red lines of width 2 points. 
%
% Besides the usual parameters that control the specifications of lines 
% (see linespec), the parameters JumpLine and JumpMarker determine the type 
% of line and style of markers respectively for discontinuities of the 
% chebfun. For example, PLOT(F,'JumpLine','-r')  will plot discontinuities 
% as a solid red line, and PLOT(F,'-or','JumpMarker,'.k') will plot the jump 
% values with black dots. Notice that it is not possible to modify other 
% properties for jump lines or markers, that the defaults are ':' and 'x' 
% respectively with colours  chosen to match the lines they correspond to, 
% and that the jump values are  only plotted when the Chebyshev points are 
% also plotted, unless an input 'JumpLine','S' is passed.
%
% PLOT(F,'interval',[A B]) restricts the plot to the interval [A,B] which 
% can be useful when the domain of F is infinite, or for 'zooming in' 
% on, say, oscillatory chebfuns. PLOT(F,'numpts',N) will plot the 
% chebfun F at N equally spaced points, rather than the default 2001.
% If plotting quasimatrices or more that one F,G pair these properties
% (as with JumpLine and JumpMarker) are applied globally.
%
% H = PLOT(F, ...) returns a column vector of handles to line objects in
% the plot. H(:,1) contains the handles for the 'curves' (i.e. the function),
% H(:,2) contains handles for the 'marks', (i.e. the values at Chebyshev 
% points), H(:,3) for the jump lines, H(:,4) for the jump vals, and H(:,5) 
% contains the handle for a dummy plot used to supply correct legends.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team.
%  Last commit: $Author: nich $: $Rev: 458 $:
%  $Date: 2009-05-10 20:51:03 +0100 (Sun, 10 May 2009) $:

numpts = chebfunpref('plot_numpts');

% get jumpline style and jumpval markers
jlinestyle = ':'; jmarker = 'x'; forcejmarks = false; 
infy = false; interval = [];
for k = length(varargin)-1:-1:1
    if isa(varargin,'chebfun'), break, end
    if ischar(varargin{k})
        if strcmpi(varargin{k},'JumpLine');            
            jlinestyle = varargin{k+1};
            varargin(k:k+1) = [];
        elseif strcmpi(varargin{k},'JumpMarker');      
            jmarker = varargin{k+1}; 
            forcejmarks = true;
            varargin(k:k+1) = [];
        elseif strcmpi(varargin{k},'NumPts');      
            numpts = varargin{k+1}; 
            varargin(k:k+1) = [];
        elseif strcmpi(varargin{k},'Interval');      
            interval = varargin{k+1}; 
            varargin(k:k+1) = [];            
        end
    end
end

linedata = {}; markdata = {}; jumpdata = {}; dummydata = {}; jvaldata = {};
bot = inf; top = -inf;
while ~isempty(varargin)
    % grab the chebfuns
    if length(varargin)>1 && isa(varargin{2},'chebfun') % two chebfuns
        f = varargin{1};
        g = varargin{2};
        varargin(1:2) = [];
        if ~isreal(f) || ~isreal(g)
            warning('chebfun:plot:doubleimag',...
                'Imaginary parts of complex X and/or Y arguments ignored.');
            f = real(f); g = real(g);
        end
    else                                                % one chebfun
        f = [];
        g = varargin{1};
        varargin(1) = [];
    end
    
    % other data
    pos = 0;
    while pos<length(varargin) && ~isa(varargin{pos+1},'chebfun')
        pos = pos+1;
    end
    if pos > 0
        s = {varargin{1:pos}};
    else
        s = [];
    end
    varargin(1:pos) = [];
    
    % get plot data
    [lines marks jumps jumpval misc] = plotdata(f,g,[],numpts,interval);
    
    % limits for inf plots
    if ~isempty(misc) 
        infy = max(infy,misc(1));
        bot = min(bot,misc(2)); 
        top = max(top,misc(3));
    end
    
    % jump stuff
    if ~isempty(jumps) && ~isempty(jumps{1})
        tmp = jumps;           jumps = {};
        for k = 1:2:length(tmp)-1
            jumps = [jumps, {tmp{k},tmp{k+1}},jlinestyle];
        end
    elseif ~isempty(lines)
            jumps = {NaN(1,size(lines{1},2)),NaN(1,size(lines{2},2))};
    end
    if ~isempty(jumpval)
        tmp = jumpval;         jumpval = {};
        for k = 1:2:length(tmp)-1
            jumpval = [jumpval, {tmp{k},tmp{k+1}},jmarker];
        end
    elseif ~isempty(lines)
        jumpval = {NaN(1,size(lines{1},2)),NaN(1,size(lines{2},2))};
    end

    markdata = [markdata, marks];
    if ~isempty(lines)
        linedata = [linedata, lines, s];
    end
    jumpdata = [jumpdata, jumps];
    jvaldata = [jvaldata, jumpval];
    if ~isempty(lines)
        dummydata = [dummydata, lines{1}(1), NaN*ones(size(lines{2},2),1), s];
    end        
end
if isempty(markdata), 
    markdata = {[]};
else
    markdata = [markdata, s];
end
if isempty(dummydata), dummydata = {[]}; end
if isempty(linedata), linedata = {[]}; end
if isempty(jumpdata), jumpdata = {[]}; end
if isempty(jvaldata), jvaldata = {[]}; end

h = ishold;

% getting current axes
if all(~isinf([bot top])) && infy
    try
        yl = get(gca,'ylim');
        bot = min(yl(1),bot);
        top = max(yl(2),top);
    end
end

% dummy plot for legends
hdummy = plot(dummydata{:}); hold on

h1 = plot(linedata{:},'handlevis','off');
h2 = plot(markdata{:},'linestyle','none','handlevis','off');
h3 = plot(jumpdata{:},'handlevis','off');
h4 = plot(jvaldata{:},'linestyle','none','handlevis','off');

defjlcol = true;
for k = 1:length(jlinestyle)
    if ~isempty(strmatch(jlinestyle(k),'bgrcmykw'.'))
        defjlcol = false; break
    end
end
defjmcol = true;
for k = 1:length(jmarker)
    if ~isempty(strmatch(jmarker(k),'bgrcmykw'.'))
        defjmcol = false; break
    end
end
    
for k = 1:length(h1)
    h1color = get(h1(k),'color');
    h1marker = get(h1(k),'marker');
    set(h2(k),'color',h1color);
    set(h2(k),'marker',h1marker);
    if defjlcol 
        set(h3(k),'color',h1color);
    end
    if defjmcol 
        set(h4(k),'color',h1color);
    end
    if strcmp(h1marker,'none') && ~forcejmarks
        set(h4(k),'marker','none');
    end
    set(h1(k),'marker','none');
end

if all(~isinf([bot top])) && infy
    try
        xl = get(gca,'xlim');
        axis([xl(1) xl(2) bot top]);
    end
end

if ~h, hold off; end

if nargout == 1
    varargout = {[h1 h2 h3 h4 hdummy]};
end





