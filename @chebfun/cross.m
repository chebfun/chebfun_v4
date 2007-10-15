function c = riccross(a,b)
ax = a{1}; ay = a{2}; az = a{3};
bx = a{1}; by = a{2}; bz = a{3};

c{1} = ay.*bz - az.*by;
c{2} = - ax.*bz + az.*bx;
c{3} = ax.*by - ay.*bx;