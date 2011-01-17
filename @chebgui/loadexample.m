function cg = loadexample(guifile,exampleNumber,type)  

cg = chebgui('type',type); % Create an empty chebgui

if strcmpi(type,'bvp')
    [a,b,DE,DErhs,LBC,LBCrhs,RBC,RBCrhs,guess,tol] = bvpexamples(cg,exampleNumber);
else
    [a,b,tt,DE,DErhs,LBC,LBCrhs,RBC,RBCrhs,guess,tol] = pdeexamples(cg,exampleNumber);
    cg.timedomain = tt;
end

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

