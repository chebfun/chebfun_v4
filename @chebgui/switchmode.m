function handles = switchmode(guiObject, handles,newMode,callMode)

% Only use callMode when calling from loaddemo_menu - for demos with an initial
% guess / condition, we don't want to clear the figures.
if nargin == 3
    callMode = 'notDemo';
end

if strcmp(newMode,'bvp') % Going into BVP mode
    handles.guifile.type = 'bvp';
    
    set(handles.button_ode,'Value',1)
    set(handles.button_pde,'Value',0)
    set(handles.button_eig,'Value',0)
    
    % set(handles.iter_list,'Visible','on')
    % set(handles.iter_text,'Visible','on')
    set(handles.input_GUESS,'visible','On')
    set(handles.text_initial,'Strin','Initial guess')
    set(handles.toggle_useLatest,'Visible','on')
    
    set(handles.text_timedomain,'Visible','off')
    set(handles.timedomain,'Visible','off')
    
    set(handles.button_realplot,'Visible','off')
    set(handles.button_imagplot,'Visible','off')
    set(handles.button_envelope,'Visible','off')
    
    pdeplotopts(handles,0)
    
    % Change the list of available options.
    % Enable ODE menu options
    set(handles.menu_odedampednewton,'Enable','On')
    set(handles.menu_odeplotting,'Enable','On')
    % Disable PDE menu options
    set(handles.menu_pdeplotting,'Enable','Off')
    set(handles.menu_pdeholdplot,'Enable','Off')
    set(handles.menu_pdefix,'Enable','Off')
    set(handles.menu_fixN,'Enable','Off')
    % Disable EIG menuoptions
    set(handles.menu_sigma,'Enable','Off')
    set(handles.menu_eigno,'Enable','Off')
    
    % Clear the figures
    initialisefigures(handles,callMode)
    
    %     % Load a new random BVP example and change the demos popup menu
    %     handles.guifile = loadexample(handles.guifile,-1,'bvp');
    %     loadfields(handles.guifile,handles)
    
elseif strcmp(newMode,'pde') % Going into PDE mode
    handles.guifile.type = 'pde';
    
    set(handles.button_ode,'Value',0)
    set(handles.button_pde,'Value',1)
    set(handles.button_eig,'Value',0)
    set(handles.toggle_useLatest,'Visible','off')
    set(handles.iter_list,'Visible','off')
    set(handles.iter_text,'Visible','off')
    set(handles.text_initial,'String','Initial condition')
    
    pdeplotopts(handles,1)
    
    set(handles.input_GUESS,'Visible','On')
    set(handles.input_GUESS,'Enable','On')
    set(handles.toggle_useLatest,'Value',0)
    
    set(handles.text_timedomain,'Visible','on')
    set(handles.timedomain,'Visible','on')
    
    set(handles.button_realplot,'Visible','off')
    set(handles.button_imagplot,'Visible','off')
    set(handles.button_envelope,'Visible','off')
    
    % Change the list of available options
    % Disable ODE menu options
    set(handles.menu_odedampednewton,'Enable','Off')
    set(handles.menu_odeplotting,'Enable','Off')
    % Enable PDE menuoptions
    set(handles.menu_pdeplotting,'Enable','On')
    set(handles.menu_pdeholdplot,'Enable','On')
    set(handles.menu_pdefix,'Enable','On')
    set(handles.menu_fixN,'Enable','On')
    % Disable EIG menuoptions
    set(handles.menu_sigma,'Enable','Off')
    set(handles.menu_eigno,'Enable','Off')
    
    % Clear the figures
    initialisefigures(handles,callMode)
    
    %     handles.guifile = loadexample(handles.guifile,-1,'pde');
    %     loadfields(handles.guifile,handles)
    
else % Going into EIG mode
    handles.guifile.type = 'eig';
    
    set(handles.button_ode,'Value',0)
    set(handles.button_pde,'Value',0)
    set(handles.button_eig,'Value',1)
    
    set(handles.toggle_useLatest,'Visible','off')
    % set(handles.iter_list,'Visible','on')
    % set(handles.iter_text,'Visible','on')
    set(handles.text_initial,'String','')
    set(handles.input_GUESS,'visible','Off')
    
    set(handles.text_timedomain,'Visible','off')
    set(handles.timedomain,'Visible','off')
    
    set(handles.button_realplot,'Visible','on')
    set(handles.button_realplot,'Value',1)
    set(handles.button_imagplot,'Visible','on')
    set(handles.button_imagplot,'Value',0)
    set(handles.button_envelope,'Visible','off')
    
    pdeplotopts(handles,0)
    
    % Change the list of available options.
    % Disable ODE options
    set(handles.menu_odedampednewton,'Enable','Off')
    set(handles.menu_odeplotting,'Enable','Off')
    % Disable PDE options
    set(handles.menu_pdeplotting,'Enable','Off')
    set(handles.menu_pdeholdplot,'Enable','Off')
    set(handles.menu_pdefix,'Enable','Off')
    set(handles.menu_fixN,'Enable','Off')
    % Enable EIG menuoptions
    set(handles.menu_sigma,'Enable','On')
    set(handles.menu_eigno,'Enable','On')
    
    
    % Clear the figures
    initialisefigures(handles,callMode)
    
    
    %     % Load a new random BVP example and change the demos popup menu
    %     handles.guifile = loadexample(handles.guifile,-1,'bvp');
    %     loadfields(handles.guifile,handles)
    
    
end


function pdeplotopts(handles,onoff)
if onoff == 1
    onoff = 'on';
elseif onoff == 0
    onoff = 'off';
end


function initialisefigures(handles,callMode)
if ~strcmpi(callMode,'demo')
    cla(handles.fig_sol,'reset');
    axes(handles.fig_sol);
    title('Solutions'), % axis off
end
cla(handles.fig_norm,'reset');
title('Updates')
