function [a b DE DErhs LBC LBCrhs RBC RBCrhs guess tol] = bvpexamples(exampleNumber,mode)
if nargin < 2
    mode = 'start';
end

numberOfExamples = 3;

% If called with a 0, open with an empty gui. If called with a number less
% than 0, bigger than the number of available examples, or no argument,
% start with a random example.
if exampleNumber < 0 || exampleNumber > numberOfExamples
    exampleNumber = randi(numberOfExamples);
    % If we call the function with the Demos button, we want to notify the
    % code that we have extracted information about all examples.
    if strcmp(mode,'demo')
        a = 0; b = 0; DE = '0'; DErhs = '0'; return
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
end