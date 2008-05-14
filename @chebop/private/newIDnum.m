function newID = newIDnum()

% Mechanism for giving ops unique IDs. These are used to store
% realizations and LU factors. Technically, the method could fail if this
% function is cleared (erasing persistent storage) while the chebop methods
% are left uncleared, but this possibility seems remote.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

persistent ID
if isempty(ID), ID = 0; end
ID = ID+1;
newID = ID;

end
