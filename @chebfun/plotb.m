function varargout = plotb(varargin)
% Currently working for calls of the form
%   plot(F2,S1,F2,S2,...)
% where F may be a real or complex chebfun or quasimatrix
% and *some* support (in particular, no marks) for 
%   plot(F,G,S1,...).

numpts = 2000;

linedata = {}; markdata = {}; jumpdata = {}; dummydata = {};
while ~isempty(varargin)
    % grab the chebfuns
    if length(varargin)>1 && isa(varargin{2},'chebfun') % two chebfuns
        f = varargin{1};
        g = varargin{2};
        if length(varargin) > 2
            varargin = {varargin{3:end}};
        else
            varargin = [];
        end
        if ~isreal(f) || ~isreal(g)
            warning('chebfun:plot:doubleimag',...
                'Imaginary parts of complex X and/or Y arguments ignored.');
            f = real(f); g = real(g);
        end    
    else                                                % one chebfun
        f = [];
        g = varargin{1};
        if length(varargin) > 1
            varargin = {varargin{2:end}};
        else
            varargin = [];
        end
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
    [lines marks jumps] = plotdata(f,g,[],numpts);
    
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
        for k = 1:2:length(tmp)-1
            jumps = [jumps, {tmp{k},tmp{k+1}},jlinestyle];
        end
    else
        jumps = [jumps,{NaN,NaN}];
    end
    
    lines
    
    markdata = [markdata, marks];
    linedata = [linedata, lines, s];
    jumpdata = [jumpdata, jumps];
    dummydata = [dummydata, lines{1}(1), NaN*ones(size(lines{2},2),1), s];
end

h = ishold;
hold on

% dummy plot for legends
hdummy = plot(dummydata{:});

h1 = plot(linedata{:},'handlevis','off')
h2 = plot(markdata{:},'linestyle','none','handlevis','off')
for k = 1:length(h1)
    set(h2(k),'color',get(h1(k),'color'));
    set(h2(k),'marker',get(h1(k),'marker'));
    set(h1(k),'marker','none');
end
h3 = plot(jumpdata{:},'handlevis','off');

if ~h, hold off; end

if nargout == 1
    varargout = {[h1 h2 h3]};
end





    
        