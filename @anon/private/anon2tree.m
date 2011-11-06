function t = anon2tree(an,varName)

% Access variables (and the number of them) in the workspace of the input
% anon
variablesVec = 1:length(an.variablesName);
varNames = an.variablesName;
workspace = an.workspace;


% Store the anon in the info field of the structure. To disply more
% informative strings, we need to know the name of the input variable if
% possible (otherwise, all first lines will be of the form diff(an,u) = ...

% Attempt to grab variable name
if nargin == 2
    name = varName;
else
    name = inputname(1);
    if isempty(name), name = 'ans'; end
end

% Store string displayed as information
t.info = {func2str(an,name)};
% Store parent information
if isempty(an.parent)
    parent = 'x';
else
    parent = an.parent;
    if strcmp(parent,'plus'), parent = '+';
    elseif strcmp(parent,'minus'), parent = '-';
    elseif strcmp(parent,'times'), parent = '*';
    elseif strcmp(parent,'rdivide'), parent = '/';
    elseif strcmp(parent,'mdivide'), parent = '/';
    elseif strcmp(parent,'power'), parent = '^';
    end
end
t.parent = parent;


% Go through workspace to detect what variables are chebfuns, and which are
% scalars/strings
for wsCounter = 1:length(variablesVec)
    if ~isa(workspace{wsCounter},'chebfun')
        variablesVec(wsCounter) = [];
    end
end

% Do if-elseing depending on how many chebfun variables we have in the
% workspace. As we might have doubles in the workspace, we need to subsref
% the workspace using the information in the variablesVec vector, e.g. for
% 2^x, we want the second variable in the workspace as a leaf, not the
% first one.
numVariables = length(variablesVec);
if numVariables == 0 % End recursion
    % Store the height and width of the leave, do nothing else
    t.height = 0;
    t.width = 1;
    t.numleaves = 0;
    %     t.x = 0.5;
elseif numVariables == 1
    t.center = anon2tree(workspace{variablesVec(1)}.jacobian,varNames{variablesVec(1)});
    t.height = t.center.height + 1;
    t.width = t.center.width;
    t.numleaves = 1;
    % Don't need to worry about scaling x coordinate
elseif numVariables == 2
    t.left = anon2tree(workspace{variablesVec(1)}.jacobian,varNames{variablesVec(1)});
    t.right = anon2tree(workspace{variablesVec(2)}.jacobian,varNames{variablesVec(2)});
    t.height = max(t.left.height,t.right.height) + 1;
    t.width = t.left.width + t.right.width;
    t.numleaves = 2;
    % Scale x coordinates
    %     t.x = 0.5;
    %     t.left.x
elseif numVariables == 3
    t.left = anon2tree(workspace{variablesVec(1)}.jacobian,varNames{variablesVec(1)});
    t.center = anon2tree(workspace{variablesVec(2)}.jacobian,varNames{variablesVec(2)});
    t.right = anon2tree(workspace{variablesVec(3)}.jacobian,varNames{variablesVec(3)});
    t.height = max(max(t.left.height,t.right.height),t.center.height) + 1;
    t.width = t.left.width + t.center.width + t.right.width;
    t.numleaves = 3;
end



end