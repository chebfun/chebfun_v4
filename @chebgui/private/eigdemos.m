function [cg name demotype] = eigdeoms(guifile,exampleNumber,mode)
if nargin < 3
    mode = 'start';
end

numberOfExamples = 3;

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
        name = '';
        demotype = '';
    case 1
        a = '-2'; b = '2';
        DE = 'u" + u'' = lambda*u';
        LBC = 'u = 0'; RBC = 'u = 0';
        init = ''; tol = '1e-10';
        sigma = '';
        name = 'Advection-diffusion';
        demotype = 'scalar';
    case 2
        a = '-10'; b = '10';
        DE = '-u'''' + x^2*u  = lambda*u';
        LBC = 'u = 0'; RBC = 'u = 0';
        init = ''; tol = '1e-10';
        sigma = '';
        name = 'Harmonic oscillator';
        demotype = 'scalar';
    case 3
        a = '-2'; b = '2';
        DE = {'u" + u*x+v = lambda*u';'v"+sin(x)*u = lambda*v'};
        LBC = {'u = 0';'v = 0'};
        RBC = {'u = 0';'v = 0'};
        init = '';
        tol = '1e-10';
        sigma = '';
        name = 'System';
        demotype = 'system';        

end

cg = chebgui('type','eig','domleft',a,'domright',b,'de',DE,...
    'lbc',LBC,'rbc',RBC,'init',init,'sigma',sigma,'tol',tol);