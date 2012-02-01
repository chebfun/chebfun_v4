function varargout = solveguibvp(guifile,handles)
% SOLVEGUIBVP

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

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
dom = str2num(guifile.domain);
[d,xt] = domain(dom);

% Extract information from the GUI fields
deInput = guifile.DE;
bcInput = guifile.BC;
initInput = guifile.init;

% if isempty(bcInput)
%     error('Chebgui:bvpgui','No boundary conditions specified');
% end

% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(bcInput,'char'), bcInput = cellstr(bcInput); end
if isa(initInput,'char'), initInput = cellstr(initInput); end

% Convert the input to the an. func. format, get information about the
% linear function in the problem.
[deString allVarString indVarNameDE ignored ignored ignored allVarNames] = setupFields(guifile,deInput,'DE');
handles.varnames = allVarNames;

if ~isempty(bcInput{1})
    bcString = setupFields(guifile,bcInput,'BCnew',allVarString);
%     BC = eval(bcString);
else
    bcString = '';
    BC = [];
end

% Set up the initial guesses
guess = [];
% Find whether the user wants to use the latest solution as a guess. This is
% only possible when calling from the GUI
if guiMode
    useLatest = strcmpi(get(handles.input_GUESS,'String'),'Using latest solution');
    if useLatest
        guess = handles.latest.solution;
    end
end

% Obtain the independent variable name appearing in the initial condition
if ~isempty(initInput{1}) && isempty(guess)
    [initString ignored indVarNameInit] = setupFields(guifile,initInput,'BC',allVarString);
else
    indVarNameInit = {''};
end

% Assign r, x or t as the linear function on the domain if indVarName is
% not empty

% Make sure we don't have a disrepency in indVarNames
if ~isempty(indVarNameInit{1}) && ~isempty(indVarNameDE{1})
    if strcmp(indVarNameDE{1},indVarNameInit{1})
        indVarNameSpace = indVarNameDE{1};
    else
        error('Chebgui:SolveGUIbvp','Independent variable names do not agree')
    end
elseif ~isempty(indVarNameInit{1}) && isempty(indVarNameDE{1})
    indVarNameSpace = indVarNameInit{1};
elseif isempty(indVarNameInit{1}) && ~isempty(indVarNameDE{1})
    indVarNameSpace = indVarNameDE{1};
else
    indVarNameSpace = 'x'; % Default value
end
handles.indVarName = {indVarNameSpace};
eval([indVarNameSpace, '=xt;']);

% Replace the 'DUMMYSPACE' variable in the DE field
deString = strrep(deString,'DUMMYSPACE',indVarNameSpace);
% Convert the string to proper anon. function using eval
DE = eval(deString);

% Do the same in the .BC field if it isn't empty
if ~isempty(bcString)
    bcString = strrep(bcString,'DUMMYSPACE',indVarNameSpace);
    BC = eval(bcString);
end

if ~isempty(initInput{1}) && isempty(guess)
    if iscellstr(initInput)
        order = []; guesses = [];
        % Match LHS of = with variables in allVarNames
        for initCounter = 1:length(initInput)
            currStr = initInput{initCounter};
            equalSign = find(currStr=='=');
            currVar = strtrim(currStr(1:equalSign-1));
            match = find(ismember(allVarNames, currVar)==1);
            order = [order;match];
            currGuess = strtrim(currStr(equalSign+1:end));
            guesses = [guesses;{currGuess}];
        end
        
        guess = chebfun;
        for guessCounter = 1:length(guesses)
            guessLoc = find(order == guessCounter);
            tempGuess = eval(vectorize(guesses{guessLoc}));
            if isnumeric(tempGuess)
                tempGuess = 0*xt+tempGuess;
            end
            guess = [guess, tempGuess];
        end
    else
        guessInput = vectorize(initInput);
        equalSign = find(guessInput=='=');
        if isempty(equalSign), equalSign = 0; end
        guessInput = guessInput(equalSign+1:end);
        guess =  chebfun(guessInput,[a b]);
    end
end

% Create the chebop
if ~isempty(guess)
    N = chebop(d,DE,BC,guess);   
else
    N = chebop(d,DE,BC);
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
    
    xLimit = dom([1 end]);
    handles.xLim = xLimit;
    set(handles.fig_sol,'Visible','On');
    set(handles.fig_norm,'Visible','On');
end

% Call solvebvp with different arguments depending on whether we're in GUI
% or not. If we're not in GUI mode, we can finish here.
if guiMode
    [u vec isLinear] = solvebvp(N,0,'options',options,'guihandles',handles);
else
    [u vec] = solvebvp(N,DE_RHS,'options',options);
    varargout{1} = u;
    varargout{2} = vec;
end

% Now do some more stuff specific to GUI
if guiMode
    % Store in handles latest chebop, solution, vector of norm of updates etc.
    % (enables exporting later on)
    handles.latest.type = 'bvp';
    handles.latest.solution = u;
    handles.latest.norms = vec;
    handles.latest.chebop = N;
    handles.latest.options = options;
    handles.latest.type = 'bvp';
    % Notify the GUI we have a solution available
    handles.hasSolution = 1;
    
    axes(handles.fig_sol) 
    plot(u,'Linewidth',2)
    % Do different things depending on whether the solution is real or not
    if isreal(u)
        xlim(xLimit)
    else
        axis equal
    end
    if length(allVarNames) > 1, legend(allVarNames), end
    if guifile.options.grid
        grid on
    end
    if ~isLinear
        title('Solution at end of iteration')
    else
        title('Solution');
    end
    if ~isLinear
        axes(handles.fig_norm)
        semilogy(vec,'-*','Linewidth',2),title('Norm of updates'), xlabel('Iteration number')
        if length(vec) > 1
            XTickVec = 1:max(floor(length(vec)/5),1):length(vec);
            set(gca,'XTick', XTickVec), xlim([1 length(vec)]), grid on
        else % Don't display fractions on iteration plots
            set(gca,'XTick', 1)
        end
    else
        cla(handles.fig_norm,'reset')
    end
    
    % Return the handles as varargout.
    varargout{1} = handles;
end

end