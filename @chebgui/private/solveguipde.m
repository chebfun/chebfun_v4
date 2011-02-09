function varargout = solveguipde(guifile,handles)
% Create a domain and the linear function on that domain. We use xt for the
% linear function, later in the code we will be able to determine whether x
% or t is used for the linear function.

% Handles will be an empty variable if we are solving without using the GUI
if nargin < 2
    guiMode = 0;
else
    guiMode = 1;
end

opts = pdeset;
defaultTol = opts.Eps;
defaultLineWidth = 2;

if guiMode
    guihandles = {handles.fig_sol,handles.fig_norm,handles.iter_text, ...
        handles.iter_list,[],handles.button_solve};
    set(handles.fig_sol,'Visible','On');
    set(handles.fig_norm,'Visible','On');
    cla(handles.fig_sol,'reset')
    cla(handles.fig_norm,'reset')
end

% Extract information from the guifile
deInput = guifile.DE;
lbcInput = guifile.LBC;
rbcInput = guifile.RBC;
guessInput = guifile.init;
a = str2num(guifile.DomLeft);
b = str2num(guifile.DomRight);
tolInput = guifile.tol;
tt = str2num(guifile.timedomain);

% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(lbcInput,'char'), lbcInput = cellstr(lbcInput); end
if isa(rbcInput,'char'), rbcInput = cellstr(rbcInput); end

deRHSInput = cellstr(repmat('',numel(deInput),1));
lbcRHSInput = cellstr(repmat('0',numel(lbcInput),1));
rbcRHSInput = cellstr(repmat('0',numel(rbcInput),1));

% try           
    % Convert the input to the an. func. format, get information about the
    % linear function in the problem.
    [deString allVarString indVarName pdeVarName pdeflag allVarNames] = setupFields(guifile,deInput,deRHSInput,'DE');  
    handles.varnames = allVarNames;    
    if ~any(pdeflag)
        s = ['Input does not appear to be a PDE, ', ...
            'or at least is not a supported type. Perhaps you need to switch to ''ODE'' mode?'];
        errordlg(s, 'Chebgui error', 'modal');
        return
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
        lbcString = setupFields(guifile,lbcInput,lbcRHSInput,'BC',allVarString);
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
        rbcString = setupFields(guifile,rbcInput,rbcRHSInput,'BC',allVarString);
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
    bc = [];
    bc.left = LBC;
    bc.right = RBC;
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

opts.Plot = guifile.options.plotting;

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
opts.PlotStyle = ['linewidth,' num2str(defaultLineWidth)];
% plotstyle = get(handles.input_plotstyle,'String');
% if ~isempty(plotstyle)
%     opts.PlotStyle = [opts.PlotStyle ',' plotstyle] ;
% end

% Options for fixed N
if ~isempty(guifile.options.fixN)
    opts.N = str2num(guifile.options.fixN);
end       

if ~iscell(pdeVarName)
    pdeVarName = {pdeVarName};
end   
k = 0;
idx = [];
while isempty(idx)
    k = k+1;
    idx = strfind(pdeVarName{k},'_');
end
timeVarName = pdeVarName{k}((idx+1):end);
        
guihandles{7} = allVarNames;
guihandles{8} = {indVarName,timeVarName};
if guiMode, guihandles{9} = handles.button_clear; else guihandles{9} = 'nogui'; end
guihandles{10} = guifile.options.grid;
opts.guihandles = guihandles;

% error
% try
[t u] = pde15s(DE,tt,u0,bc,opts);
% catch ME
%     errordlg('Error in solution process.', 'chebopbvp error', 'modal');
%     return
% end

if ~guiMode
    varargout{1} = t;
    varargout{2} = u;
end

% Store in handles latest chebop, solution, vector of norm of updates etc.
% (enables exporting later on)
handles.latest.solution = u;
handles.latest.solutionT = t;
% Notify the GUI we have a solution available
handles.hasSolution = 1;

if guiMode, axes(handles.fig_norm), else figure, end

if ~iscell(u)
%     surf(u,t,'facecolor','interp')
    waterfall(u,t,'simple','linewidth',defaultLineWidth)
    xlabel(indVarName), ylabel(timeVarName), zlabel(allVarNames)
else
    
    cols = get(0,'DefaultAxesColorOrder');
    for k = 1:numel(u)
        plot(0,NaN,'linewidth',defaultLineWidth,'color',cols(k,:)), hold on
    end
    legend(allVarNames);
    for k = 1:numel(u)
        waterfall(u{k},t,'simple','linewidth',defaultLineWidth,'edgecolor',cols(k,:)), hold on
        xlabel(indVarName), ylabel('t')
    end
    view([322.5 30]), box off, grid on
    
    hold off
    
end

varargout{1} = handles;


