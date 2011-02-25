function exportbvp2mfile(guifile,pathname,filename)

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

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
if isa(initInput,'char'), initInput = cellstr(initInput); end

deRHSInput = cellstr(repmat('0',numel(deInput),1));
lbcRHSInput = cellstr(repmat('0',numel(lbcInput),1));
rbcRHSInput = cellstr(repmat('0',numel(rbcInput),1));
initRHSInput = cellstr(repmat('0',numel(initInput),1));

[deString allVarString indVarNameDE ignored ignored allVarNames] = setupFields(guifile,deInput,deRHSInput,'DE');

% Do some error checking before we do further printing. Check that
% independent variable name match.
% Obtain the independent variable name appearing in the initial condition
useLatest = strcmpi(initInput{1},'Using latest solution');
if ~isempty(initInput{1}) && ~useLatest
    [initString ignored indVarNameInit] = setupFields(guifile,initInput,initRHSInput,'BC',allVarString);
else
    indVarNameInit = {''};
end

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

% Replace the 'DUMMYSPACE' variable in the DE field
deString = strrep(deString,'DUMMYSPACE',indVarNameSpace);

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
fprintf(fid,'%% for %s in [%s,%s]',indVarNameSpace,a,b);
if ~isempty(lbcInput{1}) || ~isempty(rbcInput{1})
    fprintf(fid,', subject to\n%%');
    if  ~isempty(lbcInput{1})
        if numel(lbcInput)==1 && ~any(lbcInput{1}=='=') && ~any(strcmpi(lbcInput{1},{'dirichlet','neumann'}))
            % Sort out when just function values are passed as bcs.
            lbcInput{1} = sprintf('%s = %s',allVarString,lbcInput{1});
        end
        fprintf(fid,'   ');
        for k = 1:numel(lbcInput)
            fprintf(fid,'%s',lbcInput{k});
            if k~=numel(lbcInput) && numel(lbcInput)>1, fprintf(fid,', '); end
        end
        fprintf(fid,' at %s = % s\n',indVarNameSpace,a);
    end
    if  ~isempty(lbcInput{1}) && ~isempty(rbcInput{1})
        fprintf(fid,'%% and\n%%',indVarNameSpace,a);
    end
    if ~isempty(rbcInput{1})
        if numel(rbcInput)==1 && ~any(rbcInput{1}=='=') && ~any(strcmpi(rbcInput{1},{'dirichlet','neumann'}))
            % Sort out when just function values are passed as bcs.
            rbcInput{1} = sprintf('%s = %s',allVarString,rbcInput{1});
        end
        fprintf(fid,'   ');
        for k = 1:numel(rbcInput)
            fprintf(fid,'%s',rbcInput{k});
            if k~=numel(rbcInput) && numel(rbcInput)>1, fprintf(fid,', '); end
        end
        fprintf(fid,' at %s = % s\n',indVarNameSpace,b);
    end
    fprintf(fid,'\n');
elseif periodic
    fprintf(fid,', subject to periodic boundary conditions.\n\n');
else
    fprintf(fid,'.\n');
end

% fprintf(fid,'%% Create the linear chebfun on the specified domain.\n');
% fprintf(fid,['%% Create a chebop on the specified domain.\n']);
% fprintf(fid,'N = chebop(%s,%s);\n',a,b);
% fprintf(fid,'\n%% Make an assignment to the differential eq. of the chebop.\n');
% fprintf(fid,'N.op = %s;\n',deString);

fprintf(fid,'%% Define the domain.\n');
fprintf(fid,'dom = [%s, %s];\n',a,b);

fprintf(fid,'\n%% Assign the differential equation to a chebop on that domain.\n');
fprintf(fid,'N = chebop(%s,dom);\n',deString);

% Setup for the rhs
fprintf(fid,'\n%% Set up the rhs of the differential equation so that N(%s) = rhs.\n',allVarString);

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
if useLatest
    fprintf(fid,['\n%% Note that it is not possible to use the "Use latest"',...
        'option \n%% when exporting to .m files. \n']);
elseif ~isempty(initInput{1})    
    fprintf(fid,'\n%% Construct a linear chebfun on the domain,\n');
    fprintf(fid,'%s = chebfun(@(%s) %s, dom);\n',indVarNameSpace,indVarNameSpace,indVarNameSpace);
    fprintf(fid,'%% and assign an initial guess to the chebop.\n');
%     fprintf(fid,'N.init = %s;\n',vectorize(char(initInput)));
    initInput = cellstr(initInput);
    if numel(initInput) == 1
        guessInput = vectorize(strtrim(char(initInput{1})));
        equalSign = find(guessInput=='=',1,'last');
        if ~isempty(equalSign)
            guessInput = guessInput(equalSign+1:end); 
        end
        fprintf(fid,'N.init = %s;\n',guessInput);
    else
        
        % To deal with 'u = ...' etc in intial guesses
        order = []; guesses = []; inits = [];
        % Match LHS of = with variables in allVarName
        for initCounter = 1:length(initInput)
            currStr = initInput{initCounter};
            equalSign = find(currStr=='=',1,'first');
            currVar = strtrim(currStr(1:equalSign-1));
            match = find(ismember(allVarNames, currVar)==1);
            order = [order;match];
            currInit = strtrim(currStr(1:equalSign-1));
            currGuess = vectorize(strtrim(currStr(equalSign+1:end)));
            guesses = [guesses;{currGuess}];
            inits = [inits;{currInit}];
        end
        [ignored order] = sort(order);
        initText = '_init';
        for k = 1:numel(initInput)
            fprintf(fid,'%s%s = %s;\n',inits{order(k)},initText,guesses{order(k)})
        end
        fprintf(fid,'N.init = [%s%s,',inits{order(1)},initText);
        for k = 2:numel(initInput)-1
            fprintf(fid,' %s%s,',inits{order(k)},initText);
        end
        fprintf(fid,' %s%s];\n',inits{order(end)},initText);

%         ws = '         ';
%         fprintf(fid,'N.init = [%s, ...\n',vectorize(char(initInput{1})));
%         for k = 2:numel(initInput)-1
%             fprintf(fid,'%s %s, ...\n',ws,vectorize(char(initInput{k})));
%         end
%         fprintf(fid,'%s %s];\n',ws,vectorize(char(initInput{end})),ws)
    end
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



fprintf(fid,['\n%% Solve the problem using solvebvp (a routine which ' ...
    'offers the same\n%% functionality as nonlinear backslash, but with more '...
    'customizability).\n']);
% fprintf(fid,'[u normVec] = solvebvp(N,rhs,''options'',options);\n');
fprintf(fid,'u = solvebvp(N,rhs,''options'',options);\n');

fprintf(fid,'\n%% Create plot of the solution and the norm of the updates.\n');


fprintf(fid,['figure\nplot(u,''LineWidth'',2)\ntitle(''Final solution''), ',...
    'xlabel(''%s'')'],indVarNameSpace);
if numel(allVarNames) == 1
    fprintf(fid,', ylabel(''%s'')',allVarNames{:});
else
    leg = '';
    for k = 1:numel(allVarNames)-1
        leg = [leg '''' allVarNames{k} '''' ','];
    end
    leg = [leg '''' allVarNames{k+1} ''''];
    fprintf(fid,', legend(%s)\n',leg);
end
fclose(fid);
end