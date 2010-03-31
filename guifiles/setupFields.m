function [field indVarName]  = setupFields(input,rhs,type)
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
        if rhs % If rhs = 0, don't make a subtraction 
            input = [input ,'-',rhs];
        end
        convertBCtoAnon = 1;
    end
end

if  strcmp(type,'DE') || convertBCtoAnon   % Convert to anon. function string
    try
        [field indVarName] = convertToAnon(input);
    catch
        error(['chebfun:BVPgui','Incorrect input for differential ' ...
            'equation or boundary conditions']);
    end
end
end