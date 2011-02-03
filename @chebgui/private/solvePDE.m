function handles = solveGUIPDE(guifile,handles)
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
tolInput = guifile.tol;
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
    [deString indVarName pdeflag allVarNames] = setupFields(guifile,deInput,deRHSInput,'DE');  
    handles.varnames = allVarNames;
    
    if ~any(pdeflag)
        error('CHEBFUN:chebpde:notapde','Input does not appear to be a PDE, ', ...
            'or at least is not a supported type.');
    end
    idx = strfind(deString, ')');
    
    % Support for sum and cumsum
    if ~isempty(strfind(deString(idx(1):end),'cumsum('));
        sops = {',sum,cumsum'};
    elseif ~isempty(strfind(deString(idx(1):end),'sum('));
        sops = {',sum'};
    else
        sops = {''};
    end
        
    deString = [deString(1:idx(1)-1), ',t,x,diff',sops{:},deString(idx(1):end)];
%     deString = strrep(deString,'diff','D');
    
    % Convert the string to proper anon. function using eval
    DE = eval(deString);
    
    % Support for periodic boundary conditions
    if (~isempty(lbcInput{1}) && strcmpi(lbcInput{1},'periodic')) || ...
            (~isempty(rbcInput{1}) && strcmpi(rbcInput{1},'periodic'))
        lbcInput{1} = []; rbcInput{1} = []; periodic = true;
    else
        periodic = false;
    end
    
    if ~isempty(lbcInput{1})
        [lbcString indVarName] = setupFields(guifile,lbcInput,lbcRHSInput,'BC');
        idx = strfind(lbcString, ')');
        if ~isempty(idx)
            
            % Support for sum and cumsum
            if ~isempty(strfind(lbcString(idx(1):end),'cumsum('));
                sops = {',sum,cumsum'};
            elseif ~isempty(strfind(lbcString(idx(1):end),'sum('));
                sops = {',sum'};
            else
                sops = {''};
            end
            
            lbcString = [lbcString(1:idx(1)-1), ',t,x,diff',sops{:},lbcString(idx(1):end)];
%             lbcString = strrep(lbcString,'diff','D');
        end
        LBC = eval(lbcString);
    else
        LBC = [];
    end
    if ~isempty(rbcInput{1}) 
        [rbcString indVarName] = setupFields(guifile,rbcInput,rbcRHSInput,'BC');
        idx = strfind(rbcString, ')');
        if ~isempty(idx)
            
            % Support for sum and cumsum
            if ~isempty(strfind(rbcString(idx(1):end),'cumsum('));
                sops = {',sum,cumsum'};
            elseif ~isempty(strfind(rbcString(idx(1):end),'sum('));
                sops = {',sum'};
            else
                sops = {''};
            end
            
            rbcString = [rbcString(1:idx(1)-1), ',t,x,diff',sops{:},rbcString(idx(1):end)];
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
    tolNum = str2num(tolInput);
end

if tolNum < chebfunpref('eps')
    warndlg('Tolerance specified is less than current chebfun epsilon','Warning','modal');
    uiwait(gcf)
end

% Boundary condition
if periodic
    bc = 'periodic';
else
    bc = struct( 'left', LBC, 'right', RBC);
end

% Set up the initial condition
tol = tolNum;
if ischar(guessInput)
    guessInput = vectorize(guessInput);
    u0 =  chebfun(guessInput,[a b]);
    u0 = simplify(u0,tol);
    lenu0 = length(u0);
else
    u0 = chebfun; 
    lenu0 = 0;
    for k = 1:numel(guessInput)
        guess_k = vectorize(guessInput{k});
        u0k = chebfun(guess_k,[a b]);
        u0k = simplify(u0k,tol);
        u0(:,k) =  u0k;
        lenu0 = max(lenu0,length(u0k));
    end
end

% gather options
opts.HoldPlot = false;
opts.Eps = tolNum;
if ~all(pdeflag)
    opts.PDEflag = pdeflag;
end
if get(handles.button_pdeploton,'Value')
    opts.Plot = 'on';
else
    opts.Plot = 'off';
end
if guifile.options.pdeholdplot
    opts.HoldPlot = 'on';
else
    opts.HoldPlot = 'off';
end
ylim1 = guifile.options.fixYaxisLower;
ylim2 = guifile.options.fixYaxisUpper;
if ~isempty(ylim1) && ~isempty(ylim2)
    opts.YLim = [str2num(ylim1) str2num(ylim2)];
end
opts.PlotStyle = get(handles.input_plotstyle,'String');    
if get(handles.checkbox_fixN,'Value')
    opts.N = str2num(get(handles.input_N,'String'));
%     if isempty(opts.N), opts.N = lenu0; end
    if isempty(opts.N), errordlg('N must be given.', 'Chebgui error', 'modal'); end
end
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
%     surf(u,t,'facecolor','interp')
    waterfall(u,t,'simple','linewidth',1)
else
%     surf(u{1},t,'facecolor','interp')
%     xlabel('x'), ylabel('t')
%     varnames = get(handles.input_DE_RHS,'string');
%     idx = strfind(varnames{1},'_');
%     varnames{k} = varnames{1}(1:idx(1)-1);
%     v = varnames{1}(1:idx(1)-1);
%     title(v),zlabel(v)
    
    
    cols = get(0,'DefaultAxesColorOrder');
    for k = 1:numel(u)
        waterfall(u{k},t,'simple','linewidth',1,'edgecolor',cols(k,:)), hold on
        xlabel('x'), ylabel('t')
    end
    hold off
    
    
    
    
    
    
end

