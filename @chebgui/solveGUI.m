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
    
    % Some basic checking of the inputs.
    a = str2double(get(handles.dom_left,'String'));
    b = str2double(get(handles.dom_right,'String'));
    if b <= a
        s = sprintf('Error in constructing domain. [%f,%f] is not valid.',a,b);
        errordlg(s, 'Chebgui error', 'modal');
        return
    end
    if ~get(handles.button_ode,'Value')
        tt = str2num(get(handles.timedomain,'String'));
        if isempty(tt)
            s = sprintf('Error in constructing time interval.');
            errordlg(s, 'Chebgui error', 'modal');
        return
        end
    end
    tol = guifile.tol;
    if ~isempty(tol)
        tolnum = str2double(tol);
        if isnan(tolnum) || isinf(tolnum) || isnan(tolnum)
            s = sprintf('Invalid tolerance, ''%s''.',tol);
            errordlg(s, 'Chebgui error', 'modal');
            return
        end
    end      
    
    % Disable buttons, figures, etc.
    set(handles.toggle_useLatest,'Enable','off');
    set(handles.button_figsol,'Enable','off');
    set(handles.button_fignorm,'Enable','off');
    % Pause button
%     set(handles.button_clear,'Enable','off');
    set(handles.button_clear,'String','Pause');
    set(handles.button_clear,'BackgroundColor',[255 255 35]/256);
    % Stop button
    set(handles.button_solve,'String','Stop');
    set(handles.button_solve,'BackgroundColor',[214 80 80]/256);
    drawnow
    
    % Call the private method solveGUIBVP or solveGUIPDE which do all the
    % work
    try
        if get(handles.button_ode,'Value')
            handles = solveGUIBVP(guifile,handles);
        else
            handles = solveGUIPDE(guifile,handles);
        end
    catch ME
        MEID = ME.identifier;
        if ~isempty(strfind(MEID,'parse:')) || ~isempty(strfind(MEID,'LINOP:'))
            errordlg(ME.message, 'Chebgui error', 'modal');
        elseif strcmp(MEID,'CHEBOP:solve:findguess:DivisionByZeroChebfun')
            errordlg(['Error in constructing initial guess. The the zero '...
                'function on the domain is not a permitted initial guess '...
                'as it causes division by zero. Please assign an initial '...
                'guess using the initial guess field.'], 'Chebgui error', 'modal');
        else
            resetComponents(handles);
            rethrow(ME);
        end
    end
    resetComponents(handles);
else   % In stop mode
    set(handles.button_clear,'String','Clear');
    set(handles.button_clear,'BackgroundColor',0.701960784313725*[1 1 1]);
    set(handles.button_solve,'String','Solve');
    set(handles.button_solve,'BackgroundColor',[43 129 86]/256);
    drawnow
end


function resetComponents(handles)
% Enable buttons, figures, etc. Set button to 'solve' again
set(handles.button_solve,'String','Solve');
set(handles.button_solve,'BackgroundColor',[43 129 86]/256);
set(handles.button_clear,'String','Clear');
set(handles.button_clear,'BackgroundColor',0.701960784313725*[1 1 1]);
set(handles.toggle_useLatest,'Enable','on');
set(handles.button_figsol,'Enable','on');
set(handles.button_fignorm,'Enable','on');