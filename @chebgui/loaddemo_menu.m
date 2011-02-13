function loaddemo_menu(guifile,handles,type)

% Obtain the DE of all available examples
DE = '';
counter = 1;

% Set up ODEs and PDEs separately
if strcmp(type,'bvp') % Setup BVPs demos
    while 1
        [cg name demotype] = bvpdemos(guifile,counter,'demo');
        if strcmp(name,'stop')
            break
        else
            demoFun = @(hObject,eventdata) hOpenMenuitemCallback(hObject, eventdata,handles,type,counter);
            switch demotype
                case 'bvp'
                    hDemoitem  =  uimenu('Parent',handles.menu_bvps,...
                        'Label',name,...
                        'Separator','off',...
                        'HandleVisibility','callback', ...
                        'Callback', demoFun);
                case 'ivp'
                    hDemoitem  =  uimenu('Parent',handles.menu_ivps,...
                        'Label',name,...
                        'Separator','off',...
                        'HandleVisibility','callback', ...
                        'Callback', demoFun);
                case 'system'
                    hDemoitem  =  uimenu('Parent',handles.menu_systems,...
                        'Label',name,...
                        'Separator','off',...
                        'HandleVisibility','callback', ...
                        'Callback', demoFun);
            end
        end
        counter = counter+1;
    end
elseif strcmp(type,'pde')                % Setup PDEs demos
    while 1
        [cg name demotype] = pdedemos(guifile,counter,'demo');
        if strcmp(name,'stop')
            break
        else
            demoFun = @(hObject,eventdata) hOpenMenuitemCallback(hObject, eventdata,handles,type,counter);
            switch demotype
                case 'scalar'
                    hDemoitem  =  uimenu('Parent',handles.menu_pdesingle,...
                        'Label',name,...
                        'Separator','off',...
                        'HandleVisibility','callback', ...
                        'Callback', demoFun);
                case 'system'
                    hDemoitem  =  uimenu('Parent',handles.menu_pdesystems,...
                        'Label',name,...
                        'Separator','off',...
                        'HandleVisibility','callback', ...
                        'Callback', demoFun);
            end
        end
        counter = counter+1;
    end
else % eig demos
    while 1
        [cg name demotype] = eigdemos(guifile,counter,'demo');
        if strcmp(name,'stop')
            break
        else
            demoFun = @(hObject,eventdata) hOpenMenuitemCallback(hObject, eventdata,handles,type,counter);
            switch demotype
                case 'scalar'
                    hDemoitem  =  uimenu('Parent',handles.menu_eigsscalar,...
                        'Label',name,...
                        'Separator','off',...
                        'HandleVisibility','callback', ...
                        'Callback', demoFun);
                case 'system'
                    hDemoitem  =  uimenu('Parent',handles.menu_eigssystem,...
                        'Label',name,...
                        'Separator','off',...
                        'HandleVisibility','callback', ...
                        'Callback', demoFun);                    
            end
        end
        counter = counter+1;
    end
end


function hOpenMenuitemCallback(hObject, eventdata,handles,type,demoNumber)
% Callback function run when the Open menu item is selected
handles.guifile = loadexample(handles.guifile,demoNumber,type);
initSuccess = loadfields(handles.guifile,handles);
if initSuccess, switchModeCM = 'demo'; else switchModeCM = 'notdemo'; end 
% Swith the mode of the GUI according to the type of the problem.
switchmode(handles.guifile,handles,type,switchModeCM);
% Update handle structure
guidata(hObject, handles);
