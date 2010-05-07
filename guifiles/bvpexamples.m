function [a b DE DErhs LBC LBCrhs RBC RBCrhs guess tol name] = bvpexamples(exampleNumber,mode)
if nargin < 2
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
        a = 0; b = 0; DE = '0'; DErhs = '0'; LBC = 0; LBCrhs = 0;
        RBC = 0; RBCrhs = 0; guess = 0; tol = 0; name = '0';
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
        name = '';
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
        name = DE;
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
        name = DE;
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
        name = 'Airy equation';
    case 4
        a = '-1';
        b = '1';
        DE = {'u"-sin(v)','cos(u)+v"'};
        DErhs = {'0','0'};
        LBC = {'u';'v'''};
        LBCrhs = {'1','0'};
        RBC = {'u''';'v'};
        RBCrhs = {'0','0'};
        guess = '';
        tol = '1e-10';
        name = 'Coupled system';
    case 5
        a = '-2';
        b = '2';
        DE = 'u"-x.*sin(u)';
        DErhs = '1';
        LBC = {'u','u'''};
        LBCrhs = {'1','0'};
        RBC = '';
        RBCrhs = '';
        guess = '';
        tol = '1e-10';
        name = 'IVP';
end