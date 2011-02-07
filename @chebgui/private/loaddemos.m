function cg = loaddemos(guifile,guifilepath)

% Defaults
name = '';
demotype = '';
a = ''; 
b = '';
t = '';
DE = '';
LBC = ''; 
RBC = '';
init = ''; 
tol = '';
damping = '';
plotting = '';
sigma = '';

% Import from the given file and evaluate to fill the workspace
fid = fopen(guifilepath);
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    eval(tline);
end
fclose(fid);

% Create the options structure
options = struct('damping',damping,'plotting',plotting);

% Build the chebguifile
cg = chebgui('type',demotype,'domleft',a,'domright',b,'timedomain',t,'de',DE,...
    'lbc',LBC,'rbc',RBC,'init',init,'tol',tol,...
    'options',options);
