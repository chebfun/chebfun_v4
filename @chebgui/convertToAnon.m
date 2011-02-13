function varargout = convertToAnon(guifile,str)
% CONVERTTOANON Converts a string on 'natural syntax form' to an anonymous
% function Matlab can work with.

% In Matlab2007a and previous versions, the code runs into error if we
% don't clear the functions cache before running the code. Contacting
% technical support at Mathworks, they told me that this bug has been fixed
% for versions 2007b and onwards.
if verLessThan('matlab','7.5')
    clear functions
end

% Put the original string through the lexer
[lexOut varNames pdeVarNames eigVarNames indVarNames] = lexer(guifile,str);

% Check whether we have something like u" = u_t+v_t which we don't allow
if length(pdeVarNames) > 1
    error('Chebgui:convertToAnon:pdeVariables',...
        'Only one time derivative per line is allowed');
end
% Parse the output from the lexer, looking for syntax errors.
[syntaxTree pdeSign] = parse(guifile,lexOut);
% pdesign
% Obtain the prefix form.
prefixOut = tree2prefix(guifile,syntaxTree);

% If we're in PDE mode, we need to get rid of the u_t term. Replace them by
% a zero.
if strcmp(guifile.type,'pde') && ~isempty(pdeVarNames)
    pdevarLoc = find(ismember(prefixOut(:,2), 'PDEVAR')==1);
    prefixOut(pdevarLoc,1) = cellstr(repmat('0',length(pdevarLoc),1));
    prefixOut(pdevarLoc,2) = cellstr(repmat('NUM',length(pdevarLoc),1));
    
    % pdeSign tells us whether we need to flip the signs. Add a unitary -
    % at the beginning of the expression
    if pdeSign == 1 
        prefixOut = [{'-', 'UN-'}; prefixOut];
    end
end

% If we're in EIG mode, we want to replace lambda by 1
if strcmp(guifile.type,'eig') && ~isempty(eigVarNames)
    eigvarLoc = find(ismember(prefixOut(:,2), 'LAMBDA')==1);
    prefixOut(eigvarLoc,1) = cellstr(repmat('1',length(eigvarLoc),1));
    prefixOut(eigvarLoc,2) = cellstr(repmat('NUM',length(eigvarLoc),1));
end

% Return the derivative on infix form
infixOut = prefix2infix(guifile,prefixOut);

anFun = infixOut;
% Finally, remove unneeded parenthesis.
anFun = parSimp(guifile,anFun);

% Convert the cell array varNames into one string
varString = varNames{1};
for varCounter = 2:length(varNames)
    varString = [varString,',',varNames{varCounter}];
end
anFunComplete = ['@(', varString ') ' anFun];

switch nargout
    case 1
        varargout{1} = anFunComplete;
    case 2
        varargout{1} = anFunComplete;
        varargout{2} = indVarNames;
    case 3
        varargout{1} = anFun;
        varargout{2} = indVarNames;
        varargout{3} = varNames;
    case 4
        varargout{1} = anFun;
        varargout{2} = indVarNames;
        varargout{3} = varNames;
        varargout{4} = pdeVarNames;
end
end