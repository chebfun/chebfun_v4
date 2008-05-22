function out = ne(F1,F2)
%~=	  Not equal.
% F1 ~= F2 compares chebfuns F1 and F2 and returns logical true if F1 and
% F2 are not equal and false otherwise. 

out = not( F1==F2 );
