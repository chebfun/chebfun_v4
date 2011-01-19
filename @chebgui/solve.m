function handles = solve(guifile,handles)
% SOLVE Called when a user hits calls the solve method for a chebgui object
% outside the GUI (i.e. solve(cg))

if strcmpi(guifile.type,'bvp')
    [u vec] = solveBVP(guifile);
else
    [u vec] = solvePDE(guifile);
end