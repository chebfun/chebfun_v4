function [cg name demotype] = pdedemos(guifile,exampleNumber,mode)
if nargin < 3
    mode = 'start';
end

numberOfExamples = 10;

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
fixYaxisLower = '';
fixYaxisUpper = '';

switch exampleNumber
    case 0
        a = '';
        b = '';
        t = '';
        DE = '';
        LBC = '';
        RBC = '';
        init = '';
        tol = '';
        plotting = '';
        name = '';
        demotype = '';
    case 1
        a = '-3*pi/4'; b = 'pi'; t = '0:.05:2';
        DE = 'u_t = 0.1*u" + u''';
        LBC = 'neumann'; RBC = 'dirichlet';
        init = 'sin(2*x)';
        tol = '1e-6'; plotting = 'on';
        fixYaxisLower = '-1'; fixYaxisUpper = '1';
        name = 'Advection-diffusion equation';
        demotype = 'scalar';
    case 2
        a = '-3'; b = '3'; t = '0:0.2:10';
        DE = 'u_t = .01*u'''' + u - u^3';
        LBC = 'periodic';
        RBC = 'periodic';
        init = '-1+2*(exp(-35*(x+2)^2)+exp(-11*x^2)+exp(-7*(x-2)^2))';
        tol = '1e-6'; plotting = 'on';
        name = 'Allen-Cahn equation';
        fixYaxisLower = '-1'; fixYaxisUpper = '1';
        demotype = 'scalar';
    case 3
        a = '-1'; b = '1'; t = '0:.04:5';
        DE = 'u_t = -(u^2)'' + .02*u"';
        LBC = 'dirichlet'; RBC = 'dirichlet';
        init = '(1-x.^2).*exp(-30*(x+.5).^2)';
        tol = '1e-4'; plotting = 'on';
        name = 'Burgers equation';
        fixYaxisLower = '0'; fixYaxisUpper = '0.8';
        demotype = 'scalar';
    case 4
        a = '-3'; b = '3'; t = '0:.025:1.6';
        DE = 'u_t = -.003*u'''''''' + (u^3-u)''''';
        LBC = {'u = -1','u''=0'}; RBC = {'u = -1','u''=0'};
        init = 'cos(x) - exp(-3*x^2)';
        tol = '1e-6'; plotting = 'on';
        fixYaxisLower = '-1'; fixYaxisUpper = '1.2';
        name = 'Cahn-Hilliard equation';
        demotype = 'scalar';
    case 5
        a = '-4'; b = '4'; t = '0:.01:1.5';
        DE = 'u_t = 0.1*u''''';
        LBC = 'dirichlet'; RBC = 'dirichlet';
        init = 'sin(pi*x/4) + sin(pi*3*x/4) + sin(pi*12*x/4)';
        tol = '1e-6'; plotting = 'on';
        fixYaxisLower = '-3'; fixYaxisUpper = '3';
        name = 'Heat equation';
        demotype = 'scalar';
    case 6
        a = '-1'; b = '1'; t = '0:.1:4';
        DE = {'u_t = .02*u" + cumsum(u)*sum(u)'};
        LBC = {'dirichlet'};
        RBC = {'dirichlet'};
        init = {'(1-x^2)*exp(-30*(x+.5)^2)'};
        tol = '1e-6'; plotting = 'on';
        name = 'Integro-differential equation';
        fixYaxisLower = '0'; fixYaxisUpper = '1.4';
        demotype = 'scalar';
    case 7
        a = '-1'; b = '1'; t = '0:.01:2';
        DE = 'u_t = u*u'' - u" - 0.006*u""';
        LBC = {'u = 1','u'' = 2'}; RBC = {'u = 1','u'' = 2'};
        init = '1 + 0.5*exp(-40*x.^2)';
        tol = '1e-4'; plotting = 'on';
        fixYaxisLower = '-30'; fixYaxisUpper = '30';
        name = 'Kuramoto-Sivashinsky equation';
        demotype = 'scalar';
    case 8
        a = '-1'; b = '1'; t = '0:.1:3';
        DE = {'u_t = 0.1*u" - 100*u*v';'v_t = .2*v" - 100*u*v';'w_t = 0.001*w" + 200*u*v'};
        LBC = {'neumann'}; RBC = {'neumann'};
        init = {'1-erf(10*(x+0.7))' ; '1 + erf(10*(x-0.7))' ; '0'};
        tol = '1e-5'; plotting = 'on';
        fixYaxisLower = '0'; fixYaxisUpper = '2.2';
        name = 'Diffusion and reaction of three chemicals';
        demotype = 'system';
    case 9
        a = '-1'; b = '1';
        t = '0:.1:2';
        DE = {'u_t = u" - v' ; 'v" - u = 0'};
        LBC = {'u = 1'; 'v = 1'};
        RBC = {'u = 1'; 'v = 1'};
        init = {'1' ; '1'};
        tol = '1e-6'; plotting = 'on';
        fixYaxisLower = '0.6'; fixYaxisUpper = '1';
        name = 'Coupled PDE-BVP';
        demotype = 'system';
    case 10
        a = '-2'; b = '2';
        t = '0:.1:10';
        DE = {'u_t = v''','v_t = u'''};
        LBC = 'u = 0';
        RBC = 'u = 0';
        init = {'.25*(4-x^2)*exp(-10*x^2)','0'};
        tol = '1e-4'; plotting = 'on';
        fixYaxisLower = '-1.2'; fixYaxisUpper = '1.2';
        name = 'Wave equation';
        demotype = 'system';    
end

options = struct('plotting',plotting,'fixYaxisLower',fixYaxisLower,...
    'fixYaxisUpper',fixYaxisUpper);

cg = chebgui('type','pde','domleft',a,'domright',b,'timedomain',t,'de',DE,...
    'lbc',LBC,'rbc',RBC,'init',init,'tol',tol,'options',options);
