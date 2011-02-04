function cg = loadexample(guifile,exampleNumber,type)

if strcmpi(type,'bvp')
    cg = bvpdemos(guifile,exampleNumber);
else
    cg = pdedemos(guifile,exampleNumber);
end
