function loadfields(guifile,handles)

% Fill the String fields of the handles
set(handles.dom_left,'String',guifile.DomLeft);
set(handles.dom_right,'String',guifile.DomRight);
set(handles.input_DE,'String',guifile.DE);
set(handles.input_DE_RHS,'String',guifile.DErhs);
set(handles.input_LBC,'String',guifile.LBC);
set(handles.input_LBC_RHS,'String',guifile.LBCrhs);
set(handles.input_RBC,'String',guifile.RBC);
set(handles.input_RBC_RHS,'String',guifile.RBCrhs);
set(handles.input_GUESS,'String',guifile.guess);
set(handles.input_tol,'String',guifile.tol);

if strcmpi(guifile.type,'pde')
    set(handles.timedomain,'String',guifile.timedomain);
end

% Change the checking of menu options
if strcmpi(guifile.type,'pde')
    set(handles.timedomain,'String',guifile.timedomain);
    
    if ~strcmp(guifile.damping,'off')
        set(handles.menu_pdeplottingon,'Checked','On');
        set(handles.menu_pdeplottingoff,'Checked','Off');
    else
        set(handles.menu_pdeplottingon,'Checked','Off');
        set(handles.menu_pdeplottingoff,'Checked','On');
    end
else
    if strcmp(guifile.damping,'1')
        set(handles.menu_odedampednewtonon,'Checked','On');
        set(handles.menu_odedampednewtonoff,'Checked','Off');
    else
        set(handles.menu_odedampednewtonon,'Checked','Off');
        set(handles.menu_odedampednewtonoff,'Checked','On');
    end
    
    if ~strcmp(guifile.damping,'off')
        set(handles.menu_odeplottingon,'Checked','On');
        set(handles.menu_odeplottingoff,'Checked','Off');
    else
        set(handles.menu_odeplottingon,'Checked','Off');
        set(handles.menu_odeplottingoff,'Checked','On');
    end
end



%
% % If input for BCs is a number, anon. func. or dirichlet/neumann,
% % disable BC rhs input
% lflag = false;
% if ~iscell(LBC), LBC = {LBC}; end
% for k = 1:numel(LBC)
%     if ~isempty(strfind(LBC{k},'@')) || strcmpi(LBC{k},'dirichlet') ...
%         || strcmpi(LBC{k},'neumann') || ~isempty(str2num(LBC{k}))
%         lflag = true; break
%     end
% end
% if lflag
%     set(handles.input_LBC_RHS,'Enable','off');
%     set(handles.text_eq2,'Enable','off');
% else
%     set(handles.input_LBC_RHS,'Enable','on');
%     set(handles.text_eq2,'Enable','on');
% end
%
% rflag = false;
% if ~iscell(RBC), RBC = {RBC}; end
% for k = 1:numel(RBC)
%     if ~isempty(strfind(RBC{k},'@')) || strcmpi(RBC{k},'dirichlet') ...
%         || strcmpi(RBC{k},'neumann') || ~isempty(str2num(RBC{k}))
%         rflag = true; break
%     end
% end
% if rflag
%     set(handles.input_RBC_RHS,'Enable','off');
%     set(handles.text_eq3,'Enable','off');
% else
%     set(handles.input_RBC_RHS,'Enable','on');
%     set(handles.text_eq3,'Enable','on');
% end
