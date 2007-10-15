% function rpc18
% Fun with chebfun! Create your own chebfun on the complex plane. Just mark
% some point on the figure and this M-file will create a chebfun that goes
% through your points

clear
clf
axis([0 10 0 10]), 
hold on
% Initially, the list of points is empty.
xy = ['['];
n = 0;
% Loop, picking up the points.
disp('Right mouse button picks points.')
disp('Left mouse button for a different figure.')
disp('Double click left mouse button to end.')
but = 3;
drawing = 1;
ncheb = 1;
while drawing
    while but ~= 1
        [xi,yi,but] = ginput(1);
        if but~=1
            plot(xi,yi,'ro')
            n = n+1;
            xy = [xy num2str([xi+i*yi]) ';'];
        end
    end
    data{ncheb} = [xy(1:end-1) ']'];
    n = 0;
    xy = ['['];
    [xi,yi,but] = ginput(1);
    ncheb = ncheb+1;
    if but == 1
        drawing = 0;
    else
        plot(xi,yi,'ro')
        n = n+1;
        xy = [xy num2str([xi+i*yi]) ';'];
    end
end
if ~strcmp(data,']')
    f = chebfun(data,0:length(data));
    plot(f,'jumpline','none','linewidth',2)
end