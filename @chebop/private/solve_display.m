function solve_display(phase,u,du,nrmdu,nrmres,lambda)

% Utility routine for displaying iteration progress in the solve functions.

% Display for damped Newton is a bit different from the undamped (want to
% show the stepsize as well).

% Plot is now a seperate option (allowing both to show iter and plot).
mode = lower(cheboppref('display'));
plotMode = lower(cheboppref('plotting'));
persistent fig
persistent itercount;

switch(phase)
    case 'init'
        itercount = 0;
        if strcmp(mode,'iter')
            fprintf('  Iter.       || update ||       length(update)      length(u)\n');
            fprintf('------------------------------------------------------------\n');
        end
        
        if ~strcmp(plotMode,'off')
            fig = figure('name','BVP solver convergence');
            subplot(2,1,1)
            plot(u,'.-'), title('Current solution')
            subplot(2,1,2)
            title('Current correction step')
            if strcmp(plotMode,'pause') 
                pause
            else
                pause(plotMode)
            end
        end
        
    case 'initNewton'
        itercount = 0;
        if strcmp(mode,'iter')
            fprintf('  Iter.       || update ||      length(update)     stepsize      length(u)\n');
            fprintf('---------------------------------------------------------------------------\n');
        end
        
        if ~strcmp(plotMode,'off')
            fig = figure('name','BVP solver convergence');
            subplot(2,1,1)
            plot(u,'.-'), title('Current solution')
            subplot(2,1,2)
            title('Current correction step')
            if strcmp(plotMode,'pause') 
                pause
            else
                pause(plotMode)
            end
        end
        
    case 'iter'
        itercount = itercount+1;
        if strcmp(mode,'iter')
            fprintf('%5i %18.3e %13i %16i\n',itercount,nrmdu,qmlen(du),qmlen(u));
        end
        if ~strcmp(plotMode,'off')
            figure(fig)
            subplot(2,1,1)
            plot(u,'.-'), title('Current solution')
            subplot(2,1,2)
            plot(du,'.-'), title('Current correction step')
            pause(0.5)
        end
        
    case 'iterNewton'
        itercount = itercount+1;
        if strcmp(mode,'iter')
            fprintf('%5i %18.3e %13i        %12.3g %13i\n',itercount,nrmdu,qmlen(du),lambda,qmlen(u));
        end
        if ~strcmp(plotMode,'off')
            figure(fig) 
            subplot(2,1,1)
            plot(u,'.-'), title('Current solution')
            subplot(2,1,2)
            plot(du,'.-'), title('Current correction step')
            if strcmp(plotMode,'pause') 
                pause
            else
                pause(plotMode)
            end
        end
        
    case 'final'
        if strcmp(mode,'iter') || strcmp(mode,'final')
            fprintf('\n')
            fprintf('%i iterations\n',itercount)
            fprintf('Final residual norm: %.2e (interior) and %.2e (boundary conditions). \n\n',nrmres)
        end
        
        if strcmp(plotMode,'on')
            figure(fig), clf
            plot(u), title('Solution at end of iteration')
        end
        
end

end

function len = qmlen(u)  % quasimatrix length
len = -Inf;
for j=1:size(u,2), len=max(len,length(u(:,j))); end
end


