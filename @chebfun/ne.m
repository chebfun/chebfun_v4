function out = ne(F1,F2)
%~=	Not equal
%  F1 ~= F2 compares chebfuns F1 and F2 and returns one if F1 and F2 are
%  not equal and zero otherwise. 

out = not( F1==F2 );
