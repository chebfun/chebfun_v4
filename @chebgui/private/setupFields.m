function [field allVarString indVarName pdeVarNames pdeflag allVarNames]  = setupFields(guifile,input,rhs,type,allVarString)
numOfRows = max(size(input));%numel(input,1);
pdeflag = false;
allVarNames = [];

% Subtract what is to the rhs of equals signs in the input. Don't need to
% do this for the DE field of eig. problems
if ~(strcmp(guifile.type,'eig') && strcmp(type,'DE')) && ~strcmp(guifile.type,'bvp')
    input = subtractRhs(input);
end
% For BCs, we need to check whether varNames contains anything not found in
% varNames of the DE. Should we make the varNames of the DE as parameters?
% Setja DE varNames sem parametra? Also check for indVarName in deRHS.

% PDEFLAG is a binary output which is true or false depending on whether
% a '_' is located in rhs.

% [field indVarName]  = setupLine(input,rhs,type)
pdeVarName = '';
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
    if ~strcmp(guifile.type,'pde') && strcmp(type,'DE')
        field = ['@(',indVarName,',', allVarString ') ' anFun];
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
        allPdeVarNames = [allPdeVarNames;pdeVarNames];
    end
    % Remove duplicate variable names
    allVarNames = unique(allVarNames); 
    [allPdeVarNames I J] = unique(allPdeVarNames);
    
    if ~isempty(allPdeVarNames)
    % For PDEs we need to reorder so that the order of the time derivatives
    % matches the order of the input arguments. For this, we use the
    % indices returned from the unique method above. !!! Temporarily
    % experimental.
    indx = I;
    pdeflag = ones(1,numOfRows);
    else
        indx = (1:numOfRows)';
    end
    
    % Construct the function
    allAnFun = [];
    for k = 1:numOfRows
        allAnFun = [allAnFun, anFun{indx(k)},  ','];
    end
    allAnFun(end) = []; % Remove the last comma
    
    % Construct the handle part. For the DE field, we need to collect all
    % the variable names in one string. If we are working with BCs, we have
    % already passed that string in (as the parameter allVarString).
    if strcmp(type,'DE')
        allVarString = allVarNames{1};
        for varCounter = 2:length(allVarNames)
            allVarString = [allVarString,',',allVarNames{varCounter}];
        end
    end
    % If we are solving a BVP or EIG, we now need x as the first argument
    % as well. However, we don't want that variable in allVarString as we
    % use that information when setting up BCs.
    if ~strcmp(guifile.type,'pde') && strcmp(type,'DE')
        field = ['@(',indVarName,',', allVarString ') [' allAnFun,']'];
    else
        field = ['@(', allVarString ') [' allAnFun,']'];
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

function data = subtractRhs(data)
data = strtrim(data);
for k = 1:numel(data)
    idx = strfind(data{k},'=');
    if numel(idx)>1
        error('too many = signs');
    elseif ~isempty(idx)
        rhs = strtrim(data{k}(idx+1:end));
        data{k} = strtrim(data{k}(1:idx-1));
        numrhs = str2num(rhs);
        if ~isempty(numrhs) && numrhs == 0
            % Do nothing
        else % If not zero, subtract the rhs from the lhs
            data{k} = [data{k} '-(' rhs ')'];
        end
    end
end