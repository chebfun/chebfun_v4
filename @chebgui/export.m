function export(guifile,handles,exportType)
problemType = handles.problemType;
% Exorting a BVP
if strcmp(problemType,'bvp')
    switch exportType
        case 'GUI'
            assignin('base','cg',handles.guifile);
            msgbox('Exported a chebgui variable named cg to workspace.','Chebgui export','modal')
        case 'Workspace'
            assignin('base','u',handles.latestSolution);
            assignin('base','normVec',handles.latestNorms);
            assignin('base','N',handles.latestChebop);
            assignin('base','rhs',handles.latestRHS);
            assignin('base','options',handles.latestOptions);
            assignin('base','cg',handles.guifile);
            msgbox('Exported chebfun variables named u, normVec, N, rhs, options and cg to workspace.','Chebgui export','modal')
        case '.m'
            % Obtain information about whether we are solving BVP or PDE
            
            [filename, pathname, filterindex] = uiputfile( ...
                {'*.m','M-files (*.m)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Save as', [problemType,'.m']);
            
            if filename     % User did not press cancel
                try
                    exportbvp2mfile(guifile,pathname,filename,handles)
                    % Open the new file in the editor
                    open([pathname,filename])
                catch ME
                    error('chebfun:BVPgui','Error in exporting to .m file. Please make sure there are no syntax errors.');
                end
            end
        case '.mat'
            u = handles.latestSolution; %#ok<NASGU>
            normVec= handles.latestNorms;  %#ok<NASGU>
            N= handles.latestChebop;  %#ok<NASGU>
            rhs= handles.latestRHS;  %#ok<NASGU>
            options = handles.latestOptions;  %#ok<NASGU>
            uisave({'u','normVec','N','rhs','options'},'bvp');
        case 'Cancel'
            return;
    end
    
    % Exporting a PDE
else
    switch exportType
        case 'GUI'
            assignin('base','cg',handles.guifile);
            msgbox('Exported a chebgui variable named cg to workspace.','Chebgui export','modal')
        case 'Workspace'
            assignin('base','u',handles.latestSolution);
            assignin('base','t',handles.latestSolutionT);
            msgbox('Exported variables named u and t to workspace.','Chebgui export','modal')
        case '.m'
            % Obtain information about whether we are solving BVP or PDE
            
            [filename, pathname, filterindex] = uiputfile( ...
                {'*.m','M-files (*.m)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Save as', [problemType,'.m']);
            
            if filename     % User did not press cancel
                try
                    exportpde2mfile(guifile,pathname,filename,handles)
                    % Open the new file in the editor
                    open([pathname,filename])
                catch
                    error('chebfun:BVPgui','Error in exporting to .m file. Please make sure there are no syntax errors.');
                end
            end
        case '.mat'
            u = handles.latestSolution; %#ok<NASGU>
            t = handles.latestSolutionT;  %#ok<NASGU>
            uisave({'u','t'},'pde');
        case 'Cancel'
            return;
    end
end


end

