function handles = solveGUI(guifile,handles)
% SOLVEGUI Called when a user hits the solve button of the chebfun GUI

% Check whether some input is missing
if isempty(guifile.DomLeft) || isempty(guifile.DomRight)
    errordlg('The endpoints of the domain must be defined.', 'Chebgui error', 'modal');
    resetComponents(handles);
    return
end
if isempty(guifile.DE) || isempty(guifile.DErhs)
    errordlg('The differential equation and its right-hand side can not be empty.', 'Chebgui error', 'modal');
    resetComponents(handles);
    return
end
if isempty(guifile.LBC) && isempty(guifile.RBC)
    errordlg('Boundary conditions must be defined.', 'Chebgui error', 'modal');
    resetComponents(handles);
    return
end


if strcmp(get(handles.button_solve,'string'),'Solve')   % In solve mode
    % Disable buttons, figures, etc. Set button to 'stop'
    set(handles.toggle_useLatest,'Enable','off');
    set(handles.button_export,'Enable','off');
    set(handles.button_help,'Enable','off');
    set(handles.button_clear,'Enable','off');
    set(handles.button_figsol,'Enable','off');
    set(handles.button_fignorm,'Enable','off');
    set(handles.button_solve,'String','Stop');
    set(handles.button_solve,'BackgroundColor',[214 80 80]/256);
    
    % Call the private method solveGUIBVP or solveGUIPDE which do all the
    % work
    try
        if get(handles.button_bvp,'Value')
            handles = solveGUIBVP(guifile,handles);
        else
            handles = solveGUIPDE(guifile,handles);
        end
    catch ME
        MEID = ME.identifier;
        if ~isempty(strfind(MEID,'parse:')) || ~isempty(strfind(MEID,'LINOP:'))
            errordlg(ME.message, 'Chebgui error', 'modal');
        else
            resetComponents(handles);
            rethrow(ME);
        end
    end
    resetComponents(handles);
else   % In stop mode
    set(handles.button_solve,'String','Solve')
    set(handles.button_solve,'BackgroundColor',[43 129 86]/256);
end


function resetComponents(handles)
% Enable buttons, figures, etc. Set button to 'solve' again
set(handles.button_solve,'String','Solve');
set(handles.button_solve,'BackgroundColor',[43 129 86]/256);
set(handles.button_export,'Enable','on');
set(handles.button_help,'Enable','on');
set(handles.button_clear,'Enable','on');
set(handles.toggle_useLatest,'Enable','on');
set(handles.button_figsol,'Enable','on');
set(handles.button_fignorm,'Enable','on');