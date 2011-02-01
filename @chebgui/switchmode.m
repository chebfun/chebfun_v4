function handles = switchmode(guiObject, handles,newMode)

if strcmp(newMode,'bvp') % Going into BVP mode
    set(handles.button_ode,'Value',1)
    set(handles.button_pde,'Value',0)
    set(handles.toggle_useLatest,'Visible','on')
    % set(handles.iter_list,'Visible','on')
    % set(handles.iter_text,'Visible','on')
    % set(handles.text_norm,'Visible','on')
    set(handles.text_initial,'String','Initial guess')
    
    pdeplotopts(handles,0)
    
    
    set(handles.text_initial,'String','Initial guess')
    
    % Change the list of available options.
    % Enable ODE options
    set(handles.menu_odedampednewton,'Enable','On')
    set(handles.menu_odeplotting,'Enable','On')
    % Disable PDE options
    set(handles.menu_pdeplotting,'Enable','Off')
    set(handles.menu_pdeholdplot,'Enable','Off')
    set(handles.menu_pdefix,'Enable','Off')
    set(handles.menu_fixspacedisc,'Enable','Off')
    
    
    % Clear the figures
    initialisefigures(handles)
    
    set(handles.text_timedomain,'Visible','off')
    set(handles.timedomain,'Visible','off')
    
    %     % Load a new random BVP example and change the demos popup menu
    %     handles.guifile = loadexample(handles.guifile,-1,'bvp');
    %     loadfields(handles.guifile,handles)
    
    handles.problemType = 'bvp';
else % Going into PDE mode
    set(handles.button_ode,'Value',0)
    set(handles.button_pde,'Value',1)
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
    
    % Change the list of available options
    % Disable ODE options
    set(handles.menu_odedampednewton,'Enable','Off')
    set(handles.menu_odeplotting,'Enable','Off')
    % Enable PDE options
    set(handles.menu_pdeplotting,'Enable','On')
    set(handles.menu_pdeholdplot,'Enable','On')
    set(handles.menu_pdefix,'Enable','On')
    set(handles.menu_fixspacedisc,'Enable','On')
    
    % Clear the figures
    initialisefigures(handles)
    
    %     handles.guifile = loadexample(handles.guifile,-1,'pde');
    %     loadfields(handles.guifile,handles)
    
    handles.problemType = 'pde';
end


function pdeplotopts(handles,onoff)
if onoff == 1
    onoff = 'on';
elseif onoff == 0
    onoff = 'off';
end

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
