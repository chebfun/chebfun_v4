function exportbvp2mfile(pathname,filename,handles)

fullFileName = [pathname,filename];
fid = fopen(fullFileName,'wt');


if ispc
    userName = getenv('UserName');
else
    userName = getenv('USER');
end


fprintf(fid,'%% %s - Executable .m file for solving a boundary value problem.\n',filename);
fprintf(fid,'%% Automatically created with from chebbvp GUI by user %s\n',userName);
fprintf(fid,'%% at %s on %s.\n\n',datestr(rem(now,1),13),datestr(floor(now)));

% Extract information from the GUI fields
a = get(handles.dom_left,'String');
b = get(handles.dom_right,'String');
deInput = get(handles.input_DE,'String');
lbcInput = get(handles.input_LBC,'String');
rbcInput = get(handles.input_RBC,'String');
deRHSInput = get(handles.input_DE_RHS,'String');
lbcRHSInput = get(handles.input_LBC_RHS,'String');
rbcRHSInput = get(handles.input_RBC_RHS,'String');
guessInput = get(handles.input_GUESS,'String');

% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(lbcInput,'char'), lbcInput = cellstr(lbcInput); end
if isa(rbcInput,'char'), rbcInput = cellstr(rbcInput); end
if isa(deRHSInput,'char'), deRHSInput = cellstr(deRHSInput); end
if isa(lbcRHSInput,'char'), lbcRHSInput = cellstr(lbcRHSInput); end
if isa(rbcRHSInput,'char'), rbcRHSInput = cellstr(rbcRHSInput); end

[deString indVarName] = setupFields(deInput,deRHSInput,'DE');

% Print the BVP
fprintf(fid,'%% Solving\n%%');
for k = 1:numel(deInput)
    fprintf(fid,'   %s = %s,\t',deInput{k},deRHSInput{k});
end
fprintf(fid,'\n');
fprintf(fid,'%% for %s in [%s,%s]',indVarName,a,b);
if ~isempty(lbcInput{1}) || ~isempty(rbcInput{1})
    fprintf(fid,',\n%% subject to\n%%');
    if  ~isempty(lbcInput{1})
        for k = 1:numel(lbcInput)
            fprintf(fid,'   %s = %s,\t',lbcInput{k},lbcRHSInput{k});
        end
        fprintf(fid,'at %s = % s\n',indVarName,a);
    end
    if  ~isempty(lbcInput{1}) && ~isempty(rbcInput{1})
        fprintf(fid,'%% and\n%%',indVarName,a);
    end
    if ~isempty(rbcInput{1})
        for k = 1:numel(rbcInput)
            fprintf(fid,'   %s = %s,\t',rbcInput{k},rbcRHSInput{k});
        end
        fprintf(fid,'at %s = % s\n',indVarName,b);
    end
    fprintf(fid,'\n');
else
    fprintf(fid,'.\n');
end

fprintf(fid,['%% Create a domain, the linear function on the domain and' ...
    ' a chebop \n%% that operates on function on the domain.\n']);
fprintf(fid,'[d,%s,N] = domain(%s,%s);\n',indVarName,a,b);

fprintf(fid,'\n%% Make an assignment to the differential eq. of the chebop.\n');
fprintf(fid,'N.op = %s;\n',deString);

% Setup for the rhs
fprintf(fid,'\n%% Set up the rhs of the differential equation\n');

% If we have a coupled system, we need create a array of the inputs
if size(deRHSInput,1) > 1
    deRHSprint = ['['];
    for deRHScounter = 1:size(deRHSInput,1)
        deRHSprint = [deRHSprint char(deRHSInput{deRHScounter}) ','];
    end
    deRHSprint(end) = []; % Remove the last comma
    deRHSprint = [deRHSprint,']'];
else
    deRHSprint = char(deRHSInput);
end
fprintf(fid,'rhs = %s;\n',deRHSprint);

% Make assignments for left and right BCs.


fprintf(fid,'\n%% Assign boundary conditions to the chebop.\n');
if ~isempty(lbcInput{1})
    lbcString = setupFields(lbcInput,lbcRHSInput,'BC');
    fprintf(fid,'N.lbc = %s;\n',lbcString);
end

if ~isempty(rbcInput{1})
    rbcString = setupFields(rbcInput,rbcRHSInput,'BC');
    fprintf(fid,'N.rbc = %s;\n',rbcString);
end

% Set up for the initial guess of the solution.
useLatest = strcmpi(guessInput,'Using latest solution');
if useLatest
    fprintf(fid,['\n%% Note that it is not possible to use the "Use latest"',...
        'option \n%% when exporting to .m files. \n']);
elseif ~isempty(guessInput)
    fprintf(fid,'\n%% Assign an initial guess to the chebop.\n');
    fprintf(fid,'N.guess = %s;\n',vectorize(char(guessInput)));
end

% Set up preferences
fprintf(fid,'\n%% Setup preferences for solving the problem \n');
fprintf(fid,'options = cheboppref;\n');

% Option for tolerance
tolInput = get(handles.input_tol,'String');

if ~isempty(tolInput)
    fprintf(fid,'\n%% Option for tolerance \n');
    fprintf(fid,'options.deltol = %s;\n',tolInput);
    fprintf(fid,'options.restol = %s;\n',tolInput);
end

fprintf(fid,'options.display = ''iter'';\n');

% Option for damping
dampedOnInput = get(handles.damped_on,'Value');

fprintf(fid,'\n%% Option for damping \n');
if dampedOnInput
    fprintf(fid,'options.damped = ''on'';\n');
else
    fprintf(fid,'options.damped = ''off'';\n');
end

% Option for plotting
plottingOnInput = get(handles.plotting_on,'Value');

fprintf(fid,'\n%% Option for determining how long each Newton step is shown\n');
if plottingOnInput
    pauseLengthInput = get(handles.input_pause,'String');
    fprintf(fid,'options.plotting = %s;\n',pauseLengthInput);
else
    fprintf(fid,'options.plotting = ''off'';\n');
end



fprintf(fid,['\n%% Solve the problem using solvebvp (a function which ' ...
    'offers same\n%% functionality as nonlinear backslash but more '...
    'customizeability) \n']);
fprintf(fid,'[u normVec] = solvebvp(N,rhs,options);\n');

fprintf(fid,'\n%% Create plot of the solution and the norm of the updates\n');




fprintf(fid,'figure\nplot(u),title(''Solution at the end of iteration'')\n');
fprintf(fid,'figure\nsemilogy(normVec,''-*''),title(''Norm of updates'')\n');
fprintf(fid,'xlabel(''Number of iteration'')\n');
fprintf(fid,...
    ['if length(normVec) > 1\n' ...
        '\tXTickVec = 1:max(floor(length(normVec)/5),1):length(normVec);\n'...
        '\tset(gca,''XTick'', XTickVec), xlim([1 length(normVec)]), grid on\n'...
    'else\n'...
    '   \tset(gca,''XTick'', 1)\n'...
    'end\n']);

fclose(fid);
end