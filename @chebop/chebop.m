function N = chebop(varargin)


persistent default_N
if isnumeric(default_N)
    default_N = Nop_ini;
    default_N = class(default_N,'chebop');
end
N = default_N;

if nargin > 0
  N.dom = varargin{1};
  if nargin > 1
    N = set(N,'op',varargin{2});
    if nargin > 2
      N.lbc = createbc(varargin{3});
      N.lbcshow = varargin{3};
      if nargin > 3
        N.rbc = createbc(varargin{4});
        N.rbcshow = varargin{4};
        if nargin > 4
          % Convert numerical initial guesses to chebfuns
          if isnumeric(varargin{5})
            N.guess = chebfun(varargin{5},dom);
          else
            N.guess = varargin{5};
          end
        end
      end
    end
  end
end

end

function N = Nop_ini()
N = struct([]);
N(1).dom =[];
N(1).op = [];
N(1).opshow = [];
N(1).lbc = [];
N(1).lbcshow = [];
N(1).rbc = [];
N(1).rbcshow = [];
N(1).guess = [];
N(1).optype = [];
end