function [cg name demotype] = bvpexamples(guifile,exampleNumber,mode)
if nargin < 3
    mode = 'start';
end

numberOfExamples = 8;

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
        a = '';
        b = '';
        DE = '';
        LBC = '';
        RBC = '';
        init = '';
        tol = '';
        damping = '';
        plotting = '0.1';
        name = '';
        demotype = '';
    case 1
        a = '-2';
        b = '2';
        DE = 'u" + x*sin(u) = 1';
        LBC = 'u = 0';
        RBC = 'u = 0';
        init = '';
        tol = '1e-10';
        damping = '1';
        plotting = '0.1';
        name = DE;
        demotype = 'bvp';
    case 2
        a = '1';
        b = '3';
        DE = 'u" + cos(sin(u)) = -1';
        LBC = 'u'' = 2';
        RBC = 'u = 0';
        init = '';
        tol = '1e-10';
        damping = '1';
        plotting = '0.1';
        name = DE;
        demotype = 'bvp';
    case 3
        a = '-5';
        b = '5';
        DE = '0.01*u'''' - x*u = 1';
        LBC = 'u = 0';
        RBC = 'u = 0';
        init = '';
        tol = '1e-10';
        damping = '0';
        plotting = '0.1';
        name = 'Airy equation';
        demotype = 'bvp';
    case 4
        a = '-1';
        b = '1';
        DE = {'u" - sin(v) = 0';'cos(u) + v" = 0'};
        LBC = {'u = 1';'v'' = 0'};
        RBC = {'u'' = 0';'v = 0'};
        init = '';
        tol = '1e-10';
        damping = '0';
        plotting = '0.4';
        name = 'Coupled system';
        demotype = 'system';
    case 5
        a = '-2';
        b = '2';
        DE = 'u" - x*sin(u) = 1';
        LBC = {'u = 1';'u'' = 0'};
        RBC = '';
        init = '';
        tol = '1e-10';
        damping = '1';
        plotting = '0.1';
        name = 'IVP';
        demotype = 'ivp';
    case 6
        a = '0';
        b = '15';
        DE = 'u" - (1-u^2)*u'' + u = 0';
        DErhs = '0';
        LBC = {'u = 2';'u'' = 0'};;
        RBC = '';
        init = '';
        tol = '1e-10';
        damping = '1';
        plotting = '0.1';
        name = 'Van der Pol';
        demotype = 'ivp';
    case 7
        a = '-1';
        b = '1';
        DE = '0.01*u" + 2*(1-x^2)*u + u^2 = 1';
        LBC = 'u = 0';
        RBC = 'u = 0';
        init = '2*(x^2-1).*(1-2/(1+20*x^2))';
        tol = '1e-10';
        damping = '1';
        plotting = '0.1';
        name = 'Carrier equation';
        demotype = 'bvp';
    case 8
        a = '-100';
        b = '100';
        DE = 'u" + (1.2+sign(10-abs(x)))*u = 1';
        LBC = 'u = 0';
        RBC = 'u = 0';
        init = '';
        tol = '1e-10';
        damping = '1';
        plotting = '0.1';
        name = 'Discontinuous coefficient';
        demotype = 'bvp';
end

options = struct('damping',damping,'plotting',plotting);

cg = chebgui('type','bvp','domleft',a,'domright',b,'de',DE,...
    'lbc',LBC,'rbc',RBC,'init',init,'tol',tol,...
    'options',options);