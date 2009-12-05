function solve_display(phase,u,du,nrmdu,nrmres)

% Utility routine for displaying iteration progress in the solve functions.

mode = lower(cheboppref('display'));
persistent fig
persistent itercount;

switch(phase)
  case 'init'
    itercount = 0;
    switch(mode)
      case 'iter'
        fprintf('  Iter.       || step ||       length(step)      length(u)\n');
        fprintf('------------------------------------------------------------\n');
      case 'plot'
        fig = figure('name','BVP solver convergence');
        subplot(2,1,1)
        plot(u,'.-'), title('Current solution')
        subplot(2,1,2)
        title('Current correction step')
        pause(0.5)
    end
    
  case 'iter'
    itercount = itercount+1;
    switch(mode)
      case 'iter'
        fprintf('%5i %18.3e %13i %16i\n',itercount,nrmdu,qmlen(du),qmlen(u));
      case 'plot'
        figure(fig)
        subplot(2,1,1)
        plot(u,'.-'), title('Current solution')
        subplot(2,1,2)
        plot(du,'.-'), title('Current correction step')
        pause(0.5)        
    end
    
  case 'final'
    switch(mode)
      case {'iter','final'}
        fprintf('\n')
        fprintf('%i iterations\n',itercount)
        fprintf('Final residual norm: %.2e (interior) and %.2e (boundary)\n\n',nrmres)
      case 'plot'
        figure(fig), clf
        plot(u), title('Final solution')
    end
        
end

end

function len = qmlen(u)  % quasimatrix length
len = -Inf;
for j=1:size(u,2), len=max(len,length(u(:,j))); end
end
        
        