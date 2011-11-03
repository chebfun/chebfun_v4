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

t.info = func2str(an,name);

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
    % Do nothing
elseif numVariables == 1
    t.center = anon2tree(workspace{variablesVec(1)}.jacobian,varNames{variablesVec(1)});
elseif numVariables == 2
    t.left = anon2tree(workspace{variablesVec(1)}.jacobian,varNames{variablesVec(1)});
    t.right = anon2tree(workspace{variablesVec(2)}.jacobian,varNames{variablesVec(2)});
elseif numVariables == 3
    t.left = anon2tree(workspace{variablesVec(1)}.jacobian,varNames{variablesVec(1)});
    t.center = anon2tree(workspace{variablesVec(2)}.jacobian,varNames{variablesVec(2)});
    t.right = anon2tree(workspace{variablesVec(3)}.jacobian,varNames{variablesVec(3)});
end



end