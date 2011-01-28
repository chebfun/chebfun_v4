function [u vec] = solveBVP(guifile)
% SOLVEBVP for chebgui objects.

% Create a domain and the linear function on that domain. We use xt for the
% linear function, later in the code we will be able to determine whether x
% or t is used for the linear function.
defaultTol = max(cheboppref('restol'),cheboppref('deltol'));

a = str2num(guifile.DomLeft);
b = str2num(guifile.DomRight);
[d,xt] = domain(a,b);

% Extract information from the GUI fields
deInput = guifile.DE;
lbcInput = guifile.LBC;
rbcInput = guifile.RBC;
deRHSInput = guifile.DErhs;
lbcRHSInput = guifile.LBCrhs;
rbcRHSInput = guifile.RBCrhs;
guessInput = guifile.guess;

% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(lbcInput,'char'), lbcInput = cellstr(lbcInput); end
if isa(rbcInput,'char'), rbcInput = cellstr(rbcInput); end
if isa(deRHSInput,'char'), deRHSInput = cellstr(deRHSInput); end
if isa(lbcRHSInput,'char'), lbcRHSInput = cellstr(lbcRHSInput); end
if isa(rbcRHSInput,'char'), rbcRHSInput = cellstr(rbcRHSInput); end
% !!! Should do a error check to see whether lhs and rhs number of line
% match


% Convert the input to the an. func. format, get information about the
% linear function in the problem.
[deString indVarName] = setupFields(guifile,deInput,deRHSInput,'DE');

% Assign x or t as the linear function on the domain
eval([indVarName, '=xt;']);

% Convert the string to proper anon. function using eval
DE  = eval(deString);

if ~isempty(lbcInput{1})
    [lbcString indVarName] = setupFields(guifile,lbcInput,lbcRHSInput,'BC');
    LBC = eval(lbcString);
else
    LBC = [];
end
if ~isempty(rbcInput{1})
    [rbcString indVarName] = setupFields(guifile,rbcInput,rbcRHSInput,'BC');
    RBC = eval(rbcString);
else
    RBC = [];
end

if isempty(lbcInput) && isempty(rbcInput)
    error('chebfun:bvpgui','No boundary conditions specified');
end


DErhsNum = str2num(char(deRHSInput));
if isempty(DErhsNum)
    % RHS is a string representing a function -- convert to chebfun
    DE_RHS = chebfun(deRHSInput,d);
else
    % RHS is a number - Don't need to construct chebfun
    DE_RHS = DErhsNum;
end

% DE_RHS = 0;

useLatest = strcmpi(guessInput,'Using latest solution');
if isempty(guessInput)
    N = chebop(d,DE,LBC,RBC);
elseif useLatest
    guess = handles.latestSolution;
    N = chebop(d,DE,LBC,RBC,guess);
else
    guess = eval(guessInput);
    if isnumeric(guess)
        guess = 0*xt+guess;
    end
    N = chebop(d,DE,LBC,RBC,guess);
end

tolInput = guifile.tol;
if isempty(tolInput)
    tolNum = defaultTol;
else
    tolNum = str2num(tolInput);
end

if tolNum < chebfunpref('eps')
    warndlg('Tolerance specified is less than current chebfun epsilon','Warning','modal');
    uiwait(gcf)
end

options = cheboppref;

% Set the tolerance for the solution process
options.deltol = tolNum;
options.restol = tolNum;

% Obtain information about damping and plotting
dampedOnInput = guifile.damping;
plottingOnInput = guifile.plotting;

if dampedOnInput
    options.damped = 'on';
else
    options.damped = 'off';
end

if plottingOnInput
    if strcmpi(guifile.pause,'pause')
        options.plotting = guifile.pause;
    else
        options.plotting = str2double(guifile.pause);
    end
else
    options.plotting = 'off';
end

[u vec] = solvebvp(N,DE_RHS,'options',options);