function [treeOut] = splitTree_bvp(guifile,treeIn)

treeOut = treeIn;

% If the top-center entry is a =, we need to convert that into a - in case
% we're working with a ODE. Otherwise, do nothing.
treeCenter = treeIn.center;
if strcmp(treeCenter{2},'OP=')
    treeOut.center = {'-', 'OP-'};
end