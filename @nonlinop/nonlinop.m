function cbvp = nonlinop(varargin)

cbvp = struct([]);
if nargin == 0
    % Should we allow empty constructor?
    cbvp(1).dom =[];
    cbvp(1).op = [];
    cbvp(1).lbc = [];
    cbvp(1).rbc = [];
    cbvp(1).guess = [];
elseif nargin == 1
    cbvp(1).dom = varargin{1};
    cbvp(1).op = [];
    cbvp(1).lbc = [];
    cbvp(1).rbc = [];
    cbvp(1).guess = [];
elseif nargin == 2
    cbvp(1).dom = varargin{1};
    cbvp(1).op = varargin{2};
    cbvp(1).lbc = [];
    cbvp(1).rbc = [];
    cbvp(1).guess = [];
elseif nargin == 3
    cbvp(1).dom = varargin{1};
    cbvp(1).op = varargin{2};
    cbvp(1).lbc = varargin{3};
    cbvp(1).rbc = [];
    cbvp(1).guess = [];
elseif nargin == 4
    cbvp(1).dom = varargin{1};
    cbvp(1).op = varargin{2};
    cbvp(1).lbc = varargin{3};
    cbvp(1).rbc = varargin{4};
    cbvp(1).guess = [];
elseif nargin == 5
    cbvp(1).dom = varargin{1};
    cbvp(1).op = varargin{2};
    cbvp(1).lbc = varargin{3};
    cbvp(1).rbc = varargin{4};
    cbvp(1).guess = varargin{5};
end

cbvp = class(cbvp,'nonlinop');
end