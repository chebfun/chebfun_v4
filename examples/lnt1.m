% lnt1.m  compute complex gamma function - LNT 12/2005
%
% The method is essentially analytic continuation.
% We make a chebfun of 1/Gamma(x) on [-6,6] and then
% evaluate it on a grid in the complex plane.  Compare
% gamma_talbot.m and gamma_cmv.m in "Ten Digit Algorithms"

 x = -3.5:.1:4; y = -2.5:.1:2.5;
 [xx,yy] = meshgrid(x,y);
 zz = xx + 1i*yy;                              % plotting grid
 gi = chebfun(@(x) 1./gamma(x),[-6,6]);            % reciprocal of Gamma(x)
 gaminv = gi(zz);
%  gam = 1i./gaminv;                             % Gamma(z) on the grid
%  mesh(xx,yy,abs(gam))                          % plot |Gamma(z)|
%  axis([-3.5 4 -2.5 2.5 0 6])
%  xlabel Re(z), ylabel Im(z)
%  text(4,-1.4,5.5,'|\Gamma(z)|','fontsize',20)
%  colormap([0 0 0])                             % make the image blackfunction rpc6()
 gamcheb = gaminv;