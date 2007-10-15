function plot3(f,g,h,varargin)
% PLOT3  Plot lines and points in 3-D space.
% PLOT3() is a three-dimensional analogue of PLOT().
%    
% PLOT3(F,G,H), where F, G and H are three chebfuns, plots a line in 
% 3D-space. PLOT3(F,G,H,S) specifies the color, type and markers of the
% line. The F,G pairs, or F,G,S triples, can be followed by parameter/value
% pairs to specify additional properties of the lines, similar as in PLOT.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0

hd = ishold;
% Default user's parameters
color           = 'b';
linewidth       = get(0,'DefaultLineLineWidth');
markeredgecolor = get(0,'DefaultLineMarkerEdgeColor');
markerfacecolor = get(0,'DefaultLineMarkerFaceColor');
markersize      = get(0,'DefaultLineMarkerSize');
linestyle       = get(0,'DefaultLineLineStyle');
marker          = get(0,'DefaultLineMarker');

while length(varargin) >= 1,
    prop = varargin{1};
    switch lower(prop)
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


% we create in f, g and h the same intervals--------------
[pends,pf,pg,ord] = overlap(f.ends,g.ends);
nfuns = size(ord,2)-1;
x = fun('x',1);
for i = 1:nfuns
    fcheb = f.funs{ord(1,i)}; gcheb = g.funs{ord(2,i)};
    pfuns{i} = fcheb(pf(1,i)*x+pf(2,i));
    qfuns{i} = gcheb(pg(1,i)*x+pg(2,i));

end
[rends,rf,rh,ord] = overlap(pends,h.ends);
nfuns = size(ord,2)-1;
for i = 1:nfuns
    pcheb = pfuns{ord(1,i)}; qcheb = qfuns{ord(1,i)};
    hcheb = h.funs{ord(2,i)};
    ffuns{i} = pcheb(rf(1,i)*x+rf(2,i));
    gfuns{i} = qcheb(rf(1,i)*x+rf(2,i));
    hfuns{i} = hcheb(rh(1,i)*x+rh(2,i));
end
% ---------------------------------------------------------
for i = 1:nfuns
    maxfgh(i) = max([get(ffuns{i},'n'),get(gfuns{i},'n'),get(hfuns{i},'n')]); 
end
nf = sum(maxfgh);
for i = 1:nfuns
    m = round(2000*maxfgh(i)/nf);
    fcheb = prolong(ffuns{i},m);
    gcheb = prolong(gfuns{i},m);
    hcheb = prolong(hfuns{i},m);
    marker = linespec{4}; linespec{4} = 'none';
    plot3(get(fcheb,'val'),get(gcheb,'val'),get(hcheb,'val'),linespec{1:end});  
    hold on
    linespec{4} = marker;
    if ~strcmp(marker,'none')
        fvcheb = prolong(ffuns{i},maxfgh(i));
        gvcheb = prolong(gfuns{i},maxfgh(i));
        hvcheb = prolong(hfuns{i},maxfgh(i));
        linespec{2} = 'none'; % set linestyle to 'none'
        plot3(get(fvcheb,'val'),get(gvcheb,'val'),get(hvcheb,'val'),linespec{1:end});
    end
end
    
if hd, hold on; else hold off; end