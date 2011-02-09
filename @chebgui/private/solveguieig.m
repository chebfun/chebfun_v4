function varargout = solveguieig(guifile,handles)
% SOLVEGUIBVP

% Create a domain and the linear function on that domain. We use xt for the
% linear function, later in the code we will be able to determine whether x
% or t is used for the linear function.
defaultTol = max(cheboppref('restol'),cheboppref('deltol'));

% Handles will be an empty variable if we are solving without using the GUI
if nargin < 2
    guiMode = 0;
else
    guiMode = 1;
end
a = str2num(guifile.DomLeft);
b = str2num(guifile.DomRight);
[d,xt] = domain(a,b);

% Extract information from the GUI fields
deInput = guifile.DE;
lbcInput = guifile.LBC;
rbcInput = guifile.RBC;
sigma = [];
if ~isempty(guifile.sigma)
    numSigma = str2num(sigma); 
    if ~isempty(numSigma), sigma = numSigma;
    else sigma = guifile.sigma; end
end
K = 6;
if isfield(guifile.options,'numeigs') && ~isempty(guifile.options.numeigs)
    K = str2double(guifile.options.numeigs);
end

% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(lbcInput,'char'), lbcInput = cellstr(lbcInput); end
if isa(rbcInput,'char'), rbcInput = cellstr(rbcInput); end

deRHSInput = cellstr(repmat('0',numel(deInput),1));
lbcRHSInput = cellstr(repmat('0',numel(lbcInput),1));
rbcRHSInput = cellstr(repmat('0',numel(rbcInput),1));

% Find whether the user wants to use the latest solution as a guess. This is
% only possible when calling from the GUI
if guiMode
    useLatest = strcmpi(get(handles.input_GUESS,'String'),'Using latest solution');
end

% Convert the input to the an. func. format, get information about the
% linear function in the problem.
[deString allVarString indVarName pdeVarName pdeflag allVarNames] = setupFields(guifile,deInput,deRHSInput,'DE');

% Assign x or t as the linear function on the domain
eval([indVarName, '=xt;']);

% Convert the string to proper anon. function using eval
DE  = eval(deString);

if ~isempty(lbcInput{1})
    [lbcString indVarName] = setupFields(guifile,lbcInput,lbcRHSInput,'BC',allVarString);
    LBC = eval(lbcString);
else
    LBC = [];
end
if ~isempty(rbcInput{1})
    [rbcString indVarName] = setupFields(guifile,rbcInput,rbcRHSInput,'BC',allVarString);
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

% Create the chebop
N = chebop(d,DE,LBC,RBC);
% Try to linearise it
try
    N = linop(N);
catch
    error('CHEBFUN:Parse:linear','Operator is not linear.');
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
% Do we want to show grid?
options.grid = guifile.options.grid;

% Various things we only need to think about when in the GUI, changes GUI compenents.
if guiMode
%     set(handles.iter_list,'String','');
%     set(handles.iter_text,'Visible','On');
%     set(handles.iter_list,'Visible','On');

    set(handles.fig_sol,'Visible','On');
    set(handles.fig_norm,'Visible','On');
end

% Compute the eigenvalues

if isempty(sigma)
    [V D] = eigs(N,K);
else
    [V D] = eigs(N,K,sigma);
end

[D idx] = sort(diag(D));

if iscell(V)
    for k = 1:numel(V)
        V{k} = V{k}(:,idx);    
    end
else
    V = V(:,idx);
end

% If we're not in GUI mode, we can finish here.
if ~guiMode
    if nargout == 1
        varargout = diag(D);
    else
        varargout{1} = D;
        varargout{2} = V;
    end
    return
end

% Now do some more stuff specific to GUI
if guiMode
    % Store in handles latest chebop, solution, vector of norm of updates etc.
    % (enables exporting later on)
    handles.latest.solution = D;
    handles.latest.solutionT = V;
    handles.latest.chebop = N;
    handles.latest.options = options;
    % Notify the GUI we have a solution available
    handles.hasSolution = 1;
    handles.varnames = allVarNames;
    
    ploteigenmodes(handles.guifile,handles,handles.fig_sol,handles.fig_norm);
    
    % Return the handles as varargout.
    varargout{1} = handles;
end

end