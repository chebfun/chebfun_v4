function plot(f,varargin)
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
%          c     cyan          +     plus               (none)  no line
%          m     magenta       *     star             
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
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
h = ishold;

if ~isempty(varargin) & isa(varargin{1},'chebfun')
    nfuncs = 2;
    g = varargin{1};
    varargin = varargin(2:end);
else
    nfuncs = 1;
end
% Default user's parameters
jumpline        = ':k';
color           = 'b';
linewidth       = get(0,'DefaultLineLineWidth');
markeredgecolor = get(0,'DefaultLineMarkerEdgeColor');
markerfacecolor = get(0,'DefaultLineMarkerFaceColor');
markersize      = get(0,'DefaultLineMarkerSize');
linestyle       = get(0,'DefaultLineLineStyle');
marker          = get(0,'DefaultLineMarker');

%---------------------------------------------------------------------

while length(varargin) >= 1,
    prop = varargin{1};
    switch lower(prop)
        case 'jumpline'
            jumpline = varargin{2};
            varargin = varargin(3:end);
        case 'linewidth'
            linewidth = varargin{2};
            varargin = varargin(3:end);
        case 'markeredgecolor'
            markeredgecolor = varargin{2};
            varargin = varargin(3:end);
        case 'markerfacecolor'
            markerfacecolor = varargin{2};
            varargin = varargin(3:end);
        case 'markersize'
            markersize = varargin{2};
            varargin = varargin(3:end);
        case 'linestyle'
            linestyle = varargin{2};
            varargin = varargin(3:end);
        case 'marker'
            marker = varargin{2};
            varargin = varargin(3:end);
        case 'color'
            color = varargin{2};
            varargin = varargin(3:end);
        otherwise
            linestyle = prop(regexpi(prop,'[-:]')); % linestyle -. not availabe yet
            marker = prop(regexpi(prop,'[+o*.xsd^v><ph]'));
            color = prop(regexpi(prop,'[rgbcmykw]'));
            varargin = varargin(2:end);

            if isempty(linestyle) & ~isempty(marker)
                linestyle = 'none'; 
            elseif isempty(linestyle) & ~isempty(color)
                linestyle = '-';
            end
            if isempty(color), color = 'b'; end
            if isempty(marker), marker = 'none'; end
            
    end
end

if isempty(markeredgecolor), markeredgecolor = color; end
if isempty(markerfacecolor), markerfacecolor = color; end

linespec = {'linestyle' linestyle 'marker' marker 'color' color ...
     'linewidth' linewidth 'markeredgecolor' markeredgecolor ...
     'markerfacecolor' markerfacecolor 'markersize' markersize}; 
if nfuncs == 1
    % First plot the impulses of degree 1
    if not(isempty(f.imps)) & isreal(chebvals(f))
        positives = find(f.imps(1,:) > 0);
        negatives = find(f.imps(1,:) < 0);
        stem(f.ends(positives) ,f.imps(1,positives), ...
            'linewidth',linewidth,'color',color,'marker','^','showbaseline','off');
        hold on
        stem(f.ends(negatives) ,f.imps(1,negatives), ...
            'linewidth',linewidth,'color',color,'marker','v','showbaseline','off');
    end
    ends = f.ends;
    funs = f.funs;
    nf = length(f);
    nfuns = length(funs);
    for i = 1:nfuns
        a = ends(i); b = ends(i+1);
        x = fun('x',1);
        x = (1-x)*a/2 + (x+1)*b/2;
        m = round(2000*(1+get(funs{i},'n'))/nf);
        plot(x,funs{i},m,linespec); hold on
    end
    if ~strcmp(jumpline,'none') & isreal(chebvals(f))
        for i = 1:nfuns - 1
            jp = ends(i+1);
            plot([jp;jp],[funs{i}(1);funs{i+1}(-1)],jumpline);
        end
    end
else
    % we create in f and g the same intervals and use the plot from fun. 
    [hi,hf,hg,ord] = overlap(f.ends,g.ends);
    nfuns = size(ord,2)-1;
    x = fun('x',1);
    for i = 1:nfuns
        fcheb = f.funs{ord(1,i)}; gcheb = g.funs{ord(2,i)};
        ffuns{i} = fcheb(hf(1,i)*x+hf(2,i));
        gfuns{i} = gcheb(hg(1,i)*x+hg(2,i));
    end
    for i = 1:nfuns
        maxfg(i) = max(get(ffuns{i},'n'),get(gfuns{i},'n')); 
    end
    nf = sum(maxfg);
    for i = 1:nfuns
        m = round(2000*maxfg(i)/nf);
        plot(ffuns{i},gfuns{i},m,linespec); hold on
    end
end

if h, hold on; else hold off; end

    
