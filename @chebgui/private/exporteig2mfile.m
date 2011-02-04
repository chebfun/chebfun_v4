function exportbvp2mfile(guifile,pathname,filename,handles)

fullFileName = [pathname,filename];
fid = fopen(fullFileName,'wt');

if ispc
    userName = getenv('UserName');
else
    userName = getenv('USER');
end

fprintf(fid,'%% %s - Executable .m file for solving an eigenvalue problem.\n',filename);
fprintf(fid,'%% Automatically created with from chebbvp GUI by user %s\n',userName);
fprintf(fid,'%% at %s on %s.\n\n',datestr(rem(now,1),13),datestr(floor(now)));

% Extract information from the GUI fields
a = guifile.DomLeft;
b = guifile.DomRight;
deInput = guifile.DE;
lbcInput = guifile.LBC;
rbcInput = guifile.RBC;

% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(lbcInput,'char'), lbcInput = cellstr(lbcInput); end
if isa(rbcInput,'char'), rbcInput = cellstr(rbcInput); end

deRHSInput = cellstr(repmat('0',numel(deInput),1));
lbcRHSInput = cellstr(repmat('0',numel(lbcInput),1));
rbcRHSInput = cellstr(repmat('0',numel(rbcInput),1));

[deString allVarString indVarName] = setupFields(guifile,deInput,deRHSInput,'DE');

% Print the BVP
fprintf(fid,'%% Solving\n%%');
for k = 1:numel(deInput)
    fprintf(fid,'   %s\t',deInput{k});
end
fprintf(fid,'\n');
fprintf(fid,'%% for %s in [%s,%s]',indVarName,a,b);
if ~isempty(lbcInput{1}) || ~isempty(rbcInput{1})
    fprintf(fid,',\n%% subject to\n%%');
    if  ~isempty(lbcInput{1})
        for k = 1:numel(lbcInput)
            fprintf(fid,'   %s,\t',lbcInput{k});
        end
        fprintf(fid,'at %s = % s\n',indVarName,a);
    end
    if  ~isempty(lbcInput{1}) && ~isempty(rbcInput{1})
        fprintf(fid,'%% and\n%%',indVarName,a);
    end
    if ~isempty(rbcInput{1})
        for k = 1:numel(rbcInput)
            fprintf(fid,'   %s,\t',rbcInput{k});
        end
        fprintf(fid,'at %s = % s\n',indVarName,b);
    end
    fprintf(fid,'\n');
else
    fprintf(fid,'.\n');
end

fprintf(fid,['%% Create a domain, the linear function on the domain and' ...
    ' a chebop \n%% that operates on functions on the domain.\n']);
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
    lbcString = setupFields(guifile,lbcInput,lbcRHSInput,'BC',allVarString);
    fprintf(fid,'N.lbc = %s;\n',lbcString);
end
if ~isempty(rbcInput{1})
    rbcString = setupFields(guifile,rbcInput,rbcRHSInput,'BC',allVarString);
    fprintf(fid,'N.rbc = %s;\n',rbcString);
end


% % Set up preferences
% fprintf(fid,'\n%% Setup preferences for solving the problem \n');
% fprintf(fid,'options = cheboppref;\n');
% Option for tolerance
% tolInput = guifile.tol;

fprintf(fid,'\n%% Number of eigenvalue and eigenmodes to compute.\n');
fprintf(fid,'k = 6;\n');

fprintf(fid,'\n%% Solve the eigenvalue problem.\n');
if ~isempty(guifile.sigma)
    fprintf(fid,'[V D] = eigs(N,k,%s);\n',guifile.sigma);
else
    fprintf(fid,'[V D] = eigs(N,k);\n');
end

fprintf(fid,'\n%% Plot the eigenvalues.\n');
fprintf(fid,'D = diag(D);\n');
fprintf(fid,'figure\n');
fprintf(fid,'plot(real(D),imag(D),''.'',''markersize'',25)\n');
fprintf(fid,'title(''Eigenvalues''); xlabel(''real''); ylabel(''imag'');\n');

if ischar(allVarString) || numel(allVarString) == 1
    fprintf(fid,'\n%% Plot the eigenmodes.\n');
    fprintf(fid,'figure\n');
    fprintf(fid,'plot(real(V),''linewidth'',2);\n');
    fprintf(fid,'title(''Eigenmodes''); xlabel(''%s''); ylabel(''%s'');\n',indVarName,allVarString);
end    

% fprintf(fid,'\n%% Option for determining how long each Newton step is shown\n');
% fprintf(fid,'options.plotting = %s;\n',plottingOnInput);
% 
% 
% 
% fprintf(fid,['\n%% Solve the problem using solvebvp (a function which ' ...
%     'offers same\n%% functionality as nonlinear backslash but more '...
%     'customizeability) \n']);
% fprintf(fid,'[u normVec] = solvebvp(N,rhs,''options'',options);\n');
% 
% fprintf(fid,'\n%% Create plot of the solution and the norm of the updates\n');
% 
% 
% 
% 
% fprintf(fid,'figure\nplot(u),title(''Solution at the end of iteration'')\n');
% fprintf(fid,'figure\nsemilogy(normVec,''-*''),title(''Norm of updates'')\n');
% fprintf(fid,'xlabel(''Number of iteration'')\n');
% fprintf(fid,...
%     ['if length(normVec) > 1\n' ...
%         '\tXTickVec = 1:max(floor(length(normVec)/5),1):length(normVec);\n'...
%         '\tset(gca,''XTick'', XTickVec), xlim([1 length(normVec)]), grid on\n'...
%     'else\n'...
%     '   \tset(gca,''XTick'', 1)\n'...
%     'end\n']);

fclose(fid);
end