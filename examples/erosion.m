% erosion.m  An irregular sign function diffuses by u_t = u_xx
  disp(' ')
  disp('Press <Enter> to step to the next time')
  disp(' ')
  M = 6; [d,x] = domain(0,M); 
  u = chebfun(@(t) sign((-1).^floor(t.^1.5)),d,'splitting','on');
  L = diff(d,2);
  dt = 0.01; expmL = expm(dt*L & 'neumann');
  for t = 0:dt:0.3
     plot(u,'linewidth',3), axis([0 M -1.1 1.1])
     title(['t = ' num2str(t) '      length(u) = ' ...
        int2str(length(u))],'fontsize',16), shg
     u = expmL*u; pause
  end
