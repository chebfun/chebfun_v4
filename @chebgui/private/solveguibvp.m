function varargout = solveguibvp(guifile,handles)
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
initInput = guifile.init;

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
[deString allVarString indVarName] = setupFields(guifile,deInput,deRHSInput,'DE');

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
if guiMode && useLatest
    guess = handles.latestSolution;
    N = chebop(d,DE,LBC,RBC,guess);
elseif ~isempty(initInput)
    guess = eval(vectorize(initInput));
    if isnumeric(guess)
        guess = 0*xt+guess;
    end
    N = chebop(d,DE,LBC,RBC,guess);
else
    N = chebop(d,DE,LBC,RBC);
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

% Always display iter. information
options.display = 'iter';

% Obtain information about damping and plotting
dampedOnInput = str2num(guifile.options.damping);
plottingOnInput = str2num(guifile.options.plotting);

if dampedOnInput
    options.damped = 'on';
else
    options.damped = 'off';
end

if isempty(plottingOnInput) % If empty, we have either 'off' or 'pause'
    if strcmpi(guifile.options.plotting,'pause')
        options.plotting = 'pause';
    else
        options.plotting = 'off';
    end
else
    options.plotting = plottingOnInput;
end

% Do we want to show grid?
options.grid = guifile.options.grid;


% Various things we only need to think about when in the GUI, changes GUI compenents.
if guiMode
    set(handles.iter_list,'String','');
    set(handles.iter_text,'Visible','On');
    set(handles.iter_list,'Visible','On');
    
    guihandles = {handles.fig_sol,handles.fig_norm,handles.iter_text, ...
        handles.iter_list,handles.text_norm,handles.button_solve};
    set(handles.text_norm,'Visible','Off');
    set(handles.fig_sol,'Visible','On');
    set(handles.fig_norm,'Visible','On');
end

% Call solvebvp with different arguments depending on whether we're in GUI
% or not. If we're not in GUI mode, we can finish here.
if guiMode
    [u vec] = solvebvp(N,DE_RHS,'options',options,'guihandles',guihandles);
else
    [u vec] = solvebvp(N,DE_RHS,'options',options);
    varargout{1} = u;
    varargout{2} = vec;
end

% Now do some more stuff specific to GUI
if guiMode
    % Store in handles latest chebop, solution, vector of norm of updates etc.
    % (enables exporting later on)
    handles.latestSolution = u;
    handles.latestNorms = vec;
    handles.latestChebop = N;
    handles.latestRHS = DE_RHS;
    handles.latestOptions = options;
    
    % Notify the GUI we have a solution available
    handles.hasSolution = 1;
    
    set(handles.text_norm,'Visible','On');
    
    
    axes(handles.fig_sol)
    plot(u,'Linewidth',2),
    if guifile.options.grid
        grid on
    end
    if length(vec) > 1
        title('Solution at end of iteration')
    else
        title('Solution');
    end
    axes(handles.fig_norm)
    semilogy(vec,'-*','Linewidth',2),title('Norm of updates'), xlabel('Iteration number')
    if length(vec) > 1
        XTickVec = 1:max(floor(length(vec)/5),1):length(vec);
        set(gca,'XTick', XTickVec), xlim([1 length(vec)]), grid on
    else % Don't display fractions on iteration plots
        set(gca,'XTick', 1)
    end
    
    % Return the handles as varargout.
    varargout{1} = handles;
end

end