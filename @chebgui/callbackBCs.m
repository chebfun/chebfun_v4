function handles = callbackBCs(guifile, handles, inputString, type)



% For systems we check a row at a time
flag = false; flag2 = false;
if ~iscell(inputString)
    for stringCounter = 1:size(inputString,1)
        newString{stringCounter,:} = inputString(stringCounter,:);
    end
else
    newString = inputString;
end

for k = 1:numel(newString)
    if ~isempty(strfind(newString{k},'@')) || strcmpi(newString{k},'dirichlet') ...
            || strcmpi(newString{k},'neumann') || ~isempty(str2num(newString{k}))
        flag = true; break
    elseif strcmpi(newString{k},'periodic');
        flag = true; flag2 = true; break
    end
end

if strcmp(type,'lbc')
    if flag
        set(handles.input_LBC_RHS,'Enable','off');
        set(handles.input_LBC_RHS,'String','');
        set(handles.text_eq2,'Enable','off');
    else
        set(handles.input_LBC_RHS,'Enable','on');
        set(handles.text_eq2,'Enable','on');
    end
    
    if flag2
        set(handles.input_RBC,'String','');
        set(handles.input_RBC,'Enable','off');
        set(handles.input_RBC_RHS,'String','');
        set(handles.input_RBC_RHS,'Enable','off');
        set(handles.text_eq3,'Enable','off');
    else
        set(handles.input_RBC,'Enable','on');
    end
else
    if flag
        set(handles.input_RBC_RHS,'Enable','off');
        set(handles.text_eq3,'Enable','off');
        set(handles.input_RBC_RHS,'String','');
    else
        set(handles.input_RBC_RHS,'Enable','on');
        set(handles.text_eq3,'Enable','on');
    end
    
    if flag2
        set(handles.input_LBC,'String','');
        set(handles.input_LBC,'Enable','off');
        set(handles.input_LBC_RHS,'String','');
        set(handles.input_LBC_RHS,'Enable','off');
        set(handles.text_eq2,'Enable','off');
    else
        set(handles.input_LBC,'Enable','on');
    end
end