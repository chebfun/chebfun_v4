function exportpde2mfile(guifile,pathname,filename)

fullFileName = [pathname,filename];
fid = fopen(fullFileName,'wt');

if ispc
    userName = getenv('UserName');
else
    userName = getenv('USER');
end

fprintf(fid,'%% %s - an executable M-file file for solving a PDE.\n',filename);
fprintf(fid,'%% Automatically created from chebfun/chebgui by user %s\n',userName);
fprintf(fid,'%% %s, %s.\n\n',datestr(rem(now,1),13),datestr(floor(now)));

% Extract information from the GUI fields
a = guifile.DomLeft;
b = guifile.DomRight;
deInput = guifile.DE;
lbcInput = guifile.LBC;
rbcInput = guifile.RBC;
deRHSInput = 'u_t';
initInput = guifile.init;
tt = guifile.timedomain;

xName = 'x';
tName = 't';


% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(lbcInput,'char'), lbcInput = cellstr(lbcInput); end
if isa(rbcInput,'char'), rbcInput = cellstr(rbcInput); end
if isa(deRHSInput,'char'), deRHSInput = cellstr(deRHSInput); end

% deRHSInput = cellstr(repmat('0',numel(deInput),1));
lbcRHSInput = cellstr(repmat('0',numel(lbcInput),1));
rbcRHSInput = cellstr(repmat('0',numel(rbcInput),1));

% [deString indVarName] = setupFields(deInput,deRHSInput,'DE');
[deString allVarString indVarName pdeVarName pdeflag allVarNames] = setupFields(guifile,deInput,deRHSInput,'DE');
if ~any(pdeflag)
    error('CHEBFUN:chebpde:notapde',['Input does not appear to be a PDE, ', ...
        'or at least is not a supported type.']);
end

idx = strfind(deString, ')');

% Support for sum and cumsum
sops = {''};
if ~isempty(strfind(deString(idx(1):end),'cumsum('));
    sops = {',sum,cumsum'};
elseif ~isempty(strfind(deString(idx(1):end),'sum('));
    sops = {',sum'};
else
    sops = {''};
end

% Support for periodic boundary conditions
if (~isempty(lbcInput{1}) && strcmpi(lbcInput{1},'periodic')) || ...
        (~isempty(rbcInput{1}) && strcmpi(rbcInput{1},'periodic'))
    lbcInput{1} = []; rbcInput{1} = []; periodic = true;
else
    periodic = false;
end

deString = [deString(1:idx(1)-1), ',t,x,diff',sops{:},deString(idx(1):end)];

% Print the PDE
fprintf(fid,'%% Solving\n');
for k = 1:numel(deInput)
    fprintf(fid,'%%   %s,\n',deInput{k});
end
tmpt = eval(tt); 
fprintf(fid,'%% for %s in [%s,%s] and %s in [%s,%s]',xName,a,b,tName,num2str(tmpt(1)),num2str(tmpt(end)));
if ~isempty(lbcInput{1}) || ~isempty(rbcInput{1})
    fprintf(fid,', subject to\n%%');
    if ~isempty(lbcInput{1})
        if numel(lbcInput)==1 && ~any(lbcInput{1}=='=') && ~any(strcmpi(lbcInput{1},{'dirichlet','neumann'}))
            % Sort out when just function values are passed as bcs.
            lbcInput{1} = sprintf('%s = %s',allVarString,lbcInput{1});
        end      
        fprintf(fid,'   ');
        for k = 1:numel(lbcInput)
            fprintf(fid,'%s',lbcInput{k});
            if k~=numel(lbcInput) && numel(lbcInput)>1, fprintf(fid,', '); end
        end
        fprintf(fid,' at %s = % s\n',xName,a);
    end
    if  ~isempty(lbcInput{1}) && ~isempty(rbcInput{1})
        fprintf(fid,'%% and\n%%',xName,a);
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
        fprintf(fid,' at %s = % s\n',xName,b);
    end
    fprintf(fid,'\n');
elseif periodic
    fprintf(fid,', subject to periodic boundary conditions.\n\n');
else
    fprintf(fid,'.\n');
end

% fprintf(fid, '%% Create a domain and the linear function on it.\n');
% fprintf(fid,'[d,%s] = domain(%s,%s);\n',indVarName,a,b);
% fprintf(fid,['\n%% Construct a discretisation of the time domain to solve on.\n']);
% fprintf(fid,'t = %s;\n',tt);

fprintf(fid, '%% Create an interval of the space domain,\n');
fprintf(fid,'dom = [%s,%s];\n',a,b);
fprintf(fid,'%% and a discretisation of the time domain.\n');
fprintf(fid,'%s = %s;\n',tName,tt);

fprintf(fid,'\n%% Make the rhs of the PDE.\n');
fprintf(fid,'pdefun = %s;\n',deString);

% Make assignments for left and right BCs.
fprintf(fid,'\n%% Assign boundary conditions.\n');
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
        lbcString = [lbcString(1:idx(1)-1), ',t,x,diff', sops{:},lbcString(idx(1):end)];
%             lbcString = strrep(lbcString,'diff','D');
    end
    fprintf(fid,'bc.left = %s;\n',lbcString);
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
    fprintf(fid,'bc.right = %s;\n',rbcString);
end

if periodic
    fprintf(fid,'bc = ''periodic'';\n');
end

% Set up the initial condition
fprintf(fid,'\n%% Construct a linear chebfun on the domain,\n');
fprintf(fid,'%s = chebfun(@(%s) %s, dom);\n',xName,xName,xName);
if iscell(initInput) && numel(initInput) > 1
    fprintf(fid,'%% and of the initial conditions.\n');
else
    fprintf(fid,'%% and of the initial condition.\n');
end
if numel(deInput)==1 && ~ischar(deInput)
    % Get the strings of the dependant variable.
    idx = strfind(deString,')');
    tmp = deString(3:idx(1)-10);
    idx = strfind(tmp,',');
    if isempty(idx)
        s = tmp;
    else
        s = tmp(1:idx(1)-1);
    end 
    sol = s; sol0 = [sol '0'];
    findx = strfind(initInput,xName);
    initInput = vectorize(char(initInput));
    equalSign = find(initInput=='=',1,'last');
    if ~isempty(equalSign)
        initInput = strtrim(initInput(equalSign+1:end)); 
    end
    if isempty(findx)
        fprintf(fid,'%s = chebfun(%s,dom);\n',sol0,initInput);
    else
        fprintf(fid,'%s = %s;\n',sol0,vectorize(initInput));
    end        
else
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
    
    % To deal with 'u = ...' etc in intial guesses
    order = []; guesses = []; inits = [];
    % Match LHS of = with variables in allVarNa
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
    
    % If the initial guesses are all constants, we need to wrap them in a
    % chebfun call.
    for k = 1:numel(initInput)
        findx = strfind(initInput{k},'x');
        if ~isempty(findx), break, end
    end
    if isempty(findx)
        for k = 1:numel(initInput)
            guesses{k} = sprintf('chebfun(%s,dom)',guesses{k});
        end
    end
    
    % These can be changed
    initText = '0'; sol0 = 'sol0'; sol = 'sol';
    
    for k = 1:numel(initInput)
        fprintf(fid,'%s%s = %s;\n',inits{order(k)},initText,guesses{order(k)});
    end
    fprintf(fid,'%s = [%s%s,',sol0,inits{order(1)},initText);
    for k = 2:numel(initInput)-1
        fprintf(fid,' %s%s,',inits{order(k)},initText);
    end
    fprintf(fid,' %s%s];\n',inits{order(end)},initText);
    
%     % If the initial guesses are all constants, we need to wrap them in a
%     % chebfun call.
%     for k = 1:numel(initInput)
%         findx = strfind(initInput{k},'x');
%         if ~isempty(findx), break, end
%     end
%     % Print the conditions.
%     catstr = [];
%     for k = 1:numel(initInput)
%         if ~isempty(findx)
%             fprintf(fid,'%s = %s;\n',s{k},vectorize(initInput{k}));
%         else
%             fprintf(fid,'%s = chebfun(%s,dom);\n',s{k},initInput{k});
%         end
%         catstr = [catstr ', ' s{k}];
%     end
%     sol0 = 'sol0'; sol = 'sol';
%     fprintf(fid,'%s = [%s];',sol0,catstr(3:end));
%     if isempty(catstr(3:end)),
%         fprintf(fid,'\t%% An initial condition is required!');
%     end
%     fprintf(fid,'\n');
end

% Option for tolerance
opts = [];
tolInput = guifile.tol;
opts = [opts,'''Eps'',',tolInput];

if ~all(pdeflag)
    opts = [opts,',''PDEflag'',','[',num2str(pdeflag),']'];
end

% Options for plotting
doplot = guifile.options.plotting;
if strcmpi(doplot,'off')
    opts = [opts,',''Plot'',','''off'''];
else
    dohold = guifile.options.pdeholdplot;
    if dohold
        opts = [opts,',''HoldPlot'',','''on'''];
    end
    ylim1 = guifile.options.fixYaxisLower;
    ylim2 = guifile.options.fixYaxisUpper;
    if ~isempty(ylim1) && ~isempty(ylim2)
        opts = [opts,',''Ylim'',[',ylim1,',',ylim2,']'];
    end
%     plotstyle = get(handles.input_plotstyle,'String');
%     if ~isempty(plotstyle)
%         opts = [opts,',''PlotStyle'',''',plotstyle,''''];
%     end
end

% Options for fixed N
if ~isempty(guifile.options.fixN)
    N = str2num(guifile.options.fixN);
    opts = [opts,',''N'',',N];
end        

% Set up preferences
fprintf(fid,'\n%% Setup preferences for solving the problem.\n');
fprintf(fid,'opts = pdeset');
if isempty(opts)
    fprintf(fid,';\n',opts);
else
    fprintf(fid,'(%s);\n',opts);
end

fprintf(fid,['\n%% Solve the problem using pde15s.\n']);
fprintf(fid,'[t %s] = pde15s(pdefun,t,%s,bc,opts);\n',sol,sol0);

% Conver sol to variable names
if numel(deInput) > 1
    fprintf(fid,'\n%% Recover variable names.\n');
    for k = 1:numel(s)
        fprintf(fid,'%s = %s{%d};\n',s{k},sol,k);
    end
end

% plotting
if numel(deInput) == 1
    fprintf(fid,'\n%% Create plot of the solution.\n');
%     fprintf(fid,'surf(%s,t,''facecolor'',''interp'')\n',sol);
    fprintf(fid,'waterfall(%s,t,''simple'',''linewidth'',2)\n',sol);
else
    fprintf(fid,'\n%% Create plots of the solutions.\n');
%     fprintf(fid,'for k = 1:numel(%s)\n',sol);
%     fprintf(fid,'   subplot(1,numel(%s),k)\n',sol);
%      fprintf(fid,'   surf(sol{k},t,''facecolor'',''interp'')\n');
%     fprintf(fid,'end\n');
    M = numel(deInput);
    for k = 1:numel(deInput)
        fprintf(fid,'subplot(1,%d,%d)\n',M,k);
        fprintf(fid,'waterfall(%s,t,''linewidth'',2)\n',s{k});
        fprintf(fid,'xlabel(''x''), ylabel(''t''), title(''%s'')\n',s{k});
    end
end

fclose(fid);
end