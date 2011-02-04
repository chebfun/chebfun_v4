function [cg name demotype] = pdedemos(guifile,exampleNumber,mode)
if nargin < 3
    mode = 'start';
end

numberOfExamples = 12;

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
        a = '-3*pi/4';
        b = 'pi';
        t = '0:.05:2';
        DE = 'u_t = 0.1*u" + u''';
        LBC = 'neumann';
        RBC = 'dirichlet';
        init = 'sin(2*x)';
        tol = '1e-6';
        plotting = 'on';
        fixYaxisLower = '-1';
        fixYaxisUpper = '1';
        name = DE;
        demotype = 'scalar';
    case 2
        a = '-1';
        b = '1';
        t = '0:0.1:5';
        DE = 'u_t = u*(1-u^2) + 5e-4*u"';
        LBC = 'neumann';
        RBC = 'neumann';
        init = '(1-x.^2).^2.*(1+sin(12*x))/2';
        tol = '1e-6';
        plotting = 'on';
        name = 'Allen-Cahn (neumann)';
        fixYaxisLower = '0';
        fixYaxisUpper = '1';
        demotype = 'scalar';
    case 3
        a = '-1';
        b = '1';
        t = '0:.1:5';
        DE = 'u_t = u*(1-u^2) + 5e-4*u"';
        LBC = 'u = -1';
        RBC = 'u = 1';
        init = '0.53*x-.47*sin(1.5*pi*x)';
        tol = '1e-6';
        plotting = 'on';
        fixYaxisLower = '-1';
        fixYaxisUpper = '1';
        name = 'Allen-Cahn (dirichlet)';
        demotype = 'scalar';
    case 4
        a = '-1';
        b = '1';
        t = '0:.1:4';
        DE = 'u_t = -(u^2)'' + .01*u"';
        LBC = 'dirichlet';
        RBC = 'dirichlet';
        init = '(1-x.^2).*exp(-30*(x+.5).^2)';
        tol = '1e-6';
        plotting = 'on';
        name = 'Burgers''';
        fixYaxisLower = '0';
        fixYaxisUpper = '0.8';
        demotype = 'scalar';
    case 5
        a = '-1';
        b = '1';
        t = '0:.01:2';
        DE = 'u_t = u*u'' - u" - 0.006*u""';
        LBC = {'u = 1','u'' = 2'};
        RBC = {'u = 1','u'' = 2'};
        init = '1 + 0.5*exp(-40*x.^2)';
        tol = '1e-6';
        plotting = 'on';
        fixYaxisLower = '-30';
        fixYaxisUpper = '30';
        name = 'KS';
        demotype = 'scalar';
    case 6
        a = '-1';
        b = '1';
        t = '0:.05:2';
        DE = {'u_t = -u + (x + 1)*v + 0.1*u"'; 'v_t = u - (x + 1)*v + 0.2*v"'};
        LBC = {'u'' = 0';'v'' = 0'};
        RBC = {'u'' = 0';'v'' = 0'};
        init = {'1';'1'};
        tol = '1e-6';
        plotting = 'on';
        fixYaxisLower = '0.4';
        fixYaxisUpper = '1.6';
        name = 'System 1';
        demotype = 'system';
    case 7
        a = '-1';
        b = '1';
        t = '0:.05:2';
        DE = {'v_t = u - (x + 1)*v + 0.2*v"' ; 'u_t = -u + (x + 1)*v + 0.1*u"'};
        LBC = {'u'' = 0';'v'' = 0'};
        RBC = {'u'' = 0';'v'' = 0'};
        init = {'1';'1'};
        tol = '1e-6';
        plotting = 'on';
        fixYaxisLower = '0.4';
        fixYaxisUpper = '1.6';
        name = 'System 1 (flipped)';
        demotype = 'system';
    case 8
        a = '-1';
        b = '1';
        t = '0:.1:2';
        DE = {'u_t = 0.1*u" - 100*u*v' ; 'v_t = .2*v" - 100*u*v' ; 'w_t = 0.001*w" + 200*u*v'};
        LBC = {'neumann'};
        %         LBC = {'u'''; 'v''' ; 'w'''};
        RBC = {'neumann'};
        %         RBC = {'u'''; 'v''' ; 'w'''};
        init = {'1-erf(10*(x+0.7))' ; '1 + erf(10*(x-0.7))' ; '0'};
        tol = '1e-6';
        plotting = 'on';
        fixYaxisLower = '0';
        fixYaxisUpper = '2';
        name = 'System 2 (3 eqns)';
        demotype = 'system';
    case 9
        a = '-1';
        b = '1';
        t = '0:.1:2';
        DE = {'u_t = 0.1*u" - 100*u*v' ; 'v_t = 0.2*v" - 100*u*v' ; 'w_t = 0.001*w" + 200*u*v'};
        %         LBC = {'neumann'};
        LBC = {'u'''; 'v''' ; 'w'''};
        %         RBC = {'neumann'};
        RBC = {'u'''; 'v''' ; 'w'''};
        init = {'1-erf(10*(x+0.7))' ; '1+erf(10*(x-0.7))' ; '0'};
        tol = '1e-6';
        plotting = 'on';
        fixYaxisLower = '0';
        fixYaxisUpper = '2';
        name = 'System 2 (3 eqns alt)';
        demotype = 'system';
    case 10
        a = '-1';
        b = '1';
        t = '0:.1:2';
        DE = {'u_t = u" - v' ; 'v" - u = 0'};
        LBC = {'u = 1'; 'v = 1'};
        RBC = {'u = 1'; 'v = 1'};
        init = {'1' ; '1'};
        tol = '1e-6';
        plotting = 'on';
        fixYaxisLower = '0.6';
        fixYaxisUpper = '1';
        name = 'Coupled PDE-BVP';
        demotype = 'system';
    case 11
        a = '-1';
        b = '1';
        t = '0:.1:4';
        DE = {'u_t = .02*u" + cumsum(u)*sum(u)'};
        LBC = {'dirichlet'};
        RBC = {'dirichlet'};
        init = {'(1-x^2)*exp(-30*(x+.5)^2)'};
        tol = '1e-6';
        plotting = 'on';
        name = 'Integro-Differential Eqn.';
        fixYaxisLower = '0';
        fixYaxisUpper = '1.4';
        demotype = 'scalar';
    case 12
        a = '0';
        b = '10';
        t = '0:.1:10';
        DE = {'u_t = v','v_t = u" + exp(-100*x^2)*sin(pi*t)'};
        LBC = {'u'' = 0'; 'v'' = 0'};
        RBC = {'u'' = 0'; 'v'' = 0'};
        init = {'0','0'};
        tol = '1e-6';
        plotting = 'on';
        fixYaxisLower = '-0.1';
        fixYaxisUpper = '0.1';
        name = 'Wave Equation';
        demotype = 'system';    
end

options = struct('plotting',plotting,'fixYaxisLower',fixYaxisLower,...
    'fixYaxisUpper',fixYaxisUpper);

cg = chebgui('type','pde','domleft',a,'domright',b,'timedomain',t,'de',DE,...
    'lbc',LBC,'rbc',RBC,'init',init,'tol',tol,'options',options);