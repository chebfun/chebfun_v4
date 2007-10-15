function F = ne(f,g)
% ~=	Not equal
% F ~= G compares funs F and G and returns one if F and G are
% not equal and zero otherwise.  A scalar can be compared with a fun.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=not(f==g);
