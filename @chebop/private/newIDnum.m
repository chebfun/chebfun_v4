function newID = newIDnum()

% Mechanism for giving ops unique IDs.
persistent ID
if isempty(ID), ID = 0; end
ID = ID+1;
newID = ID;

end
