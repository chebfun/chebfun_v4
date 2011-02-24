function [field allVarString indVarName pdeVarNames pdeflag allVarNames]  = setupFields(guifile,input,rhs,type,allVarString)
numOfRows = max(size(input));%numel(input,1);
pdeflag = zeros(1,numOfRows); % Binary flag for PDE detection.
allVarNames = [];
pdeVarNames = '';
dummys = 'DUMMYSPACE';
dummyt = 'DUMMYTIME';

% For BCs, we need to check whether varNames contains anything not found in
% varNames of the DE. Should we make the varNames of the DE as parameters?
% Setja DE varNames sem parametra? Also check for indVarName in deRHS.

% [field indVarName]  = setupLine(input,rhs,type)

if numOfRows == 1 % Not a system, can call convert2anon with two output arguments
    [anFun indVarName allVarNames pdeVarNames] = setupLine(guifile,input{1},rhs{1},type);
%     idx = strfind(rhs{1}, '_');
    % Check whether we have too many variables (this is a singl
    if ~isempty(pdeVarNames), % it's not a PDE (or we can't do this type yet!)
        pdeflag = true;
        % Check whether we have a match of variable names, i.e. we want u
        % and u_t, not u and v_t:
        if length(allVarNames) >1 || length(pdeVarNames) > 1
            error('Chebgui:setupFields:NumberOfVariables',...
                'Too many variables.');
        end
        underScoreLocation = strfind(pdeVarNames{1},'_');
        if ~strcmp(allVarNames{1},pdeVarNames{1}(1:underScoreLocation-1))
            error('Chebgui:setupFields:VariableNames',...
                'Inconsistent variable names.');
        end
%         allVarNames = {rhs{1}(1:idx-1)};
    end
    
    % Only need to convert the cell to a string for DE -- information has
    % been passed for BCs
    if strcmp(type,'DE')
        allVarString = allVarNames{1};
    end
    
    % Create the string which will become the anonymous function.
    % Put x (or t) as the first argument of the anonymous function if we
    % have a BVP or EIG.
    
    % !!! Check for a cell, make field a cell if we are in eigMode and
    % anFun is a cell.
    if strcmp(guifile.type,'eig') && iscell(anFun)
        field1 = ['@(',dummys,',', allVarString ') ' anFun{1}];
        field2 = ['@(',dummys,',', allVarString ') ' anFun{2}];
        field = {field1;field2};
    elseif ~strcmp(guifile.type,'pde') && strcmp(type,'DE')
        field = ['@(',dummys,',', allVarString ') ' anFun];
    % Otherwise, add variables in front of what will be anonymous
    % functions. This is not needed for 'dirichlet','neumann',etc... This
    % can only happen in BCs, and in that case, allVarNames will be empty
    elseif ~isempty(allVarNames)
        field = ['@(', allVarString ') ' anFun,''];
    else
        field = anFun;
    end
else % Have a system, go through each row
    % Keep track of every variable encountered in the problem
    allVarNames = {};
    allPdeVarNames = {};
    if numel(rhs) == 1, rhs = repmat(rhs,numOfRows,1); end
    for k = 1:numOfRows
        [anFun{k} indVarName varNames pdeVarNames] = setupLine(guifile,input{k},rhs{k},type);
        allVarNames = [allVarNames;varNames];
        if length(pdeVarNames) > 1 % Only allow one time derivative in each line
            error('Chebgui:setupField:TooManyTimeDerivatives',...
                'Only one time derivative per line allowed')
        end
        if isempty(pdeVarNames)
            pdeVarNames = '|';
        else
            pdeflag(k) = 1;
        end
        allPdeVarNames = [allPdeVarNames;pdeVarNames];
    end
    % Remove duplicate variable names
    allVarNames = unique(allVarNames); 
    
%     [allPdeVarNames I J] = unique(allPdeVarNames);
%     emptyPdeVarNames = strcmp(allPdeVarNames,'|');
%     allPdeVarNames(emptyPdeVarNames) = [];
%     pdeVarNames = allPdeVarNames;
%     if ~isempty(allPdeVarNames) && ~all(emptyPdeVarNames)
%          For this, we use the
%         % indices returned from the unique method above. !!! Temporarily
%         % experimental.
%         indx = J;
%         pdeflag = pdeflag(J);
%     else
%         indx = (1:numOfRows)';
%     end
    
    % Construct the handle part. For the DE field, we need to collect all
    % the variable names in one string. If we are working with BCs, we have
    % already passed that string in (as the parameter allVarString).
    if strcmp(type,'DE')
        allVarString = allVarNames{1};
        for varCounter = 2:length(allVarNames)
            allVarString = [allVarString,',',allVarNames{varCounter}];
        end
    end
    
    indx = (1:numOfRows)';
    % For PDEs we need to reorder so that the order of the time derivatives
    % matches the order of the input arguments.
    if any(pdeflag)
        for k = 1:numel(allPdeVarNames)
            if ~pdeflag(k), continue, end % Not a PDE variable, do nothing
            vark = allPdeVarNames{k};
            if strcmp(vark,'|'), continue, end % Skip dummy pdevarname
            vark = vark(1:find(vark=='_',1,'first')-1); % Get the kth pdevarname
            idx3 = find(strcmp(vark,allVarNames)); % Find which varname this matches
            indx(find(indx==idx3)) = indx(k); % Update the index list
            indx(k) = idx3;
        end
        [ignored indx] = sort(indx); % Invert the index
        pdeflag = pdeflag(indx); % Update the pdeflags
        allPdeVarNames(strcmp(allPdeVarNames,'|')) = []; % Delete the junk
        pdeVarNames = allPdeVarNames;
    end
    
    % If we are solving a BVP or EIG, we now need x as the first argument
    % as well. However, we don't want that variable in allVarString as we
    % use that information when setting up BCs. Create the string that goes
    % at the start of the final string.
    if ~strcmp(guifile.type,'pde') && strcmp(type,'DE')
        fieldStart = ['@(',dummys,',', allVarString ') '];%[' allAnFun,']'];
    else
        fieldStart = ['@(', allVarString ') '];% [' allAnFun,']'];
    end
        
    % Construct the function. Need to treat eig. problems separately as
    % there we can have nontrivial LHS and RHS at the same time.
    allAnFun = [];
    if strcmp(guifile.type,'eig') && iscell(anFun{1})
        allAnFun1 = []; allAnFun2 = [];
        for k = 1:numOfRows
            allAnFun1 = [allAnFun1, anFun{indx(k)}{1},  ','];
            allAnFun2 = [allAnFun2, anFun{indx(k)}{2},  ','];
        end
        allAnFun1(end) = []; allAnFun2(end) = []; % Remove the last comma
        
        % Set up LHS and RHS fields
        field1 = [fieldStart,'[',allAnFun1,']'];
        field2 = [fieldStart,'[',allAnFun2,']'];
        field = {field1;field2};
    else
        for k = 1:numOfRows
            allAnFun = [allAnFun, anFun{indx(k)},  ','];
        end
        allAnFun(end) = []; % Remove the last comma
        
        field = [fieldStart,'[' allAnFun,']'];
    end
    
end

function [field indVarName varNames pdeVarNames]  = setupLine(guifile,input,rhs,type)
convertBCtoAnon  = 0;

% Create the variables x and t (corresponding to the linear function on the
% domain).
% x = xt; t = xt;
if ~isempty(strfind(input,'@')) % User supplied anon. function
    % Find the name of the independent variable (which we assume to be
    % either x or t)
    
    varNames = symvar(input);
    xLoc = strcmp('x',varNames); varNames(xLoc) = [];
    tLoc = strcmp('t',varNames); varNames(tLoc) = [];
    
    % Return the name of the independent variable. Use x if none is found
    if sum(tLoc)
        indVarName = 't';
    else
        indVarName = 'x';
    end
    
    field = input;
    return
elseif strcmp(type,'BC')        % Allow more types of syntax for BCs
    bcNum = str2num(input);
    rhsNum = str2num(rhs);
    if isempty(rhsNum) && ~isempty(strfind(rhs,'t')), rhsNum = 1; end
    
    % Check whether we have a number (OK), allowed strings (OK) or whether
    % we will have to convert the string to anon. function (i.e. the input
    % is on the form u' +1 = 0).
    if ~isempty(bcNum)
        field = input;
        indVarName = []; % Don't need to worry about lin. func. in this case
        varNames = [];
        pdeVarNames = [];
    elseif strcmpi(input,'dirichlet') || strcmpi(input,'neumann') || strcmpi(input,'periodic')
        % Add extra 's to allow evaluation of the string
        field = ['''',input,''''];
        indVarName = []; % Don't need to worry about lin. func. in this case
        varNames = [];
        pdeVarNames = [];
    else
        if ~isempty(rhsNum) && rhsNum % If rhs = 0, don't make a subtraction
            input = [input ,'-(',rhs,')'];
        end
        convertBCtoAnon = 1;
    end
end

if  strcmp(type,'DE') || convertBCtoAnon   % Convert to anon. function string
%     if nargout == 2
%         [field indVarName] = convertToAnon(guifile,input);
%     else % Three output arguments -- Multiple rows
        [field indVarName varNames pdeVarNames] = convertToAnon(guifile,input);
%     end
end