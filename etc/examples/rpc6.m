function rpc6()
% rpc6 - compute integral of a smooth function in 2D
% (f = sin(x*y*pi/2); 0 < x,y, < 2)
%       Ricardo Pachon, 12/06

% First we plot the function:
 x = 0:.1:2; y = x;
 [xx,yy] = meshgrid(x,y);
 mesh(xx,yy,sin(pi*xx.*yy/2))

% Then we compute the double integral:
 exact = 1.55185834819916
 x = chebfun(@(x) x,[0 2]);
 f = chebfun(@f_integrated_wrt_x,[0 2]);
 integral = sum(f)

 function fx = f_integrated_wrt_x(y)
   n = length(y);
   fx = zeros(length(y),1);
   for i = 1:n
       fx(i) = sum(sin(pi*x*y(i)/2));
   end
 end

end
