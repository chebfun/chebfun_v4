function handles = solveGUIPDE(handles)
% Create a domain and the linear function on that domain. We use xt for the
% linear function, later in the code we will be able to determine whether x
% or t is used for the linear function.

guihandles = {handles.fig_sol,handles.fig_norm,handles.iter_text, ...
    handles.iter_list,handles.text_norm,handles.button_solve};
set(handles.fig_sol,'Visible','On');
set(handles.fig_norm,'Visible','On');
cla(handles.fig_sol,'reset')
cla(handles.fig_norm,'reset')

opts = pdeset;
defaultTol = opts.Eps;

a = str2num(get(handles.dom_left,'String'));
b = str2num(get(handles.dom_right,'String'));

% Extract information from the GUI fields
deInput = get(handles.input_DE,'String');
lbcInput = get(handles.input_LBC,'String');
rbcInput = get(handles.input_RBC,'String');
deRHSInput = get(handles.input_DE_RHS,'String');
lbcRHSInput = get(handles.input_LBC_RHS,'String');
rbcRHSInput = get(handles.input_RBC_RHS,'String');
guessInput = get(handles.input_GUESS,'String');
tolInput = get(handles.input_tol,'String');
tt = eval(get(handles.timedomain,'String'));

% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(lbcInput,'char'), lbcInput = cellstr(lbcInput); end
if isa(rbcInput,'char'), rbcInput = cellstr(rbcInput); end
if isa(deRHSInput,'char'), deRHSInput = cellstr(deRHSInput); end
if isa(lbcRHSInput,'char'), lbcRHSInput = cellstr(lbcRHSInput); end
if isa(rbcRHSInput,'char'), rbcRHSInput = cellstr(rbcRHSInput); end
% !!! Should do a error check to see whether lhs and rhs number of line
% match

% try           
    % Convert the input to the an. func. format, get information about the
    % linear function in the problem.
    [deString indVarName pdeflag] = setupFields(deInput,deRHSInput,'DE');  
    if ~pdeflag
        error('CHEBFUN:chebpde:notapde','Input does not appear to be a PDE, ', ...
            'or at least is not a supported type.');
    end
    idx = strfind(deString, ')');
    deString = [deString(1:idx(1)-1), ',t,x,diff', deString(idx(1):end)];
%     deString = strrep(deString,'diff','D');
    
    % Convert the string to proper anon. function using eval
    DE = eval(deString);
    
    if ~isempty(lbcInput{1})
        [lbcString indVarName] = setupFields(lbcInput,lbcRHSInput,'BC');
        idx = strfind(lbcString, ')');
        if ~isempty(idx)
            lbcString = [lbcString(1:idx(1)-1), ',t,x,diff', lbcString(idx(1):end)];
%             lbcString = strrep(lbcString,'diff','D');
        end
        LBC = eval(lbcString);
    else
        LBC = [];
    end
    if ~isempty(rbcInput{1}) 
        [rbcString indVarName] = setupFields(rbcInput,rbcRHSInput,'BC');
        idx = strfind(rbcString, ')');
        if ~isempty(idx)
            rbcString = [rbcString(1:idx(1)-1), ',t,x,diff', rbcString(idx(1):end)];
%             rbcString = strrep(rbcString,'diff','D');
        end
        RBC = eval(rbcString);
    else
        RBC = [];
    end
    
    if isempty(lbcInput) && isempty(rbcInput)
        error('chebfun:bvpgui','No boundary conditions specified');
    end

% catch
%     error(['chebfun:PDEgui','Incorrect input for differential ' ...
%         'equation or boundary conditions']);
% end

if isempty(tolInput)
    tolNum = defaultTol;
else
    tolNum = str2double(tolInput);
end

if tolNum < chebfunpref('eps')
    warndlg('Tolerance specified is less that current chebfun epsilon','Warning','modal');
    uiwait(gcf)
end

% Boundary condition
bc = struct( 'left', LBC, 'right', RBC);

% Set up the initial condition
if ischar(guessInput)
    guessInput = vectorize(guessInput);
    u0 =  chebfun(guessInput,[a b]);
else
    u0 = chebfun;
    for k = 1:numel(guessInput)
        guess_k = vectorize(guessInput{k});
        u0(:,k) =  chebfun(guess_k,[a b]);
    end
end

opts.HoldPlot = false;
opts.Eps = tolNum;
opts.guihandles = guihandles;

% error
% try
    [t u] = pde15s(DE,tt,u0,bc,opts);
% catch ME
%     errordlg('Error in solution process.', 'chebopbvp error', 'modal');
%     return
% end

% Store in handles latest chebop, solution, vector of norm of updates etc.
% (enables exporting later on)
handles.latestSolution = u;
handles.latestSolutionT = t;
% Notify the GUI we have a solution available
handles.hasSolution = 1;

axes(handles.fig_norm)
if ~iscell(u)
    surf(u,t,'facecolor','interp')
else
    surf(u{1},t,'facecolor','interp')
    xlabel('x'), ylabel('t')
    varnames = get(handles.input_DE_RHS,'string');
    idx = strfind(varnames{1},'_');
    varnames{k} = varnames{1}(1:idx(1)-1);
    v = varnames{1}(1:idx(1)-1);
    title(v),zlabel(v)
end

