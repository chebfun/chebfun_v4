% Chebfun logo.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

figure
x = linspace(-1,0.93,300)';
plot(x,cos(10*acos(x)),'linew',5)
hold on

t = - cos(pi*(2:8)'/10) *0.99;  % cheb extrema (tweaked)
y = 0*t; 
h = text( t, y, num2cell(transpose('chebfun')), ...
  'fontname','Rockwell','fontsize',28,'hor','cen','vert','mid','fontweight','normal') ; 

axis([-1.02 .95 -2 2])
set(gca,'pos',[0 0 1 1])
set(gcf,'papertype','A4','paperunit','cent','paperpos',[4.49 12.83 12 4])
set(gcf,'unit','cent','pos',[0 0 12 4],...
  'menuBar','none','name','Chebfun Toolbox','numbertitle','off')
axis off

shg