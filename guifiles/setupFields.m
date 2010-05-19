function [field indVarName pdeflag allVarNames]  = setupFields(input,rhs,type)

numOfRows = size(input,1);
pdeflag = false;

% Fyrir BCs tharf ad tekka hvort ad varNames innihaldi e-d sem er ekki i DE
% varNames. Setja DE varNames sem parametra? Tekka a indVarName i deRHS
% lika.

% PDEFLAG is a binary output which is true or false depending on whether
% a '_' is located in rhs.

% [field indVarName]  = setupLine(input,rhs,type)

if numOfRows == 1 % Not a system, can call convert2anon with two output arguments
    [field indVarName] = setupLine(input{1},rhs{1},type);
    idx = strfind(rhs{1}, '_');
    if ~isempty(idx), % it's not a PDE (or we can't do this type yet!)
        pdeflag = true;
        allVarNames = {rhs{1}(1:idx-1)};
    end
else
    % Keep track of every variable encountered in the problem
    allVarNames = {};
    if numel(rhs) == 1, rhs = repmat(rhs,numOfRows,1); end
    for k = 1:numOfRows
        [anFun{k} indVarName varNames] = setupLine(input{k},rhs{k},type);
        allVarNames = [allVarNames;varNames];
    end
    allVarNames = unique(allVarNames); % Remove duplicate variable names
    
    % For PDEs we need to reorder so that the order of the time derivatives
    % matches the order of the inout arguments.
    indx = (1:numOfRows)';
    pdeflag = ones(1,numOfRows);
    for k = 1:numOfRows
        rhsk = rhs{k};
        idxk = strfind(rhsk, '_');
        if isempty(idxk), % it's not a PDE (or we can't do this type yet!)
            indx = 1:numOfRows;
            pdeflag(k) = false;
            dvark = '';
        else
            dvark = rhsk(1:idxk(1)-1);
        end
        if strcmp(type,'DE')
            for j = 1:numOfRows
                if strcmp(dvark,allVarNames{j})
                    indx(j) = k;
                    indx(k) = j;
                    break
                end
            end
        end
    end
    
    % Construct the function
    allAnFun = [];
    for k = 1:numOfRows
        allAnFun = [allAnFun, anFun{indx(k)},  ','];
    end
    allAnFun(end) = []; % Remove the last comma
    
    % Construct the handle part
    allVarString = allVarNames{1};
    for varCounter = 2:length(allVarNames)
        allVarString = [allVarString,',',allVarNames{varCounter}];
    end
    
    field = ['@(', allVarString ')[' allAnFun,']'];
end

end

function [field indVarName varNames]  = setupLine(input,rhs,type)
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
    elseif strcmpi(input,'dirichlet') || strcmpi(input,'neumann')
        % Add extra 's to allow evaluation of the string
        field = ['''',input,''''];
        indVarName = []; % Don't need to worry about lin. func. in this case
    else
        if ~isempty(rhsNum) && rhsNum % If rhs = 0, don't make a subtraction
            input = [input ,'-(',rhs,')'];
        end
        convertBCtoAnon = 1;
    end
end

if  strcmp(type,'DE') || convertBCtoAnon   % Convert to anon. function string
    if nargout == 2
        [field indVarName] = convertToAnon(input);
    else % Three output arguments -- Multiple rows
        [field indVarName varNames] = convertToAnon(input);
    end
end
end