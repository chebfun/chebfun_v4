function varargout = plot(varargin)
% PLOT  Linear chebfun plot.
% PLOT(F,G) plot chebfun G versus chebfun F. 
%
% PLOT(F) plots the chebfun F in the interval where it is defined. If F is
% a complex valued chebfun, PLOT(F) is equivalent to PLOT(real(F),imag(F)).
%
% Various line types, plot symbols and colors may be obtained with
% PLOT(F,G,S) where S i a character string made from one element from any
% or all the following 3 columns, similar as in the usual plot command 
% (however, notice that the dashdot type '-.' is not yet supported for
% chebfuns):
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
% The F,G pairs, or F,G,S triples, can be followed by parameter/value pairs
% to specify additional properties of the lines. For example, 
% PLOT(F,G,'LineWidth',2,'Color',[.6 0 0])  will create a plot with a dark 
% red line width of 2 points. Besides the usual parameters that control the
% specifications of lines (see linespec), the parameter JumpLine determines
% the color and type of line for discontinuities of the chebfun. For
% example, PLOT(F,'JumpLine','-r') will plot discontinuities as a solid red
% line. Notice that it is not possible to modify other properties for jump
% lines and that the default is ':k'.
%
% H = PLOT(F, ...) returns a column vector of handles to line objects in 
% the plot. H(:,1) returns the handles for the 'curves' (i.e. 
% the function), H(:,2) returns a handle to the 'marks', (i.e. the values
% at Chebyshev points), and H(:,3) returns a handle to the jump lines.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if nargin == 0, error('Not enough input arguments.'); end

pos = 2;
while pos <= nargin && (~isa(varargin{pos},'char') || (isa(varargin{pos},'char')...
        && ~any(strcmpi(varargin{pos},{'jumpline', 'linewidth','color', ...
        'markeredgecolor', 'markerfacecolor','markersize','linestyle','marker'}))))
    pos = pos+1;
end
data = varargin(1:pos-1);
ax_props = varargin(pos:end);
args_1 = {}; args_2 = {}; args_3 = {};
if length(data)==1 
    f = []; g = data{1}; 
    linespec = '';    
    [args_1,args_2,args_3] =  unwrap_group(args_1, args_2, args_3, f, g, linespec);
    if ~isreal(data{1})
        for i = 1:3:length(args_1)
            args_1{i} = real(args_1{i+1});
            args_1{i+1} = imag(args_1{i+1});
        end
        for i = 1:3:length(args_2)            
            args_2{i} = real(args_2{i+1});
            args_2{i+1} = imag(args_2{i+1});            
        end
    end
    data = [];        
elseif length(data)==2 && isa(data{2},'char')
    f = []; g = data{1}; linespec = data{2};
    [args_1,args_2,args_3] =  unwrap_group(args_1, args_2, args_3, f, g, linespec);
    if ~isreal(data{1})
        for i = 1:3:length(args_1)
            args_1{i} = real(args_1{i+1});
            args_1{i+1} = imag(args_1{i+1});
        end
        for i = 1:3:length(args_2)            
            args_2{i} = real(args_2{i+1});
            args_2{i+1} = imag(args_2{i+1});            
        end    
    end
    data = [];
end

while ~isempty(data)
    if ~isa(data{1},'chebfun'),
        error([class(data{1}) ' argument is an unknown option.'])
    end
    if isa(data{2},'chebfun')
        f = data{1};
        g = data{2};            
        if length(data)>=3 && isa(data{3},'char')
            linespec = data{3};         
            data(1:3) = [];
        else
            linespec = '';
            data(1:2) = [];
        end
    else
        error([class(data{2}) ' argument is an unknown option.'])
    end
    [args_1,args_2,args_3] =  unwrap_group(args_1, args_2, args_3, f, g, linespec);
end

args_1 = [args_1, ax_props, {'marker','none'}];
args_2 = [args_2, ax_props,{'linestyle','none'}];
args_3 = [args_3, ax_props];

h = ishold;

% dummy plot for legends
dummyargs = [];
for k = 1:(length(args_1)-2)/3
    dummyargs = [dummyargs {args_1{3*k-2}(1)} {NaN} {linespec}];
end
hdummy = plot(dummyargs{:}); hold on

h1 = plot(args_1{:},'handlevis','off');
h2 = plot(args_2{:},'handlevis','off');
if isempty(args_3)
    args_3 = {NaN,NaN};
end
h3 = plot(args_3{:},'handlevis','off');
if ~h, hold off; end

if nargout == 1
    varargout{1} = [h1 h2 h3 hdummy];
end

%---------------------------------------------------------------------
function [curves, marks, jumps] = unwrap_group(curves, marks, jumps, f, g, linespec)

% RodP added this here to handle row quasimatrices (Jan 2009):
if g(1).trans
    f = f.'; g = g.'; % Only deal with column quasimatrices from this point
end

single_chebfun = 0;
if isempty(f)
    for i = 1:numel(g)
        gends = g(i).ends;
        vs = num2cell([gends(1:end-1);gends(2:end)],1);        
        f = [f chebfun(vs, gends)];
    end
    single_chebfun = 1;
elseif numel(f) == 1 && numel(g) > 1
    f = repmat(f,1,numel(g));
elseif numel(f) > 1 && numel(g) == 1
    g = repmat(g,1,numel(f));
elseif numel(f) ~= numel(g)
    error('Quasi-matrices must be the same lengths')
end

for i = 1:numel(f)
    [c, m, j] = unwrap_column(f(i),g(i),linespec, single_chebfun);
    curves = [curves, c]; marks = [marks, m]; jumps = [jumps, j];
end
%---------------------------------------------------------------------
function [curve, mark, jump] = unwrap_column(f, g, linespec, single_chebfun)

%if ~single_chebfun
    [f,g] = overlap(f,g);
%end

maxfg=zeros(1,f.nfuns);
for i = 1:f.nfuns
     maxfg(i) = max(length(f.funs(i)),length(g.funs(i))); 
end
nf = sum(maxfg);
totalmax = max(2000,nf);
cf = []; cg = []; mf = []; mg = [];
for i = 1:f.nfuns    
    fi = f.funs(i); gi = g.funs(i);
    % ... beginning with the markers on Chebyshev points...
    fi = prolong(fi,maxfg(i)); gi = prolong(gi,maxfg(i));
    mf = [mf;fi.vals;fi.vals(end)]; mg = [mg;gi.vals;nan];
    %... and then the lines.
    m = round(totalmax*maxfg(i)/nf);
    fi = prolong(fi,m); gi = prolong(gi,m);
    cf = [cf;fi.vals;fi.vals(end)]; cg = [cg;gi.vals;nan];
end
cf(end) = []; cg(end) = [];
mf(end) = []; mg(end) = [];

if single_chebfun
    cf(1) = g(1).ends(1); mf(1) = cf(1);
    cf(end) = g(1).ends(end); mf(end) = cf(end);
end


curve = {cf,cg,linespec}; mark = {mf,mg,linespec}; jump = [];
% if single_chebfun && isreal(curve{2})
if isreal(curve{2})
    jloc = []; jval = [];
    for i = 1:g.nfuns - 1
        jp = g.ends(i+1);
        jloc = [jloc;jp;jp;nan]; 
        jval = [jval; g.funs(i).vals(end);g.funs(i+1).vals(1);nan];
    end
    %curve = [curve,{jloc},{jval},{linespec}];
%     curve = [curve,{jloc},{jval},{':k'}];
    if isempty(jloc)
        jloc = f.ends(1);
        jval = NaN;
    end
    jump = [jump,{jloc},{jval},{':k'}];
else
    jump = [{NaN},{NaN},jump];
end

%---------------------------------------------------------------------

% function plot_column(f,g,linespec,single_chebfun)
% 
% % first, plot the deltas
% default_deltaline = chebfunpref('deltaline');
% if single_chebfun & ~strcmp(default_deltaline,'none') & size(g.imps,1) >= 2
%     positives = find(g.imps(2,:) > 0);
%     negatives = find(g.imps(2,:) < 0);
%     plot_handle = stem(g.ends(positives) ,g.imps(1,positives), ...
%         linespec,'showbaseline','off');
%     set(plot_handle,'linestyle',default_deltaline,'marker','^')
%     plot_handle = stem(g.ends(negatives) ,g.imps(1,negatives), ...
%         linespec,'showbaseline','off');
%     set(plot_handle,'linestyle',default_deltaline,'marker','v')    
% end
% % now, plot the funs...