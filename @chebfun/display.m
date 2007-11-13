function display(X)
% DISPLAY	Display chebun
% DISPLAY(F) is called when the semicolon is not used at the end of a statement.
% DISPLAY(F) shows for each piece of a chebfun the number of points used to
% represent that part of the function, together with two columns: the first
% one with the Chebyshev points in the corresponding interval and the 
% second with the values of the function at those Chebyshev points.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = column chebfun']);
if loose, disp(' '), end
for i = 1:length(X.funs)
    n = get(X.funs{i},'n');
    if n == 0,
        x = X.ends(i+1);
    else
        x = scale(sin(pi*([-n:2:n]')/(2*n)),X.ends(i),X.ends(i+1));
    end
    if n==0
      disp(['fun ',num2str(i),': ',num2str(n+1),' point']); 
    else
      disp(['fun ',num2str(i),': ',num2str(n+1),' points']); 
    end
    if loose, disp(' '), end
    disp([x flipdim(get(X.funs{i},'val'),1)]);
end
    
