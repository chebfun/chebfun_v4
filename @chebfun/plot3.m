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

numpts = 1001;

linedata = {}; markdata = {}; jumpdata = {}; dummydata = {};
while ~isempty(varargin)
    % grab the chebfuns
    if length(varargin)>2 && isa(varargin{3},'chebfun') % three chebfuns
        f = varargin{1};
        g = varargin{2};
        h = varargin{3};
        if length(varargin) > 3
            varargin = {varargin{4:end}};
        else
            varargin = [];
        end
        if ~isreal(f) || ~isreal(g) ||  ~isreal(h) 
            warning('chebfun:plot:doubleimag',...
                'Imaginary parts of complex X and/or Y arguments ignored.');
            f = real(f); g = real(g); h = real(h);
        end    
    else                                                % one chebfun
        error('chebfun:plot3:argin','First three arguments must be chebfuns')
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
    if pos == length(varargin)
        varargin = [];
    else
        varargin = {varargin{(pos+1):end}};
    end
    
    % get plot data
    [lines marks jumps] = plotdata(f,g,h,numpts);
    
    % jumpline?
    jlinestyle = ':k';    
    for k = 1:length(s)-1
        if ischar(s{k}) && strcmpi(s{k},'JumpLine');
            jlinestyle = s{k+1};
            tmp = s;
            if length(s) > k, s = {tmp{(k+2):end}}; end
            if k > 1, s = {tmp{1:(k-1)}, s{:}}; end
        end
    end
    % insert jumpline style into jumps
    if ~isempty(jumps)
        tmp = jumps;
        jumps = {};
        for k = 1:3:length(tmp)-1
            jumps = [jumps, {tmp{k},tmp{k+1},tmp{k+2}},jlinestyle];
        end
    else
        jumps = [jumps,{NaN,NaN}];
    end

    markdata = [markdata, marks];
    linedata = [linedata, lines, s];
    jumpdata = [jumpdata, jumps];
    dummydata = [dummydata, lines{1}(1)*ones(size(lines{2},2),1), NaN*ones(size(lines{2},2),1), NaN*ones(size(lines{3},2),1), s];
end

h = ishold;

% dummy plot for legends
hdummy = plot3(dummydata{:}); hold on

h1 = plot3(linedata{:},'handlevis','off');
h2 = plot3(markdata{:},'linestyle','none','handlevis','off');
for k = 1:length(h1)
    set(h2(k),'color',get(h1(k),'color'));
    set(h2(k),'marker',get(h1(k),'marker'));
    set(h1(k),'marker','none');
end
h3 = plot3(jumpdata{:},'handlevis','off');

if ~h, hold off; end

if nargout == 1
    varargout = {[h1 h2 h3 hdummy]};
end