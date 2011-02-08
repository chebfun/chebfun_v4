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
[lexOut varNames pdeVarNames indVarNames] = lexer(guifile,str);

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
% Return the derivative on infix form
infixOut = prefix2infix(guifile,prefixOut);

% If we're in PDE mode, we need to get rid of the u_t term
if strcmp(guifile.type,'pde') && ~isempty(pdeVarNames)
    timeDerivLocation = strfind(infixOut,pdeVarNames{1});
    if pdeSign == -1
%         infixOut(timeDerivLocation:timeDerivLocation+length(pdeVarNames{1})-1) = [];
        infixOut = strrep(infixOut,pdeVarNames{1},'0');
    else
%         infixOut(timeDerivLocation:timeDerivLocation+length(pdeVarNames{1})-1) = [];
        infixOut = strrep(infixOut,pdeVarNames{1},'0');
        infixOut = ['-(',infixOut,')']; % Need to a a - in front of the whole string
    end
end
% Finally, remove unneeded parenthesis -- Temporarily disabled
anFun = parSimp(guifile,infixOut);
% anFun = infixOut;

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