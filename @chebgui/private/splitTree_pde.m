function newTree = splitTree_pde(guifile,treeIn)

% Begin by replacing the subtree which contains the pde_variable with a 0

[newTree pdeTree] = findPDE(treeIn);

% If the top-center entry is a =, we need to convert that into a -.
% Otherwise, do nothing.
treeCenter = newTree.center;
if strcmp(treeCenter{2},'OP=')
    newTree.center = {'-', 'OP-'};
end

end

function [newTree pdeTree] = findPDE(treeIn)

newTree = treeIn;
leftEmpty = 1; rightEmpty = 1; pdeTree = '';
% pdeTreeLeft = []; pdeTreeRight = [];

treeCenter = treeIn.center;

if isfield(treeIn,'left')
    [newLeft pdeTreeLeft] = findPDE(treeIn.left);
%     pdeTreeLeft
    newTree.left = newLeft;
    leftEmpty = 0;
end

if isfield(treeIn,'right')
    [newRight pdeTreeRight] = findPDE(treeIn.right);
%     pdeTreeRight
    newTree.right = newRight;
    rightEmpty = 0;
end


if leftEmpty && rightEmpty % Must be at a leaf.
    % We encounter a PDE variable. Replace it by a zero.
    if strcmp(treeCenter{2},'PDEVAR')
        pdeTree = newTree;
        newTree = struct('center',{{'0', 'NUM'}});
    end
end
end