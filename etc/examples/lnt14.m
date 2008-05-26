% lnt14.m - play with monotonicity and variation

 f = chebfun(@sin,[0 6*pi]);
 plot(f)
 tv = norm(diff(f),1);
 title(['Total variation = ' num2str(tv)],'fontsize',18)
 disp('type <Enter> to see increasing and decreasing parts')
 pause
 fprime = diff(f);
 fprime_plus = max(fprime,0*fprime);
 f_increasing = cumsum(fprime_plus);
 f_decreasing = f - f_increasing;
 hold on
 plot(f_increasing,'g')
 plot(f_decreasing,'r')