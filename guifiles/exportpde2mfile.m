function exportpde2mfile(pathname,filename,handles)

% disp('Export to .m file for PDEs is still under construction')
% 
% fullFileName = [pathname,filename];
% fid = fopen(fullFileName,'wt');
% 
% fprintf(fid,'%% Export to .m file for PDEs is still under construction');
% fclose(fid);


fullFileName = [pathname,filename];
fid = fopen(fullFileName,'wt');

if ispc
    userName = getenv('UserName');
else
    userName = getenv('USER');
end

fprintf(fid,'%% %s - Executable .m file for solving a PDE.\n',filename);
fprintf(fid,'%% Automatically created with from chebde GUI by user %s\n',userName);
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

tolInput = get(handles.input_tol,'String');
tt = get(handles.timedomain,'String');

% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(lbcInput,'char'), lbcInput = cellstr(lbcInput); end
if isa(rbcInput,'char'), rbcInput = cellstr(rbcInput); end
if isa(deRHSInput,'char'), deRHSInput = cellstr(deRHSInput); end
if isa(lbcRHSInput,'char'), lbcRHSInput = cellstr(lbcRHSInput); end
if isa(rbcRHSInput,'char'), rbcRHSInput = cellstr(rbcRHSInput); end

% [deString indVarName] = setupFields(deInput,deRHSInput,'DE');
[deString indVarName pdeflag] = setupFields(deInput,deRHSInput,'DE');  
if ~pdeflag
    error('CHEBFUN:chebpde:notapde','Input does not appear to be a PDE, ', ...
        'or at least is not a supported type.');
end
idx = strfind(deString, ')');
deString = [deString(1:idx(1)-1), ',t,x,diff', deString(idx(1):end)];

fprintf(fid,['%% Create a domain and the linear function on it.\n']);
fprintf(fid,'[d,%s] = domain(%s,%s);\n',indVarName,a,b);

fprintf(fid,['\n%% Construct a discretisation of the time domain to solve on.\n']);
fprintf(fid,'tt = %s;\n',tt);

fprintf(fid,'\n%% Make the rhs of the PDE.\n');
fprintf(fid,'pdefun = %s;\n',deString);

% % Setup for the rhs
% fprintf(fid,'\n%% Set up the rhs of the differential equation\n');
% fprintf(fid,'rhs = %s;\n',char(deRHSInput));

% Make assignments for left and right BCs.
fprintf(fid,'\n%% Assign boundary conditions.\n');
if ~isempty(lbcInput{1})
    [lbcString indVarName] = setupFields(lbcInput,lbcRHSInput,'BC');
    idx = strfind(lbcString, ')');
    if ~isempty(idx)
        lbcString = [lbcString(1:idx(1)-1), ',t,x,diff', lbcString(idx(1):end)];
%             lbcString = strrep(lbcString,'diff','D');
    end
    fprintf(fid,'bc.left = %s;\n',lbcString);
end

if ~isempty(rbcInput{1})
    [rbcString indVarName] = setupFields(rbcInput,rbcRHSInput,'BC');
    idx = strfind(rbcString, ')');
    if ~isempty(idx)
        rbcString = [rbcString(1:idx(1)-1), ',t,x,diff', rbcString(idx(1):end)];
%             rbcString = strrep(rbcString,'diff','D');
    end
    fprintf(fid,'bc.right = %s;\n',rbcString);
end

% Set up the initial condition
fprintf(fid,'\n%% Create a chebfun of the initial condition(s).\n');
if ischar(guessInput)
%     u0 =  chebfun(guessInput,[a b]);
    findx = strfind(guessInput,'x');
    if isempty(findx)
        fprintf(fid,'u0 = chebfun(%s,d);\n',guessInput);
    else
        fprintf(fid,'u0 = %s;\n',guessInput);
    end        
else
% %     u0 = chebfun;
%     fprintf(fid,'u0 = chebfun;\n');
%     for k = 1:numel(guessInput)
% %         u0(:,k) =  chebfun(guessInput{k},[a b]);
%         fprintf(fid,'u0(:,%d) = chebfun(%s,d);\n',k,guessInput{k});
%     end

    % Get the strings of the dependant variables.
    idx = strfind(deString,')');
    tmp = deString(3:idx(1)-10);
    idx = strfind(tmp,',');
    if isempty(idx)
        s = {tmp};
    else
        s = cell(1,length(idx)+1);
        s{1} = tmp(1:idx(1)-1);
        for k = 2:length(idx)
            s{k} = tmp(idx(k-1)+1:idx(k)-1);
        end
        if isempty(k), k = 1; end
        s{k+1} = tmp(idx(k)+1:end);
    end    
    
    % If the initial guesses are all constants, we need to wrap them in a
    % chebfun call.
    for k = 1:numel(guessInput)
        findx = strfind(guessInput{k},'x');
        if ~isempty(findx), break, end
    end
    
    % Print the conditions.
    catstr = [];
    for k = 1:numel(guessInput)
        if ~isempty(findx)
            fprintf(fid,'%s = %s;\n',s{k},guessInput{k});
        else
            fprintf(fid,'%s = chebfun(%s,d);\n',s{k},guessInput{k});
        end
        catstr = [catstr ', ' s{k}];
    end
    fprintf(fid,'u0 = [%s];\n',catstr(3:end));
end

% Option for tolerance
opts = [];
tolInput = get(handles.input_tol,'String');
opts = [opts,'''Eps''',',',tolInput];

% % Option for plotting
% plottingOnInput = get(handles.plotting_on,'Value');
% opts = [opts,'Eps, ',tolInput]

% fprintf(fid,'\n%% Option for determining how long each Newton step is shown\n');
% if plottingOnInput
%     pauseLengthInput = get(handles.input_pause,'String');
%     fprintf(fid,'options.plotting = %s;\n',pauseLengthInput);
% else
%     fprintf(fid,'options.plotting = ''off'';\n');
% end

% Set up preferences
fprintf(fid,'\n%% Setup preferences for solving the problem.\n');
fprintf(fid,'opts = pdeset');
if isempty(opts)
    fprintf(fid,';\n',opts);
else
    fprintf(fid,'(%s);\n',opts);
end

fprintf(fid,['\n%% Solve the problem using pde15s.\n']);
fprintf(fid,'[tt uu] = pde15s(pdefun,tt,u0,bc,opts);\n');

% plotting
if numel(deInput) == 1
    fprintf(fid,'\n%% Create plot of the solution.\n');
    fprintf(fid,'surf(uu,tt,''facecolor'',''interp'')\n');
else
    fprintf(fid,'\n%% Create plot of the solution.\n');
    fprintf(fid,'for k = 1:numel(uu)\n');
    fprintf(fid,'   subplot(1,numel(uu),k)\n');
     fprintf(fid,'   surf(uu{k},tt,''facecolor'',''interp'')\n');
    fprintf(fid,'end\n');
end

fclose(fid);
end