function export(guifile,handles,exportType)
problemType = guifile.type;
% Exporting a BVP
if strcmp(problemType,'bvp')
    switch exportType
        case 'GUI'
            prompt = 'Enter the name of the chebgui variable:';
            name   = 'Export GUI';
            numlines = 1;
            defaultanswer='chebg';
            options.Resize='on';
            options.WindowStyle='modal';
            
            answer = inputdlg(prompt,name,numlines,{defaultanswer},options);
            
            if ~isempty(answer)
                assignin('base',answer{1},handles.guifile);
            end
        case 'Workspace'
            prompt = {'Differential operator', 'Right hand side','Solution:',...
                'Vector with norm of updates', 'Options','Chebgui object'};
            name   = 'Export to workspace';
            defaultanswer={'N','rhs','u','normVec','options','chebg'};
            numlines = 1;
            options.Resize='on';
            options.WindowStyle='modal';
            
            answer = inputdlg(prompt,name,numlines,defaultanswer,options);
            
            if ~isempty(answer)
                assignin('base',answer{1},handles.latestChebop);
                assignin('base',answer{2},handles.latestRHS);
                assignin('base',answer{3},handles.latestSolution);
                assignin('base',answer{4},handles.latestNorms);
                assignin('base',answer{5},handles.latestOptions);
                assignin('base',answer{6},handles.guifile);
            end
        case '.m'            
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
                    errordlg('Error in exporting to .m file. Please make sure there are no syntax errors.',...
                        'Export chebgui','modal');
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
            prompt = 'Enter the name of the chebgui variable:';
            name   = 'Export GUI';
            numlines = 1;
            defaultanswer='chebg';
            options.Resize='on';
            options.WindowStyle='modal';
            
            answer = inputdlg(prompt,name,numlines,{defaultanswer},options);
            
            if ~isempty(answer)
                assignin('base',answer{1},handles.guifile);
            end
        case 'Workspace'           
            prompt = {'Solution', 'Timedomain'};
            name   = 'Export to workspace';
            defaultanswer={'u','t'};
            numlines = 1;
            options.Resize='on';
            options.WindowStyle='modal';
            
            answer = inputdlg(prompt,name,numlines,defaultanswer,options);
            
            if ~isempty(answer)
                assignin('base',answer{1},handles.latestSolution);
                assignin('base',answer{2},handles.latestSolutionT);
                msgbox(['Exported chebfun variables named ' answer{1},'and ',...
                    answer{2}, ' to workspace.'],...
                    'Chebgui export','modal')
            end
            msgbox('Exported variables named u and t to workspace.','Chebgui export','modal')
        case '.m'           
            [filename, pathname, filterindex] = uiputfile( ...
                {'*.m','M-files (*.m)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Save as', [problemType,'.m']);
            
            if filename     % User did not press cancel
%                 try
                    exportpde2mfile(guifile,pathname,filename,handles)
                    % Open the new file in the editor
                    open([pathname,filename])
%                 catch
%                     error('chebfun:BVPgui','Error in exporting to .m file. Please make sure there are no syntax errors.');
%                 end
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

