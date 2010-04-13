function export(handles)

% Offer more possibilities if solution exists
if handles.hasSolution
    exportType = questdlg('Would you like to export the problem to:', ...
        'Export to...', ...
        'Workspace', '.m file', '.mat file', 'Workspace');
else
    exportType = questdlg(['Would you like to export the problem to (more ' ...
        'possibilities will be available after solving a ' ...
        'problem):'],'Export to...', ...
        '.m file','Cancel', '.m file');
end

switch exportType
    case 'Workspace'
        assignin('base','u',handles.latestSolution);
        assignin('base','normVec',handles.latestNorms);
        assignin('base','N',handles.latestChebop);
        assignin('base','rhs',handles.latestRHS);
        assignin('base','options',handles.latestOptions);
    case '.m file'
        [filename, pathname, filterindex] = uiputfile( ...
            {'*.m','M-files (*.m)'; ...
            '*.*',  'All Files (*.*)'}, ...
            'Save as', 'bvp.m');
        
        if filename     % User did not press cancel
            try
                export2mfile(pathname,filename,handles)
                
                % Open the new file in the editor
                open([pathname,filename])
            catch
                error('chebfun:BVPgui','Error in exporting to .m file');
            end
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


end

