function dom = domaincheck(A,B)

% Given chebops or chebfuns A and B, do they have the same domain? Here
% "same" is interpreted with a little forgiveness for roundoff error. The
% return value is considered to be the official domain of both arguments,
% or an error is thrown if they don't match.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

int1 = domain(A);  int2 = domain(B);
h = max( length(int1), length(int2) );  % set interval scale
if all( h*abs([int1(1)-int2(1),int1(2)-int2(2)])< 10*eps )
  % Expand interval to include both.
  dom = [ min(int1(1),int2(1)), max(int1(2),int2(2)) ];
  dom = domain(dom);
else
  error('chebop:domaincheck:nomatch','Function domains do not match.')
end

end
