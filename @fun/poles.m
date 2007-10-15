function z = poles(f,n)

m  = abs(length(f))-2*n;
a = funpoly(f)';
row = (1:n);
col = 1+(m+1:m+n)';
D = a(col(:,ones(n,1))+row(ones(n,1),:)) +...
    a(col(:,ones(n,1))-row(ones(n,1),:));
c = [1; - D\(2*a(m+2:m+n+1))];
z = roots(fun(c));
