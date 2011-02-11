function [newGUI handles] = cleargui(guifile, handles)

% Clear the input fields
set(handles.dom_left,'String','');
set(handles.dom_right,'String','');
set(handles.timedomain,'String','');
set(handles.input_DE,'String','');
set(handles.input_LBC,'String','');
set(handles.input_RBC,'String','');
set(handles.input_GUESS,'String','');
set(handles.timedomain,'String','');
set(handles.menu_tolerance,'UserData','1e-10'); % The default tolerance


% Clear the figures
initialisefigures(handles)

% Hide the iteration information
set(handles.iter_list,'String','');
set(handles.iter_text,'Visible','Off');
set(handles.iter_list,'Visible','Off');
% set(handles.text_norm,'Visible','Off');

% Disable export figures
set(handles.button_figsol,'Enable','off');
set(handles.button_fignorm,'Enable','off');
set(handles.button_solve,'Enable','on');
set(handles.button_solve,'String','Solve');

% Enable RHS of BCs again
set(handles.input_LBC,'Enable','on');
set(handles.input_RBC,'Enable','on');

% We don't have a solution available anymore
handles.hasSolution = 0;

% Clear information from the guifile as well
newGUI = chebgui('type',guifile.type);

function initialisefigures(handles)
cla(handles.fig_sol,'reset');
title('Solutions'), box on
cla(handles.fig_norm,'reset');
title('Updates'), box on