function handles = solveGUIPDE(handles)
% Create a domain and the linear function on that domain. We use xt for the
% linear function, later in the code we will be able to determine whether x
% or t is used for the linear function.

guihandles = {handles.fig_sol,handles.fig_norm,handles.iter_text, ...
    handles.iter_list,handles.text_norm,handles.button_solve};
% set(handles.text_norm,'Visible','Off');
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

% DErhsNum = str2num(char(deRHSInput));
% if isempty(DErhsNum)
%     % RHS is a string representing a function -- convert to chebfun
%     DE_RHS = chebfun(DErhsInput,d);
% else
%     % RHS is a number - Don't need to construct chebfun
%     DE_RHS = DErhsNum;
% end
% 
% % DE_RHS = 0;
% useLatest = strcmpi(guessInput,'Using latest solution');
% if isempty(guessInput)
%     N = chebop(d,DE,LBC,RBC);
% elseif useLatest
%     guess = handles.latestSolution;
%     N = chebop(d,DE,LBC,RBC,guess);
% else
%     guess = eval(guessInput);
%     if isnumeric(guess)
%         guess = 0*xt+guess;
%     end
%     N = chebop(d,DE,LBC,RBC,guess);
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

% % Set the tolerance for the solution process
% options.deltol = tolNum;
% options.restol = tolNum;

% % Always display iter. information
% options.display = 'iter';

% dampedOnInput = get(handles.damped_on,'Value');
% plottingOnInput = get(handles.plotting_on,'Value');

% if dampedOnInput
%     options.damped = 'on';
% else
%     options.damped = 'off';
% end

% set(handles.iter_list,'String','');
% set(handles.iter_text,'Visible','On');
% set(handles.iter_list,'Visible','On');

% guidata(hObject, handles);
% if plottingOnInput
%     options.plotting = str2double(get(handles.input_pause,'String'));
% else
%     options.plotting = 'off';
% end

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

set(handles.button_solve,'Enable','On');
set(handles.button_solve,'String','Solve');

% Store in handles latest chebop, solution, vector of norm of updates etc.
% (enables exporting later on)
handles.latestSolution = u;
handles.latestSolutionT = t;
% handles.latestNorms = vec;
% handles.latestChebop = N;
% handles.latestRHS = DE_RHS;
% handles.latestOptions = options;

% Notify the GUI we have a solution available
handles.hasSolution = 1;

% Enable buttons
% set(handles.toggle_useLatest,'Enable','on');
set(handles.button_figures,'Enable','on');
% set(handles.text_norm,'Visible','On');

% axes(handles.fig_sol)
% plot(u)

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

% if length(vec) > 1
%     title('Solution at end of iteration')
% else
%     title('Solution');
% end
% axes(handles.fig_norm)
% semilogy(vec,'-*'),title('Norm of updates'), xlabel('Number of iteration')
% if length(vec) > 1
%     XTickVec = 1:max(floor(length(vec)/5),1):length(vec);
%     set(gca,'XTick', XTickVec), xlim([1 length(vec)]), grid on
% else % Don't display fractions on iteration plots
%     set(gca,'XTick', 1)
% end
