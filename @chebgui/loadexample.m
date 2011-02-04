function cg = loadexample(guifile,exampleNumber,type)

if strcmpi(type,'bvp')
    cg = bvpdemos(guifile,exampleNumber);
elseif strcmpi(type,'pde')
    cg = pdedemos(guifile,exampleNumber);
else
    cg = eigdemos(guifile,exampleNumber);
end
