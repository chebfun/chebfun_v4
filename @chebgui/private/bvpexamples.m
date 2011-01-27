function [cg name demotype] = bvpexamples(guifile,exampleNumber,mode)
if nargin < 3
    mode = 'start';
end

numberOfExamples = 5;

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
        DErhs = '';
        LBC = '';
        LBCrhs = '';
        RBC = '';
        RBCrhs = '';
        guess = '';
        tol = '';
        damping = '';
        plotting = '0.1';
        name = '';
        demotype = '';
        cg = chebgui('type','bvp','domleft',a,'domright',b,'de',DE,...
            'derhs',DErhs,'lbc',LBC,'lbcrhs',LBCrhs, ...
            'rbc',RBC,'rbcrhs',RBCrhs,'guess',guess,'tol',tol,...
            'plotting',plotting,'damping',damping);
    case 1
        a = '-2';
        b = '2';
        DE = 'u"+x.*sin(u)';
        DErhs = '1';
        LBC = 'u';
        LBCrhs = '0';
        RBC = 'u';
        RBCrhs = '0';
        guess = '';
        tol = '1e-10';
        damping = '1';
        plotting = '0.1';
        name = DE;
        demotype = 'bvp';
        cg = chebgui('type','bvp','domleft',a,'domright',b,'de',DE,...
            'derhs',DErhs,'lbc',LBC,'lbcrhs',LBCrhs, ...
            'rbc',RBC,'rbcrhs',RBCrhs,'guess',guess,'tol',tol,...
            'plotting',plotting,'damping',damping);
    case 2
        a = '1';
        b = '3';
        DE = 'u"+cos(sin(u))';
        DErhs = '-1';
        LBC = 'u''';
        LBCrhs = '2';
        RBC = 'u';
        RBCrhs = '0';
        guess = '';
        tol = '1e-10';
        damping = '1';
        plotting = '0.1';
        name = DE;
        demotype = 'bvp';
        cg = chebgui('type','bvp','domleft',a,'domright',b,'de',DE,...
            'derhs',DErhs,'lbc',LBC,'lbcrhs',LBCrhs, ...
            'rbc',RBC,'rbcrhs',RBCrhs,'guess',guess,'tol',tol,...
            'plotting',plotting,'damping',damping);
    case 3
        a = '-5';
        b = '5';
        DE = '0.01*u''''-x.*u';
        DErhs = '1';
        LBC = 'u';
        LBCrhs = '0';
        RBC = 'u';
        RBCrhs = '0';
        guess = '';
        tol = '1e-10';
        damping = '0';
        plotting = '0.1';
        name = 'Airy equation';
        demotype = 'bvp';
        cg = chebgui('type','bvp','domleft',a,'domright',b,'de',DE,...
            'derhs',DErhs,'lbc',LBC,'lbcrhs',LBCrhs, ...
            'rbc',RBC,'rbcrhs',RBCrhs,'guess',guess,'tol',tol,...
            'plotting',plotting,'damping',damping);
    case 4
        a = '-1';
        b = '1';
        DE = {'u"-sin(v)';'cos(u)+v"'};
        DErhs = {'0','0'};
        LBC = {'u';'v'''};
        LBCrhs = {'1';'0'};
        RBC = {'u''';'v'};
        RBCrhs = {'0';'0'};
        guess = '';
        tol = '1e-10';
        damping = '0';
        plotting = '0.1';
        name = 'Coupled system';
        demotype = 'system';
        cg = chebgui('type','bvp','domleft',a,'domright',b,'de',DE,...
            'derhs',DErhs,'lbc',LBC,'lbcrhs',LBCrhs, ...
            'rbc',RBC,'rbcrhs',RBCrhs,'guess',guess,'tol',tol,...
            'plotting',plotting,'damping',damping);
    case 5
        a = '-2';
        b = '2';
        DE = 'u"-x.*sin(u)';
        DErhs = '1';
        LBC = {'u';'u'''};
        LBCrhs = {'1';'0'};
        RBC = '';
        RBCrhs = '';
        guess = '';
        tol = '1e-10';
        damping = '1';
        plotting = '0.1';
        name = 'IVP';
        demotype = 'ivp';
        cg = chebgui('type','bvp','domleft',a,'domright',b,'de',DE,...
            'derhs',DErhs,'lbc',LBC,'lbcrhs',LBCrhs, ...
            'rbc',RBC,'rbcrhs',RBCrhs,'guess',guess,'tol',tol,...
            'plotting',plotting,'damping',damping);
end