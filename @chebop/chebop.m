function N = chebop(varargin)
% CHEBOP  Nonlinear operator constructor of the chebfun system.
%
% N = CHEBOP creates an empty instance of the class.
%
% N = CHEBOP(D), where D is a two-vector, defines a chebop that operates on
% functions defined on the interval D = [D(1) D(end)]. D may also be a
% vector of length > 2 containing breakpoint information, or a domain object.
% N = CHEBPOP(D1,D2), where D1 and D2 are scalars, has the same effect as
% when D = [D1 D2].
%
%
% N = CHEBOP(D,F), where F is an anonymous function or a linop, defines a
% chebop which when applied to a function u, maps it to F(u).
%
% N = CHEBOP(D,F,LBC,RBC), defines a chebop with imposed boundary
% conditions. LBC and/or RBC can either be anonymous functions,
% numerical values or one of the following strings:
%
%   'dirichlet' - Imposes homogenous Dirichlet boundary conditions
%   'neumann' - Imposes homogenous Neumann boundary conditions
%
% As examples of other types of boundary conditions that can be imposed on
% the operator, the following are allowed syntaxes:
%
%   N = CHEBOP(D,F,2,@(u) diff(u)-3) - Imposes the BCs that u(a) = 2 and
%   u'(b) = 3 where a and b are the endpoints of the domain D.
%
%   N = CHEBOP(D,F,@(u) exp(u),@(u) diff(u)-sin(u)-2) - Imposes the BCs
%   that exp(u(a)) = 0 and u'(b) - sin(u(b)) = 2 where a and b are the
%   endpoints of the domain D.
%
% Either LBC or RBC can be empty if the operator only has BCs on one side.
%
% N = CHEBOP(D,F,LBC,RBC,GUESS) where GUESS is a chebfun, defines a chebop
% with associated initial guess when nonlinear boundary value problems
% involved with the chebop is solved.
%
% N = CHEBOP(D,F,LBC,RBC,GUESS,DIM) where DIM is an integer, defines a
% chebop which operates on quasimatrices of dimension Inf x Dim.
%
% Chebops can also be created using the syntax
%   [D,X,N] = domain(a,b)
% where a and b are the endpoints of the domain.
%
% The fields of a chebop object can be set later using subsasgn, i.e.
%   N.op = @(u) diff(u,2) + sin(u)
%
% If U is a chebfun, N(U) returns the chebfun that is the result when
% N operates on U. N*U is allowed syntax as well.
%
% See also domain, linop, chebop/mtimes, chebop/mldivide

% See http://www.maths.ox.ac.uk/chebfun for chebfun information.
%
% Copyright 2002-2010 by The Chebfun Team.

persistent default_N
if isnumeric(default_N)
    default_N = Nop_ini;
    default_N = class(default_N,'chebop');
end
N = default_N;

% Return an empty chebop.
if isempty(varargin), return, end

% Domain
if isnumeric(varargin{1})
    dom = varargin{1};
    varargin(1) = [];
    while ~isempty(varargin) && isnumeric(varargin{1})
        dom = [dom varargin{1}];
        varargin(1) = [];
    end
    N.dom = domain(dom);
else
    dom = varargin{1};
    N.dom = dom;
    varargin(1) = [];
end

if isempty(varargin), return, end

% Op
N = set(N,'op',varargin{1});
varargin(1) = [];
if isempty(varargin), return, end

% LBC
N.lbc = createbc(varargin{1});
N.lbcshow = varargin{1};
varargin(1) = [];
if isempty(varargin), return, end

% RBC
N.rbc = createbc(varargin{1});
N.rbcshow = varargin{1};
varargin(1) = [];
if isempty(varargin), return, end

% Guess
if isnumeric(varargin{1})
    N.guess = chebfun(varargin{1},dom);
else
    N.guess = varargin{1};
end
varargin(1) = [];
if isempty(varargin), return, end

% Dim
N.dim = varargin{1};
varargin(1) = [];
if isempty(varargin), return, end

% Error
error('CHEBOP:numinputs','Too many inoputs to chebop constructor.');

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
    N(1).dim = [];
end