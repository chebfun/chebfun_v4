function newID = newIDnum()

% Mechanism for giving ops unique IDs. These are used to store
% realizations and LU factors. Technically, the method could fail if this
% function is cleared (erasing persistent storage) while the chebop methods
% are left uncleared, but this possibility seems remote.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.
persistent ID SESSION
% Store the number of the second the function is first called in a Matlab
% session (the second is given by now*100000)
if isempty(SESSION), SESSION = int64(now*100000); end
% Increment ID by 1
if isempty(ID), ID = 0; end
ID = ID+1;
newID = [ID, SESSION];
end
