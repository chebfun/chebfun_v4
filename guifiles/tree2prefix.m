function prefixOut = tree2prefix(syntaxTree)
% TREE2PREFIX function takes in output from the parser and returns a array of
% strings containing the expression on prefix form. When we get into this
% function we have put the output through the parser so we don't have to
% worry about syntax errors.

% Begin by finding the center node of the (partial) syntax tree
nextCenter = syntaxTree.leafs.center;

% Find the type of the center node and the token itself
nextType = char(nextCenter(2));
nextSymbol = char(nextCenter(1));

% Make a switch on nextType and determine the action
switch nextType
    % The operators +-*/^ take in two arguments, one to the left and one to
    % the right.
    case {'OP+','OP-','OP*','OP/','OP^'}
        prefixOut = [{nextSymbol, nextType}; tree2prefix(syntaxTree.leafs.left); tree2prefix(syntaxTree.leafs.right)];
    % Unary operators only have one argument which is stored to the right
    case 'UN+'
        prefixOut = [{'+', 'UN+'}; tree2prefix(syntaxTree.leafs.right)];
    case 'UN-'
        prefixOut = [{'-', 'UN-'}; tree2prefix(syntaxTree.leafs.right)];
    % If we get a number or a variable we simply return that. Those types
    % are leafs so the don't have any childs
    case {'NUM', 'VAR', 'INDVAR'}
        prefixOut = {nextSymbol, nextType};
    % A function only has one argument which is to the right
    case 'FUNC'
        prefixOut = [{nextSymbol,'FUNC'}; tree2prefix(syntaxTree.leafs.right)];
    otherwise % Only possible token left is a derivative
        prefixOut = [{nextSymbol,nextType}; tree2prefix(syntaxTree.leafs.right)];
end