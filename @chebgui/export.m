function export(guifile,handles,exportType)
problemType = guifile.type;
% handles and exportType are empty if user calls export from command window,
% always export to .m file in that case.
if nargin == 1
    exportType = '.m';
end
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
                assignin('base',answer{1},handles.latest.chebop);
                assignin('base',answer{2},handles.latest.RHS);
                assignin('base',answer{3},handles.latest.solution);
                assignin('base',answer{4},handles.latest.norms);
                assignin('base',answer{5},handles.latest.options);
                assignin('base',answer{6},handles.guifile);
            end
        case '.m'            
            [filename, pathname, filterindex] = uiputfile( ...
                {'*.m','M-files (*.m)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Save as', [problemType,'.m']);
            
            if filename     % User did not press cancel
%                 try
                    exportbvp2mfile(guifile,pathname,filename)
                    % Open the new file in the editor
                    open([pathname,filename])
%                 catch ME
%                     errordlg('Error in exporting to .m file. Please make sure there are no syntax errors.',...
%                         'Export chebgui','modal');
%                 end
            end
        case '.mat'
            u = handles.latest.solution; %#ok<NASGU>
            normVec= handles.latest.norms;  %#ok<NASGU>
            N= handles.latest.chebop;  %#ok<NASGU>
            rhs= handles.latest.RHS;  %#ok<NASGU>
            options = handles.latest.options;  %#ok<NASGU>
            uisave({'u','normVec','N','rhs','options'},'bvp');
        case 'Cancel'
            return;
    end
    
    % Exporting a PDE
elseif strcmp(problemType,'pde')
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
                assignin('base',answer{1},handles.latest.solution);
                assignin('base',answer{2},handles.latest.solutionT);
%                 msgbox(['Exported chebfun variables named ' answer{1},' and ',...
%                     answer{2}, ' to workspace.'],...
%                     'Chebgui export','modal')
            else
%                 msgbox('Exported variables named u and t to workspace.','Chebgui export','modal')
            end
        case '.m'           
            [filename, pathname, filterindex] = uiputfile( ...
                {'*.m','M-files (*.m)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Save as', [problemType,'.m']);
            
            if filename     % User did not press cancel
%                 try
                    exportpde2mfile(guifile,pathname,filename)
                    % Open the new file in the editor
                    open([pathname,filename])
%                 catch
%                     error('chebfun:BVPgui','Error in exporting to .m file. Please make sure there are no syntax errors.');
%                 end
            end
        case '.mat'
            u = handles.latest.solution; %#ok<NASGU>
            t = handles.latest.solutionT;  %#ok<NASGU>
            uisave({'u','t'},'pde');
        case 'Cancel'
            return;
    end
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
            prompt = {'Eigenvalues', 'Eigenmodes'};
            name   = 'Export to workspace';
            defaultanswer={'D','V'};
            numlines = 1;
            options.Resize='on';
            options.WindowStyle='modal';
            
            answer = inputdlg(prompt,name,numlines,defaultanswer,options);
            
            if ~isempty(answer)
                assignin('base',answer{1},diag(handles.latest.solution));
                assignin('base',answer{2},handles.latest.solutionT);
%                 msgbox(['Exported chebfun variables named ' answer{1},'and ',...
%                     answer{2}, ' to workspace.'],...
%                     'Chebgui export','modal')
            else
%                 msgbox('Exported variables named D and V to workspace.','Chebgui export','modal')
            end
        case '.m'           
            [filename, pathname, filterindex] = uiputfile( ...
                {'*.m','M-files (*.m)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Save as', 'bvpeig.m');
            
            if filename     % User did not press cancel
                try
                    exporteig2mfile(guifile,pathname,filename,handles)
                    % Open the new file in the editor
                    open([pathname,filename])
                catch
                    error('chebfun:BVPgui','Error in exporting to .m file. Please make sure there are no syntax errors.');
                end
            end
        case '.mat'
            D = diag(handles.latest.solution); %#ok<NASGU>
            V = handles.latest.solutionT;  %#ok<NASGU>
            uisave({'D','V'},'bvpeig');
        case 'Cancel'
            return;
    end
    


end

