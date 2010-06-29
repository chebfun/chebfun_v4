function varargout = convertToAnon(str)
%

% In Matlab2007a and previous versions, the code runs into error if we
% don't clear the functions cache before running the code. Contacting
% technical support at Mathworks, they told me that this bug has been fixed
% for versions 2007b and onwards.
% clear functions

if verLessThan('matlab','7.5')
    clear functions
end

% Put the original string through the lexer
[lexOut varNames indVarNames] = lexer(str);
% Parse the output from the lexer, looking for syntax errors.
syntaxTree = parse(lexOut);
% Obtain the prefix form.
prefixOut = tree2prefix(syntaxTree);
% Finally return the derivative on infix form
anFun = prefix2infix(prefixOut);

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
end
end