function loaddemo_menu(guifile,handles)

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Begin by checking whether we have already loaded the demos
if ~isempty(get(handles.menu_demos,'UserData'))
    return
end

% Set up ODEs, PDEs and EIGs demos separately
% Begin by setting up BVPs demos
type = 'bvp';
counter = 1;

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

% Now PDEs demos
type = 'pde';
counter = 1;
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

% Finally EIGs demos
type = 'eig';
counter = 1;
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

% Notify that we have loaded demos to prevent reloading
set(handles.menu_demos,'UserData',1);


function hOpenMenuitemCallback(hObject, eventdata,handles,type,demoNumber)
% Callback function run when the Open menu item is selected
handles.guifile = loadexample(handles.guifile,demoNumber,type);
initSuccess = loadfields(handles.guifile,handles);
if initSuccess, switchModeCM = 'demo'; else switchModeCM = 'notdemo'; end 
% Swith the mode of the GUI according to the type of the problem.
switchmode(handles.guifile,handles,type,switchModeCM);
% Update handle structure
guidata(hObject, handles);
