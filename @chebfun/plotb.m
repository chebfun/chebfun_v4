function varargout = plotb(varargin)

numpts = 2000;

linedata = []; markdata = []; jumpdata = [];
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
    linedata = [linedata, lines, s];
    markdata = [markdata, marks, s];
    jumpdata = [jumpdata, jumps, s];
end

h1 = plot(linedata{:});
% h2 = plot(markdata{:});
% h3 = plot(jumpdata{:});

if nargout == 1
    varargout = {[h1 h2 h3]};
end





    
        