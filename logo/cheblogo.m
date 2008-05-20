
clf
x = linspace(-1,1,300)';
plot(x,cos(10*acos(x)),'linew',5)
hold on
t = - cos(pi*(2:8)'/10) *.99;
y = 0*t; 
h = text( t', y, num2cell(transpose('chebfun')), ...
  'fontname','Rockwell','fontsize',28,'hor','cen','vert','mid','fontweight','normal') ; 

axis([-1.02 .95 -2 2])
set(gca,'pos',[0 0 1 1 ])
axis off

shg