function Nop = nonlinop(varargin)


persistent default_N
if isnumeric(default_N)
    default_N = Nop_ini;
    default_N = class(default_N,'nonlinop');
end
Nop = default_N;

switch nargin
    case 0
        % Empty constructor
    case 1
        Nop.dom = varargin{1};
    case 2
        Nop.dom = varargin{1};
        Nop.op = varargin{2};
    case 3
        Nop.dom = varargin{1};
        Nop.op = varargin{2};
        Nop.lbc = varargin{3};
    case 4        
        Nop.dom = varargin{1};
        Nop.op = varargin{2};
        Nop.lbc = varargin{3};
        Nop.rbc = varargin{4};
    case 5       
        Nop.dom = varargin{1};
        Nop.op = varargin{2};
        Nop.lbc = varargin{3};
        Nop.rbc = varargin{4};
        Nop.guess = varargin{5};
end

% Determine the type of the operator
if nargin > 1
    if isa(varargin{2},'function_handle')
        Nop.optype = 'anon_fun';
    elseif isa(varargin{2},'chebop')
        Nop.optype = 'chebop';        
    else
        error(['nonlinop:nonlinop: Illegal type of operator. Allowed types are ' ...
            'anonymous functions and chebops.']);
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