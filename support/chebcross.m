function c = chebcross(a,b)
ax = a{1}; ay = a{2}; az = a{3};
bx = b{1}; by = b{2}; bz = b{3};

c{1} = ay.*bz - az.*by;
c{2} = - ax.*bz + az.*bx;
c{3} = ax.*by - ay.*bx;