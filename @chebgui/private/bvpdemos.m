function [cg name demotype] = bvpdemos(guifile,exampleNumber,mode)

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if nargin < 3
    mode = 'start';
end

numberOfExamples = 24;

% If called with a 0, open with an empty gui. If called with a number less
% than 0, bigger than the number of available examples, or no argument,
% start with a random example.
if exampleNumber < 0 || exampleNumber > numberOfExamples
    exampleNumber = ceil(numberOfExamples*rand(1));
    % If we call the function with the Demos button, we want to notify the
    % code that we have extracted information about all examples.
    if strcmp(mode,'demo')
        name = 'stop'; demotype = ''; cg = chebgui('type','bvp');
        return
    end
end

switch exampleNumber
    case 0
        a = ''; b = '';
        DE = '';
        LBC = ''; RBC = '';
        init = ''; tol = '';
        damping = ''; plotting = '0.1';
        name = '';
        demotype = '';
    case 1
        a = '0'; b = '1';
        DE = '0.02*u'''' + u'' + u = 0';
        LBC = 'u = 0'; RBC = 'u = 1';
        init = ''; tol = '1e-10';
        damping = '0'; plotting = '0.1';
        name = 'Advection-diffusion equation';
        demotype = 'bvp';
    case 2
        a = '-5'; b = '5';
        DE = '0.01*u'''' - x*u = 1';
        LBC = 'u = 0'; RBC = 'u = 0';
        init = ''; tol = '1e-10';
        damping = '0'; plotting = '0.1';
        name = 'Airy equation';
        demotype = 'bvp';
   case 3
        a = '0'; b = '30';
        DE = 'x^2*u'''' + x*u'' + (x^2-3^2)*u = 0';
        LBC = 'u = 0'; RBC = 'u = 1';
        init = ''; tol = '1e-10';
        damping = '0'; plotting = '0.1';
        name = 'Bessel equation';
        demotype = 'bvp';
    case 4
        a = '-1'; b = '1';
        DE = {'u" - sin(v) = 0';'cos(u) + v" = 0'};
        LBC = {'u = 1';'v'' = 0'};
        RBC = {'u'' = 0';'v = 0'};
        init = ''; tol = '1e-10';
        damping = '0'; plotting = '0.4';
        name = 'Coupled system with sin(v) and cos(u)';
        demotype = 'system';
    case 5
        a = '0'; b = '18';
        DE = {'u'' = u - u*v';'v'' = -v + u*v'};
        LBC = {'u = 1.2';'v = 1.2'};
        RBC = '';
        init = {'u = 1.2';'v = 1.2'}; tol = '1e-10';
        damping = '0'; plotting = '0.4';
        name = 'Lotka-Volterra predator-prey';
        demotype = 'system';
    case 6
        a = '0'; b = '.99';
        DE = 'u'' = u^2';
        LBC = 'u = 1';
        RBC = ' ';
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Blow-up initial value problem';
        demotype = 'ivp';
    case 7
        a = '0'; b = '10';
        DE = 'x*u" +2*u''+x*u^2';
        LBC = {'u = 1','u'' = 0'}; RBC = '';
        init = ''; tol = '1e-8';
        damping = '1'; plotting = '0.1';
        name = 'Lane-Emden equation';
        demotype = 'ivp';  
    case 8
        a = '0'; b = '10*pi';
        DE = 'u" = -u';
        DErhs = '0';
        LBC = {'u = 2';'u'' = 0'}; RBC = '';
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Linear wave equation';
        demotype = 'ivp';
    case 9
        a = '0'; b = '8';
        DE = 'u'' = sign(sin(x^2)) - u/2';
        DErhs = '0';
        LBC = 'u = 0'; RBC = '';
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Linear Sawtooth IVP';
        demotype = 'ivp';
    case 10
        a = '-1'; b = '1';
        DE = '0.01*u" + 2*(1-x^2)*u + u^2 = 1';
        LBC = 'u = 0'; RBC = 'u = 0';
        init = 'u = 2*(x^2-1)*(1-2/(1+20*x^2))';
        tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Carrier equation';
        demotype = 'bvp';
    case 11
        a = '-1'; b = '1';
        DE = '0.01*u" + 2*(1-x^2)*u + u^2 = 1';
        LBC = 'u = 0'; RBC = 'u = 0';
        init = 'u = 2*x*(x^2-1)*(1-2/(1+20*x^2))';
        tol = '1e-10';
        damping = '0'; plotting = '0.1';
        name = 'Carrier equation (another solution)';
        demotype = 'bvp';
    case 12
        a = '-100'; b = '100';
        DE = 'u" + (1.2+sign(10-abs(x)))*u = 1';
        LBC = 'u = 0'; RBC = 'u = 0';
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Discontinuous coefficient wave equation';
        demotype = 'bvp';
    case 13
        a = '0'; b = '1';
        DE = '0.02*u'''' + sign(x-.5)*u'' + u = 0';
        LBC = 'u = 0.5'; RBC = 'u = 1';
        init = ''; tol = '1e-10';
        damping = '0'; plotting = '0.1';
        name = 'Discontinuous coefficient advection-diffusion';
        demotype = 'bvp';
    case 14
        a = '-4'; b = '4';
        DE = 'u" + u - u^2 = 0';
        LBC = 'u = 1'; RBC = 'u = 0';
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Fisher-KPP equation';
        demotype = 'bvp';
    case 15
        a = '0'; b = '1';
        DE = 'u'''''''' = u''*u'''' - u*u''''''';
        LBC = {'u = 0','u'' = 0'}; RBC = {'u = 1','u'' = -5'};
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Fourth-order equation';
        demotype = 'bvp';
    case 16
        a = '-1'; b = '1';
        DE= 'u" + .87*exp(u) = 0';
        LBC = 'u = 0'; RBC = 'u = 0';
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Frank-Kamenetskii blowup equation';
        demotype = 'bvp';
    case 17
        a = '-1'; b = '1';
        DE = '.0005*u'''' + x*(x^2-0.5)*u'' + 3*(x^2-0.5)*u = 0';
        LBC = 'u = -2'; RBC = 'u = 4';
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Interior layers (linear)';
        demotype = 'bvp';
    case 18
        a = '0'; b = '1';
        DE = '.01*u" + u*u'' = u';
        LBC = 'u = -7/6'; RBC = 'u = 3/2';
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Interior layer (nonlinear)';
        demotype = 'bvp';
      
    case 19
        a = '0'; b = '10';
        DE = 'u'''' = - sin(u)';
        LBC = 'u = 2'; RBC = 'u = 2';
        init = 'u = 2*cos(2*pi*x/10)'; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Nonlinear pendulum';
        demotype = 'bvp';
    case 20
        a = '0'; b = '10';
        DE = 'u'''' = - sin(u)';
        LBC = 'u = 2'; RBC = 'u = 2';
        init = 'u = 2 + sin(pi*x/10)'; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Nonlinear pendulum (another solution)';
        demotype = 'bvp';
    case 21
        a = '-5'; b = '5';
        DE = '0.1*u'''' - u^3 = -100*(x>=0.99999)*(x<=1.00001)';
        LBC = 'u'' = 0'; RBC = 'u = 0';
        init = ''; tol = '1e-10';
        damping = '0'; plotting = '0.1';
        name = 'Piecewise forcing term';
        demotype = 'bvp';
    case 22
        a = '-1'; b = '1';
        DE = '0.05*u" + (u'')^2 = 1';
        LBC = 'u = 0.8'; RBC = 'u = 1.2';
        init = ''; tol = '1e-8';
        damping = '1'; plotting = '0.03';
        name = 'Sawtooth problem';
        demotype = 'bvp';
    case 23
        a = '0'; b = '1';
        DE = 'u" = 8*sinh(8*u)';
        LBC = 'u = 0'; RBC = 'u = 1';
        init = ''; tol = '1e-8';
        damping = '1'; plotting = '0.1';
        name = 'Troesch equation';
        demotype = 'bvp';
    case 24
        a = '0'; b = '15';
        DE = 'u" - (1-u^2)*u'' + u = 0';
        DErhs = '0';
        LBC = {'u = 2';'u'' = 0'}; RBC = '';
        init = ''; tol = '1e-10';
        damping = '1'; plotting = '0.1';
        name = 'Van der Pol equation';
        demotype = 'ivp';
    case 25
        a = '-1'; b = '1';
        DE = 'u" = (u-1)*(1+(u'')^2)^1.5';
        LBC = 'u = 0'; RBC = 'u = 0';
        init = ''; tol = '1e-8';
        damping = '1'; plotting = '0.1';
        name = 'Water droplet';
        demotype = 'bvp';

end

options = struct('damping',damping,'plotting',plotting);

cg = chebgui('type','bvp','domleft',a,'domright',b,'de',DE,...
    'lbc',LBC,'rbc',RBC,'init',init,'tol',tol,...
    'options',options);
