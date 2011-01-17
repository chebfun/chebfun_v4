function export(guifile,handles)

% Offer more possibilities if solution exists
if handles.hasSolution
    exportType = questdlg('Would you like to export the problem to:', ...
        'Export to...', ...
        'Workspace', '.m file', '.mat file', 'Workspace');
else
    exportType = questdlg(['Would you like to export the problem to (more ' ...
        'possibilities will be available after solving a ' ...
        'problem):'],'Export to...', ...
        '.m file','GUI variable','Cancel', '.m file');
end

problemType = handles.problemType;
%% bvp
if strcmp(problemType,'bvp')
    switch exportType
        case 'GUI variable'
            assignin('base','cg',handles.guifile);
        case 'Workspace'
            assignin('base','u',handles.latestSolution);
            assignin('base','normVec',handles.latestNorms);
            assignin('base','N',handles.latestChebop);
            assignin('base','rhs',handles.latestRHS);
            assignin('base','options',handles.latestOptions);
            assignin('base','cg',handles.guifile);
        case '.m file'
            % Obtain information about whether we are solving BVP or PDE
            
            [filename, pathname, filterindex] = uiputfile( ...
                {'*.m','M-files (*.m)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Save as', [problemType,'.m']);
            
            if filename     % User did not press cancel
                %             try
                exportbvp2mfile(pathname,filename,handles)
                % Open the new file in the editor
                open([pathname,filename])
                %             catch
                %                 error('chebfun:BVPgui','Error in exporting to .m file');
                %             end
            end
        case '.mat file'
            u = handles.latestSolution; %#ok<NASGU>
            normVec= handles.latestNorms;  %#ok<NASGU>
            N= handles.latestChebop;  %#ok<NASGU>
            rhs= handles.latestRHS;  %#ok<NASGU>
            options = handles.latestOptions;  %#ok<NASGU>
            uisave({'u','normVec','N','rhs','options'},'bvp');
        case 'Cancel'
            return;
    end
    
    %% PDE
else
    switch exportType
        case 'Workspace'
            assignin('base','u',handles.latestSolution);
            assignin('base','t',handles.latestSolutionT);
        case '.m file'
            % Obtain information about whether we are solving BVP or PDE
            
            % Convert back to the current folder
            chebpath = pwd;
            cd(temppath)
            [filename, pathname, filterindex] = uiputfile( ...
                {'*.m','M-files (*.m)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Save as', [problemType,'.m']);
            
            cd(chebpath)
            if filename     % User did not press cancel
                %             try
                exportpde2mfile(pathname,filename,handles)
                % Open the new file in the editor
                open([pathname,filename])
                %             catch
                %                 error('chebfun:BVPgui','Error in exporting to .m file');
                %             end
            end
        case '.mat file'
            u = handles.latestSolution; %#ok<NASGU>
            t = handles.latestSolutionT;  %#ok<NASGU>
            uisave({'u','t'},'pde');
        case 'Cancel'
            return;
    end
end


end

