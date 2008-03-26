function dom = domaincheck(A,B)

% Are these two intervals the "same"?

int1 = domain(A);  int2 = domain(B);
h = max( diff(int1), diff(int2) );
if all( h*abs(int1-int2)< 10*eps )
  dom = [ min(int1(1),int2(1)), max(int1(2),int2(2)) ];
else
  error('chebop:domaincheck:Function domains do not match.')
end

end