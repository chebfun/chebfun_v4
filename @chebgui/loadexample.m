function cg = loadexample(guifile,exampleNumber)

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Find the folders which demos are stored in
guipath = which('chebgui');

find_frontslash = max(strfind(guipath,'/'));
guipath = guipath(1:find_frontslash);
bvppath = [guipath,'private/bvpdemos/'];


% Setup ODEs
D = dir(bvppath);

% exampleNumber == -1 denotes a random example is required
if exampleNumber == -1
    numberOfDemos = length(D)-2; % First two entries are . and ..
    selected = randi(numberOfDemos)+2;
else
    selected = exampleNumber + 2;
end

demoPath = [bvppath,D(selected,:).name];
cg = loaddemos(guifile,demoPath);
