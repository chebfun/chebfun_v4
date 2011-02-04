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
    if flag2
        set(handles.input_RBC,'String','');
        set(handles.input_RBC,'Enable','off');
    else
        set(handles.input_RBC,'Enable','on');
    end
else
    if flag2
        set(handles.input_LBC,'String','');
        set(handles.input_LBC,'Enable','off');
    else
        set(handles.input_LBC,'Enable','on');
    end
end