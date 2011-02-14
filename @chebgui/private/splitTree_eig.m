function [newTree lambdaTree] = splitTree_eig(guifile,treeIn)

% Begin by finding the subtree which contains lambda

[newTree lambdaTree] = findLambda(treeIn);

% If the top-center entry is a =, we need to convert that into a -.
% Otherwise, do nothing.
treeCenter = newTree.center;
if strcmp(treeCenter{2},'OP=')
    newTree.center = {'-', 'OP-'};
end

end

function [newTree lambdaTree] = findLambda(treeIn)

newTree = treeIn;
leftEmpty = 1; rightEmpty = 1;
lambdaTree = []; lambdaTreeLeft = []; lambdaTreeRight = [];

treeCenter = treeIn.center;

if isfield(treeIn,'left')
    [newLeft lambdaTreeLeft] = findLambda(treeIn.left);
    newTree.left = newLeft;
    leftEmpty = 0;
end

if isfield(treeIn,'right')
    [newRight lambdaTreeRight] = findLambda(treeIn.right);
    newTree.right = newRight;
    rightEmpty = 0;
end

% Return a new lambdaTree. If the operator in the center of treeIn is a *,
% we want to return the whole treeIn (e.g. when we see lambda*u). If not,
% we return the latest lambdaTree (e.g. when we see lambda*u+1, and the +
% is the operator of the current tree).
if ~isempty(lambdaTreeLeft)
    if strcmp(treeCenter{2},'OP*')
        lambdaTree = treeIn;
    else
        lambdaTree = lambdaTreeLeft;
    end
end
if ~isempty(lambdaTreeRight)
    if strcmp(treeCenter,'OP*')
        lambdaTree = treeIn;
    else
        lambdaTree = lambdaTreeRight;
    end
end

if leftEmpty && rightEmpty % Must be at a leaf
    % We encounter a lambda variable. Replace it by a zero.
   if strcmp(treeCenter{2},'LAMBDA')
       lambdaTree = newTree;
       newTree = struct('center',{{'0', 'NUM'}});
   end 
end

end


