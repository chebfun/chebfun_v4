function f = flipud(f)
% FLIPUD Flip/reverse a fun.
%
% G = FLIPUD(F) returns a fun G such that G(x)=F(-x) for all x.

% Toby Driscoll, 7 February 2008.

f.val = flipud(f.val);
