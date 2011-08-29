function cg = loaddemos(guifile,guifilepath)
% Load a demo from a .guifile to a chebgui object

% Copyright 2011 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Defaults
type = '';
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
sigmatemp = '';
numeigs = '';
fixYaxisLower = '';
fixYaxisUpper = '';

% Import from the given file and evaluate to fill the workspace
fid = fopen(guifilepath);
if fid==-1
  error('CHEBGUI:noload','Unable to open demo file: %s.',guifilepath)
end
inputEnded = 0;
while ~inputEnded
    tline = fgetl(fid);
    if isempty(strfind(tline,'=')), continue, end % Don't eval names and demotypes
    if ~ischar(tline), break, end
    eval(tline);
    inputEnded = feof(fid);
end
fclose(fid);

% Create the options structure
options = struct('damping',damping,'plotting',plotting,'numeigs',numeigs, ...
    'fixYaxisLower', fixYaxisLower,'fixYaxisUpper', fixYaxisUpper,'sigma',sigmatemp);

% Build the chebguifile
cg = chebgui('type',type,'domleft',a,'domright',b,'timedomain',t,'de',DE,...
    'lbc',LBC,'rbc',RBC,'init',init,'tol',tol,...
    'options',options);
