function loaddemos(guifile,handles,type)


set(handles.button_solve,'Enable','On')
set(handles.button_solve,'String','Solve')
    
% Obtain the DE of all available examples
DE = '';
demoString = 'Demos...';
counter = 1;

if strcmp(type,'bvp') % Setup BVPs demos
    while ~strcmp(DE,'0')
        [a b DE DErhs LBC LBCrhs RBC RBCrhs guess tol name] = bvpexamples(guifile,counter,'demo');
        counter = counter+1;
        demoString = [demoString,{name}];
    end
else                % Setup PDEs demos
    while ~strcmp(DE,'0')
        [a b tt DE DErhs LBC LBCrhs RBC RBCrhs guess tol name] = pdeexamples(guifile,counter,'demo');
        counter = counter+1;
        demoString = [demoString,{name}];
    end
end
demoString(end) = []; % Throw away the last demo since it's the flag 0

set(handles.popupmenu_demos,'String',demoString)
% 
% [selection,okPressed] = listdlg('PromptString','Select a demo:',...
%     'SelectionMode','single',...
%     'ListString',demoString);
% if okPressed
%     loadexample(handles,selection,type);
% end