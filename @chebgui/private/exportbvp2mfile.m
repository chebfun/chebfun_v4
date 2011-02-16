function exportbvp2mfile(guifile,pathname,filename)

fullFileName = [pathname,filename];
fid = fopen(fullFileName,'wt');

if ispc
    userName = getenv('UserName');
else
    userName = getenv('USER');
end

fprintf(fid,'%% %s - an executable M-file file for solving a boundary value problem.\n',filename);
fprintf(fid,'%% Automatically created from chebfun/chebgui by user %s\n',userName);
fprintf(fid,'%% at %s on %s.\n\n',datestr(rem(now,1),13),datestr(floor(now)));

% Extract information from the GUI fields
a = guifile.DomLeft;
b = guifile.DomRight;
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

[deString allVarString indVarName] = setupFields(guifile,deInput,deRHSInput,'DE');

% Support for periodic boundary conditions
if (~isempty(lbcInput{1}) && strcmpi(lbcInput{1},'periodic')) || ...
        (~isempty(rbcInput{1}) && strcmpi(rbcInput{1},'periodic'))
    lbcInput{1} = []; rbcInput{1} = []; periodic = true;
else
    periodic = false;
end

% Print the BVP
fprintf(fid,'%% Solving\n');
for k = 1:numel(deInput)
    fprintf(fid,'%%   %s,\n',deInput{k});
end
fprintf(fid,'%% for %s in [%s,%s]',indVarName,a,b);
if ~isempty(lbcInput{1}) || ~isempty(rbcInput{1})
    fprintf(fid,', subject to\n%%');
    if  ~isempty(lbcInput{1})
        if numel(lbcInput)==1 && ~any(lbcInput{1}=='=') && ~any(strcmpi(lbcInput{1},{'dirichlet','neumann','periodic'}))
            % Sort out when just function values are passed as bcs.
            lbcInput{1} = sprintf('%s = %s',allVarString,lbcInput{1});
        end
        fprintf(fid,'   ');
        for k = 1:numel(lbcInput)
            fprintf(fid,'%s',lbcInput{k});
            if k~=numel(lbcInput) && numel(lbcInput)>1, fprintf(fid,', '); end
        end
        fprintf(fid,' at %s = % s\n',indVarName,a);
    end
    if  ~isempty(lbcInput{1}) && ~isempty(rbcInput{1})
        fprintf(fid,'%% and\n%%',indVarName,a);
    end
    if ~isempty(rbcInput{1})
        if numel(rbcInput)==1 && ~any(rbcInput{1}=='=') && ~any(strcmpi(rbcInput{1},{'dirichlet','neumann','periodic'}))
            % Sort out when just function values are passed as bcs.
            rbcInput{1} = sprintf('%s = %s',allVarString,rbcInput{1});
        end
        fprintf(fid,'   ');
        for k = 1:numel(rbcInput)
            fprintf(fid,'%s',rbcInput{k});
            if k~=numel(rbcInput) && numel(rbcInput)>1, fprintf(fid,', '); end
        end
        fprintf(fid,' at %s = % s\n',indVarName,b);
    end
    fprintf(fid,'\n');
elseif periodic
    fprintf(fid,', subject to periodic boundary conditions.\n\n');
else
    fprintf(fid,'.\n');
end

fprintf(fid,'%% Create the linear chebfun on the specified domain.\n');
fprintf(fid,'%s = chebfun(''x'',[%s %s]);\n',indVarName,a,b);

fprintf(fid,['%% Create a chebop on the specified domain.\n']);
fprintf(fid,'N = chebop(%s,%s);\n',a,b);

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
    lbcString = setupFields(guifile,lbcInput,lbcRHSInput,'BC',allVarString );
    fprintf(fid,'N.lbc = %s;\n',lbcString);
end
if ~isempty(rbcInput{1})
    rbcString = setupFields(guifile,rbcInput,rbcRHSInput,'BC',allVarString );
    fprintf(fid,'N.rbc = %s;\n',rbcString);
end
if periodic
    fprintf(fid,'N.bc = ''periodic'';\n');
end

% Set up for the initial guess of the solution.
useLatest = strcmpi(initInput,'Using latest solution');
if useLatest
    fprintf(fid,['\n%% Note that it is not possible to use the "Use latest"',...
        'option \n%% when exporting to .m files. \n']);
elseif ~isempty(initInput)
    fprintf(fid,'\n%% Assign an initial guess to the chebop.\n');
    fprintf(fid,'N.guess = %s;\n',vectorize(char(initInput)));
end

% Set up preferences
fprintf(fid,'\n%% Setup preferences for solving the problem.\n');
fprintf(fid,'options = cheboppref;\n');

% Option for tolerance
tolInput = guifile.tol;

if ~isempty(tolInput)
    fprintf(fid,'\n%% Option for tolerance.\n');
    fprintf(fid,'options.deltol = %s;\n',tolInput);
    fprintf(fid,'options.restol = %s;\n',tolInput);
end

fprintf(fid,'options.display = ''iter'';\n');

% Option for damping
dampedOnInput = guifile.options.damping;

fprintf(fid,'\n%% Option for damping.\n');
if strcmp(dampedOnInput,'1')
    fprintf(fid,'options.damped = ''on'';\n');
else
    fprintf(fid,'options.damped = ''off'';\n');
end

% Option for plotting
plottingOnInput = guifile.options.plotting;

if ~strcmp(plottingOnInput,'off')
    fprintf(fid,'\n%% Option for determining how long each Newton step is shown.\n');
    fprintf(fid,'options.plotting = %s;\n',plottingOnInput);
else
    fprintf(fid,'\n%% Option for determining how long each Newton step is shown.\n');
    fprintf(fid,'options.plotting = ''off'';\n');
end



fprintf(fid,['\n%% Solve the problem using solvebvp (a function which ' ...
    'offers same\n%% functionality as nonlinear backslash but more '...
    'customizeability).\n']);
fprintf(fid,'[u normVec isLinear] = solvebvp(N,rhs,''options'',options);\n');

fprintf(fid,'\n%% Create plot of the solution and the norm of the updates.\n');




fprintf(fid,'figure\nplot(u,''LineWidth'',2),title(''Solution at the end of iteration'')\n');
fprintf(fid,'if ~isLinear\n\tfigure\n\tsemilogy(normVec,''-*''),title(''Norm of updates'')\n');
fprintf(fid,'\txlabel(''Number of iteration'')\n');
fprintf(fid,...
    ['\tif length(normVec) > 1\n' ...
        '\t\tXTickVec = 1:max(floor(length(normVec)/5),1):length(normVec);\n'...
        '\t\tset(gca,''XTick'', XTickVec), xlim([1 length(normVec)]), grid on\n'...
    '\telse\n'...
    '   \t\tset(gca,''XTick'', 1)\n'...
    '\tend\nend\n']);

fclose(fid);
end