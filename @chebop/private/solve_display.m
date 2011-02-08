function solve_display(pref,guihandles,phase,u,du,nrmdu,nrmres,lambda)

% Utility routine for displaying iteration progress in the solve functions.

% Display for damped Newton is a bit different from the undamped (want to
% show the stepsize as well).

% Plot is now a seperate option (allowing both to show iter and plot).
mode = lower(pref.display);%lower(cheboppref('display'));
plotMode = lower(pref.plotting);%lower(cheboppref('plotting'));
persistent fig
persistent itercount;
persistent iterInfo;

% guiMode is equal to 1 if we are working with the chebopgui. Used as
% control variable throughout.
if ~isempty(guihandles)
    guiMode = 1;
else
    guiMode = 0;
end

switch(phase)
    case 'init'
        itercount = 0;
        if strcmp(mode,'iter')
            initString = sprintf('   Iter.       || update ||       length(update)    length(u)\n');
            if ~guiMode
                fprintf(initString);
                fprintf('------------------------------------------------------------\n');
            else
                set(guihandles{3},'String', initString);
            end
        end
        
        if ~strcmp(plotMode,'off')
            if ~guiMode
                fig = figure('name','BVP solver convergence');
                plot(u,'.-'), title('Initial guess of solution')
            else
                axes(guihandles{1})
                plot(u,'.-'), title('Initial guess of solution')
                if pref.grid, grid on, end
            end
        end
        
    case 'initNewton'
        itercount = 0;
        if strcmp(mode,'iter')
            initString = sprintf('   Iter.       || update ||      length(update)     stepsize    length(u)\n');
            if ~guiMode
                fprintf(initString);
                fprintf('---------------------------------------------------------------------------\n');
            else
                set(guihandles{3},'String', initString);
            end
        end
        
        if ~strcmp(plotMode,'off')
            if ~guiMode
                fig = figure('name','BVP solver convergence');
                plot(u,'.-'), title('Initial guess of solution')
            else
                axes(guihandles{1})
                plot(u,'.-'), title('Initial guess of solution')
                if pref.grid, grid on, end
            end
        end
    case 'iter'
        itercount = itercount+1;
        if strcmp(mode,'iter')
            iterString = sprintf('%5i %18.3e %13i   %16i\n',itercount,nrmdu,qmlen(du),qmlen(u));
            if ~guiMode
                fprintf(iterString);
            else
                currString = get(guihandles{4},'String');
                set(guihandles{4},'String', [currString;iterString]);
                set(guihandles{4},'Value',itercount);
            end
        end
        if ~strcmp(plotMode,'off')
            if ~guiMode
                figure(fig)
                subplot(2,1,1)
                plot(u,'.-'), title('Current solution')
                subplot(2,1,2)
                if numel(du) == 1 % If we have only one function, plot update in red
                    plot(du,'r.-'), title('Current correction step')
                else
                    plot(du,'.-'), title('Current correction step')
                end
            else
                axes(guihandles{1})
                plot(u,'.-'), title('Current solution')
                if pref.grid, grid on, end
                axes(guihandles{2})
                if numel(du) == 1 % If we have only one function, plot update in red
                    plot(du,'r.-'), title('Current correction step')
                    if pref.grid, grid on, end
                else
                    plot(du,'.-'), title('Current correction step')
                    if pref.grid, grid on, end
                end
            end
        end
        drawnow
    case 'iterNewton'
        itercount = itercount+1;
        if strcmp(mode,'iter')
            iterString = sprintf('%5i %18.3e %13i        %12.3g   %13i\n',itercount,nrmdu,qmlen(du),lambda,qmlen(u));
            if ~guiMode
                fprintf(iterString);
            else
                currString = get(guihandles{4},'String');
                set(guihandles{4},'String', [currString;iterString]);
                set(guihandles{4},'Value',itercount);
            end
        end
        if ~strcmp(plotMode,'off')
            if ~guiMode
                figure(fig)
                subplot(2,1,1)
                plot(u,'.-'), title('Current solution')
                subplot(2,1,2)
                if numel(du) == 1 % If we have only one function, plot update in red
                    plot(du,'r.-'), title('Current correction step')
                else
                    plot(du,'.-'), title('Current correction step')
                end
            else
                axes(guihandles{1})
                plot(u,'.-'), title('Current solution')
                if pref.grid, grid on, end
                axes(guihandles{2})
                if numel(du) == 1 % If we have only one function, plot update in red
                    plot(du,'r.-'), title('Current correction step')
                    if pref.grid, grid on, end
                else
                    plot(du,'.-'), title('Current correction step')
                    if pref.grid, grid on, end
                end
            end
        end
        drawnow
    case 'final'
        if strcmp(mode,'iter') || strcmp(mode,'final')
            if ~guiMode
                fprintf('\n');
                if itercount == 1
                    fprintf('%i iteration\n',itercount)
                else
                    fprintf('%i iterations\n',itercount)
                end
                fprintf('Final residual norm: %.2e (interior) and %.2e (boundary conditions). \n\n',nrmres)
            else
                currString = get(guihandles{4},'String');
                if itercount == 1
%                     finalString = sprintf('%i iteration.\nFinal residual norm: %.2e (interior) \n and %.2e (boundary conditions).',itercount,nrmres);
                    finalString2 = sprintf('Final residual norm: %.2e (interior)',nrmres);
                    finalString3 = sprintf('and %.2e (boundary conditions).',nrmres);
                else
                    finalString2 = sprintf('Final residual norm: %.2e (interior)',nrmres(1));
                    finalString3 = sprintf('and %.2e (boundary conditions).',nrmres(2));
                end
                set(guihandles{4},'String',{currString,finalString2, finalString3});
            end
        end
        
        if strcmp(plotMode,'on')
            if ~guiMode
                figure(fig), clf
                plot(u), title('Solution at end of iteration')
            end
        end
        
end

end

function len = qmlen(u)  % quasimatrix length
len = -Inf;
for j=1:size(u,2), len=max(len,length(u(:,j))); end
end


