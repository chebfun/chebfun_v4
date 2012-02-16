function tf = isempty(a)
% ISEMPTY True for empty anon.
%    ISEMPTY(A) returns 1 if A is an empty anon and 0 otherwise. An
%    empty anon has no variablesName.
tf =  isempty(a.variablesName);