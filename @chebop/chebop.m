function N = chebop(varargin)


persistent default_N
if isnumeric(default_N)
    default_N = Nop_ini;
    default_N = class(default_N,'chebop');
end
N = default_N;

switch nargin
    case 0
        % Empty constructor
    case 1
        N.dom = varargin{1};
    case 2
        N.dom = varargin{1};
        N.op = varargin{2};
    case 3
        N.dom = varargin{1};
        N.op = varargin{2};
        N.lbc = createbc(varargin{3});
    case 4        
        N.dom = varargin{1};
        N.op = varargin{2};
        N.lbc = createbc(varargin{3});
        N.rbc = createbc(varargin{4});
    case 5       
        N.dom = varargin{1};
        N.op = varargin{2};
        N.lbc = createbc(varargin{3});
        N.rbc = createbc(varargin{4});
        
        % Convert constant initial guesses to chebfuns
        if isnumeric(varargin{5})
            N.guess = chebfun(varargin{5},dom);
        else
            N.guess = varargin{5};
        end
end

% Determine the type of the operator
if nargin > 1
    if isa(varargin{2},'function_handle')
        N.optype = 'anon_fun';
    elseif isa(varargin{2},'linop')
        N.optype = 'linop';
    elseif isempty(varargin{2})
        % Do nothing
    else
        error('chebop:chebop','Operator must be function handle or linop.');
    end
end

end

function N = Nop_ini()
N = struct([]);
N(1).dom =[];
N(1).op = [];
N(1).lbc = [];
N(1).rbc = [];
N(1).guess = [];
N(1).optype = [];
end