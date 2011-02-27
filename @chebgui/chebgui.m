function varargout = chebgui(varargin)
% INTRODUCTION TO CHEBGUI
% 
% Chebgui is a graphical user interface to Chebfun's capabilities for
% solving ODEs and PDEs (ordinary and partial differential equations) and
% eigenvalue problems. More precisely, it deals with the following classes
% of problems.  In all cases both single equations and systems of equations
% can be treated, as well as integral and integro-differential equations.
% 
% ODE BVP (boundary-value problem): an ODE or system of ODEs on an interval
% [a,b] with boundary conditions at both boundaries.
% 
% ODE IVP (initial-value problem): an ODE or system of ODEs on an interval
% [a,b] with boundary conditions at just one boundary. (However, for
% complicated IVPs like the Lorenz equations, other methods such as
% chebfun/ode45 will be much more effective.)
%
% ODE EIGENVALUE PROBLEM: a differential or integral operator or system of
% operators on an interval [a,b] with homogeneous boundary conditions,
% where we want to compute one or more eigenvalues and eigenfunctions.
% Generalized eigenvalue problems L*u = lambda*M*u are also treated.
% 
% PDE BVP: a time-dependent problem of the form u_t = N(u,x,t), where N is 
% a linear or nonlinear differential operator.
% 
% For ODEs, Chebgui assumes that the independent variable, which varies
% over the interval [a,b], is either x or t, and that the dependent
% variable(s) have name(s) different from x and t.
%
% For eigenvalue problems, Chebgui assumes that the eigenvalue is called
% lambda or lam or l.
% 
% For PDEs, Chebgui assumes that the space variable on [a,b] is x and that
% the time variable, which ranges over a span t1:dt:t2 is t.
% 
% Here is a three-sentence sketch of how the solutions are computed.  The
% ODE and eigenvalue problems are solved by Chebfun's automated Chebyshev
% spectral methods underlying the Chebfun commands <backslash> and
% SOLVEBVP.  The discretizations involved will be described in a
% forthcoming paper by Driscoll and Hale, and the Newton and damped Newton
% iterations used to handle nonlinearity will be described in a forthcoming
% paper by Birkisson and Driscoll.  The PDE problems are solved by
% Chebfun's PDE15S method, due to Hale, which is based on spectral
% discretization in x coupled with Matlab's ODE15S solution in t.
% 
% To use Chebgui, the simplest method is to type chebgui at the Matlab
% prompt.  The GUI will appear with a demo already loaded and ready to run;
% you can get its solution by pressing the green SOLVE button.  To try
% other preloaded examples, open the DEMOS menu at the top.  To input your
% own example on the screen, change the windows in ways which we hope are
% obvious. Inputs are vectorized, so x*u and x.*u are equivalent, for
% example.  Derivatives are indicated by single or double primes, so a
% second derivative is u'' or u".
% 
% The GUI allows various types of syntax for describing the differential
% equation and boundary conditions of problems. The differential equations
% can either be in anonymous function form, e.g.
%
%   @(u) diff(u,2)+x.*sin(u)
%
% or a "natural syntax form", e.g.
%
%   u''+x.*sin(u)
%
% The first format gives extra flexibility, e.g. for specifying an
% integral operator with the help of CUMSUM.
% 
% Boundary conditions can be in either of these two forms, or alternatively
% one can specify homogeneous Dirichlet or Neumann conditions simply by
% typing 'dirichlet' or 'neumann' in the relevant fields.  Eigenvalue
% problems can be specified by equations like
%
%   -u" + x^2*u = lambda*u
%
% The GUI supports systems of coupled equations, where the problem can most
% easily be set up with a format like
%
%   u' + sin(v) = u+v
%   cos(u) + v' = 0
%
% or
%
%   u" = lambda*v
%   v" = lambda*(u+u')
%
% Finally, the most valuable Chebgui capability of all is the "Export to
% m-file" button.  With this feature, you can turn an ODE or PDE solution
% from the GUI into an M-file in standard Chebfun syntax.  This is a great
% starting point for more serious explorations.
%
% CHEBGUI is also the constructor for chebgui objects. For example
%    chebg = chebgui('type','bvp','domleft','-1','domright','1', ...
%                    'de','u" = sin(u)','lbc','u = 1','rbc','u = 0')
%    show(chebg)
%
% See also chebop/solvebvp, chebop/eigs, chebfun/pde15s, chebfun/ode45,
% chebfun/ode113, chebfun/ode15s, chebfun/bvp4c, chebfun/bvp5c.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% If chebgui is called without any arguments, we load a random example and
% display it in the GUI window
if isempty(varargin)
    % Need to create a temporary chebgui object to be able to call the
    % loadexample method
    cgTemp = chebgui('type','bvp');
    % Calling loadexample with second argument -1 gives a random example
    cg = loadexample(cgTemp,-1,'bvp');
    show(cg);
elseif nargin == 1 && isa(varargin{1},'chebgui')
    chebguiwindow(varargin{1});
else
    
    v1 = varargin{1};
    if numel(varargin) == 1 && ischar(v1) && ~strcmp(v1,'dummy')
        if ~exist(v1,'file')
            error('CHEBFUN:chebgui:missingfile','Unable to find file: %s',v1);
        end
        cgTemp = chebgui('type','bvp');
        c = loaddemos(cgTemp,v1);
        if nargout == 0
            chebguiwindow(c);
        else
            varargout{1} =c;
        end
        return
    end
    
    c.type = '';
    c.DomLeft = ''; c.DomRight = '';
    c.DE = ''; c.LBC = ''; c.RBC = '';
    c.timedomain = ''; c.sigma = '';
    c.init = ''; c.tol = [];
    c.options = struct('damping','1','plotting','0.5','grid',1,...
        'pdeholdplot',0,'fixYaxisLower','','fixYaxisUpper','','fixN','','numeigs','');
    
    k = 1;
    while k < nargin
        type = varargin{k};
        value = varargin{k+1};
        if isnumeric(value), value = num2str(value); end
        switch lower(type)
            case 'type'
                if ~strcmpi(value,'bvp') && ~strcmpi(value,'pde') && ~strcmpi(value,'ivp') && ~strcmpi(value,'eig')
                    error('CHEBGUI:chebgui:type',[value,' is not a valid type of problem.'])
                elseif strcmpi(value,'ivp')
                    warning('CHEBGUI:chebgui:type Type of problem changed from IVP to BVP');
                    c.type = 'bvp';
                else
                    c.type = value;
                end
            case 'domleft'
                c.DomLeft = value;
            case 'domright'
                c.DomRight = value;
            case 'domain'
                c.DomLeft =   num2str(varargin{k+1}(1));
                c.DomRight =  num2str(varargin{k+1}(2));
            case 'timedomain'
                c.timedomain = value;
            case 'de'
                c.DE = value;
            case 'lbc'
                c.LBC = value;
            case 'rbc'
                c.RBC = value;
            case 'init'
                c.init = value;
            case 'sigma'
                c.sigma = value;                
            case 'tol'
                c.tol = value;
            case 'options'
                % Set the fields which correspond to elements specified.
                % Use fieldnames to obtain a list of the fields in the
                % struct, then a dynamic field name to obtain the
                % corresponding value.
                fNames = fieldnames(value);
                for optCounter = 1:length(fNames)
                    optionName = char(fNames(optCounter,:));
                    c.options.(optionName)  = value.(optionName);
                end
            otherwise
                error('CHEBGUI:propname',[type,' is not a valid chebgui property.'])
        end
        k = k + 2;
    end
    
    if isempty(c.tol)
        c.tol = '1e-10'; % Default tolerance
    end
    
    varargout{1} = class(c,'chebgui');
end

