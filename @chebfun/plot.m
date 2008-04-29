function plot(varargin)
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
%  Chebfun Version 2.0

if nargin == 0, error('Not enough input arguments.'); end

pos = 2;
while pos <= nargin & (~isa(varargin{pos},'char') | (isa(varargin{pos},'char')...
        & ~any(strcmp(lower(varargin{pos}),{'jumpline', 'linewidth', ...
        'markeredgecolor', 'markerfacecolor','markersize','linestyle','marker'}))))
    pos = pos+1;
end
data = varargin(1:pos-1);
ax_props = varargin(pos:end);
args_1 = {}; args_2 = {};
if length(data)==1 
    f = []; g = data{1}; 
    linespec = '';    
    [args_1,args_2] =  unwrap_group(args_1, args_2, f, g, linespec);
    if ~isreal(data{1})
        args_1([1 4:6]) = []; 
        args_2(1) = [];      
    end
    data = [];        
elseif length(data)==2 & isa(data{2},'char')
    f = []; g = data{1}; linespec = data{2};
    [args_1,args_2] =  unwrap_group(args_1, args_2, f, g, linespec);
    if ~isreal(data{1})
        args_1([1 4:6]) = []; 
        args_2(1) = [];        
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
        if length(data)>=3 & isa(data{3},'char')
            linespec = data{3};         
            data(1:3) = [];
        else
            linespec = '';
            data(1:2) = [];
        end
    else
        error([class(data{2}) ' argument is an unknown option.'])
    end
    [args_1,args_2] =  unwrap_group(args_1, args_2, f, g, linespec);
end

h = ishold;
if ~h, cla reset, hold on, end
args_1 = [args_1, ax_props, {'marker','none'}];
args_2 = [args_2, ax_props,{'linestyle','none'}];
plot(args_1{:})
plot(args_2{:})

if ~h, hold off; end

%---------------------------------------------------------------------
function [curves, marks] = unwrap_group(curves, marks, f, g, linespec)

single_chebfun = 0;
if isempty(f)
    x = [];
    for i = 1:numel(g)
        f = [f chebfun(@(x) x, g(i).ends)];
    end
    single_chebfun = 1;
elseif numel(f) == 1 & numel(g) > 1
    f = repmat(f,1,numel(g));
elseif numel(f) > 1 & numel(g) == 1
    g = repmat(g,1,numel(f));
elseif numel(f) ~= numel(g)
    error('Quasi-matrices must be the same lengths')
end

for i = 1:numel(f)
    [c, m] = unwrap_column(f(i),g(i),linespec, single_chebfun);
    curves = [curves, c]; marks = [marks, m];
end
%---------------------------------------------------------------------
function [curve, mark] = unwrap_column(f, g, linespec, single_chebfun)

[f,g] = overlap(f,g);
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
mf(end) = []; mg(end) = [];
cf(end) = []; cg(end) = [];

curve = {cf,cg,linespec}; mark = {mf,mg,linespec};
if single_chebfun
    jloc = []; jval = [];
    for i = 1:g.nfuns - 1
        jp = g.ends(i+1);
        jloc = [jloc;jp;jp;nan]; 
        jval = [jval; g.funs(i).vals(end);g.funs(i+1).vals(1);nan];
    end
    %curve = [curve,{jloc},{jval},{linespec}];
    curve = [curve,{jloc},{jval},{':k'}];
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