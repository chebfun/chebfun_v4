function varargout = convertToAnon(str)
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
[lexOut varNames indVarNames] = lexer(str);
% Parse the output from the lexer, looking for syntax errors.
syntaxTree = parse(lexOut);
% Obtain the prefix form.
prefixOut = tree2prefix(syntaxTree);
% Return the derivative on infix form
infixOut = prefix2infix(prefixOut);
% Finally, remove unneeded parenthesis
anFun = parSimp(infixOut);

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