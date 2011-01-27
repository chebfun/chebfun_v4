function cg = loadexample(guifile,exampleNumber,type)

if strcmpi(type,'bvp')
    cg = bvpexamples(guifile,exampleNumber);
else
    [a,b,tt,DE,DErhs,LBC,LBCrhs,RBC,RBCrhs,guess,tol] = pdeexamples(guifile,exampleNumber);
    cg = chebgui('type',type);
    cg.DomLeft = a;
    cg.DomRight = b;
    cg.DE = DE;
    cg.DErhs = DErhs;
    cg.LBC = LBC;
    cg.LBCrhs = LBCrhs;
    cg.RBC = RBC;
    cg.RBCrhs = RBCrhs;
    cg.guess = guess;
    cg.tol = tol;    
    cg.timedomain = tt;
end
