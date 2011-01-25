function loaddemos(guifile,handles,type)


% Obtain the DE of all available examples
DE = '';
counter = 1;

% Set up ODEs and PDEs separately
if strcmp(type,'bvp') % Setup BVPs demos
    while 1
        [a b DE DErhs LBC LBCrhs RBC RBCrhs guess tol name demotype] = bvpexamples(guifile,counter,'demo');
        if strcmp(DE,'0')
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
else                % Setup PDEs demos
    while 1
        [a b tt DE DErhs LBC LBCrhs RBC RBCrhs guess tol name demotype] = pdeexamples(guifile,counter,'demo');
        if strcmp(DE,'0')
            break
        else
            demoFun = @(hObject,eventdata) hOpenMenuitemCallback(hObject, eventdata,handles,type,counter);
            switch demotype
                case 'single'
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
end


function hOpenMenuitemCallback(hObject, eventdata,handles,type,demoNumber)
% Callback function run when the Open menu item is selected
handles.guifile = loadexample(handles.guifile,demoNumber,type);
loadfields(handles.guifile,handles);
% Update handle structure
guidata(hObject, handles);
