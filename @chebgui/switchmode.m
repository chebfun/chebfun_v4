function handles = switchmode(guiObject, handles,newMode)

if strcmp(newMode,'bvp') % Going into BVP mode
    set(handles.button_ode,'Value',1)
    set(handles.button_pde,'Value',0)
    set(handles.uipanel1,'Visible','on')
    set(handles.panel_updates,'Visible','on')
    set(handles.text_pause1,'Visible','on')
    set(handles.text_pause2,'Visible','on')
    set(handles.input_pause,'Visible','on')
    set(handles.slider_pause,'Visible','on')
    set(handles.toggle_useLatest,'Visible','on')
    % set(handles.iter_list,'Visible','on')
    % set(handles.iter_text,'Visible','on')
    % set(handles.text_norm,'Visible','on')
    set(handles.text_initial,'String','Initial guess')
    
    pdeplotopts(handles,0)
    
    
    set(handles.text_initial,'String','Initial guess')
    
    % Clear the figures
    initialisefigures(handles)
    
    set(handles.text_timedomain,'Visible','off')
    set(handles.timedomain,'Visible','off')
    
    % Load a new random BVP example and change the demos popup menu
    handles.guifile = loadexample(handles.guifile,-1,'bvp');
    loadfields(handles.guifile,handles)
    
    % Disable and enable demo selection based on the type of problem
    set(handles.menu_pdesingle,'Enable','Off')
    set(handles.menu_pdesystems,'Enable','Off')
    set(handles.menu_bvps,'Enable','On')
    set(handles.menu_ivps,'Enable','On')
    set(handles.menu_systems,'Enable','On')
    
    handles.problemType = 'bvp';
else % Going into PDE mode
    set(handles.button_ode,'Value',0)
    set(handles.button_pde,'Value',1)
    set(handles.uipanel1,'Visible','off')
    set(handles.panel_updates,'Visible','off')
    set(handles.text_pause1,'Visible','off')
    set(handles.text_pause2,'Visible','off')
    set(handles.input_pause,'Visible','off')
    set(handles.slider_pause,'Visible','off')
    set(handles.toggle_useLatest,'Visible','off')
    set(handles.iter_list,'Visible','off')
    set(handles.iter_text,'Visible','off')
    set(handles.text_norm,'Visible','off')
    set(handles.text_initial,'String','Initial condition')
    
    pdeplotopts(handles,1)
    
    set(handles.input_GUESS,'Enable','On')
    set(handles.toggle_useLatest,'Value',0)
    
    set(handles.text_timedomain,'Visible','on')
    set(handles.timedomain,'Visible','on')
    set(handles.timedomain,'Visible','on')
    
    % Clear the figures
    initialisefigures(handles)
    
    handles.guifile = loadexample(handles.guifile,-1,'pde');
    loadfields(handles.guifile,handles)
    
    % Disable and enable demo selection based on the type of problem
    set(handles.menu_pdesingle,'Enable','On')
    set(handles.menu_pdesystems,'Enable','On')
    set(handles.menu_bvps,'Enable','Off')
    set(handles.menu_ivps,'Enable','Off')
    set(handles.menu_systems,'Enable','Off')
    
    handles.problemType = 'pde';
end


function pdeplotopts(handles,onoff)
% The function cd-s to the chebfun folder, and returns the path to the
% folder the user was currently in.
if onoff == 1
    onoff = 'on';
elseif onoff == 0
    onoff = 'off';
end

set(handles.plot_text,'visible',onoff);
set(handles.button_pdeploton,'visible',onoff);
set(handles.button_pdeplotoff,'visible',onoff);
set(handles.hold_text,'visible',onoff);
set(handles.button_holdon,'visible',onoff);
set(handles.button_holdoff,'visible',onoff);
set(handles.ylim_text,'visible',onoff);
set(handles.ylim1,'visible',onoff);
set(handles.text33,'visible',onoff);
set(handles.ylim2,'visible',onoff);
set(handles.plotstyle_text,'visible',onoff);
set(handles.input_plotstyle,'visible',onoff);
set(handles.FixN_text,'visible',onoff);
set(handles.checkbox_fixN,'visible',onoff);
set(handles.N_text,'visible',onoff);
set(handles.input_N,'visible',onoff);


function initialisefigures(handles)
cla(handles.fig_sol,'reset');
title('Solutions'), axis off
cla(handles.fig_norm,'reset');
title('Updates')
