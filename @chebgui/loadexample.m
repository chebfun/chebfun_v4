function cg = loadexample(guifile,exampleNumber,type)

if strcmpi(type,'bvp')
    cg = bvpexamples(guifile,exampleNumber);
else
    cg = pdeexamples(guifile,exampleNumber);
end
