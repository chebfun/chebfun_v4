function varargout = chebguiwindow(varargin)
%CHEBGUIWINDOW chebfun BVP and PDE GUI for solvebvp and pde15s
% CHEBGUIWINDOW brings up the chebfun GUI for solving boundary value problems
% (BVPs) and partial differential equations (PDEs). When the GUI is shown,
% its field are loaded with a random BVP example from a collection of
% examples.
%
% The GUI allows various types of syntax for describing the differential
% equation and boundary conditions of problems. The differential equations
% can either be on anonymous function form, e.g.
%
%   @(u) diff(u,2)+x.*sin(u)
%
% or a "natural syntax form", e.g.
%   u''+x.*sin(u)
%
% Boundary conditions can be on either of these two forms, but furthermore,
% one can specify homogeneous Dirichlet or Neumann conditions simply by
% typing 'dirichlet' or 'neumann' in the relevant fields.
%
% The GUI supports system of coupled equations, where the problem can
% either be set up on quasimatrix form, e.g.
%
%   @(u) diff(u(:,1))+sin(u(:,2))
%   @(u) cos(u(:,1))+diff(u(:,2))
%
% or on multivariable form, e.g.
%
%   u'+sin(v)
%   cos(u)+v'
%
% The GUI offers users functionality to export problems by pressing the
% export button. This brings up a new dialog from which the user can select
% to export the problem to an executable .m file, or to export the
% variables to either a .mat file or directly into the Matlab workspace.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.
%
% See also chebop/solvebvp, chebfun/pde15s
%
% Copyright 2002-2010 by The Chebfun Team.


% Matlab automatically inserts comments for every callback and create
% functions of buttons, input fields etc. For cleaner code, we have removed
% these comments. For reference, here are examples of what the lines looked
% like:
%
% % --- Executes on button press in button_solve.
% function button_solve_Callback(hObject, eventdata, handles)
% % hObject    handle to button_solve (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % Hint: get(hObject,'Value') returns toggle state of solve
%
%
%
% % --- Executes during object creation, after setting all properties.
% function input_RBC_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to input_RBC (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
%
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
%
%
%
% function input_LBC_Callback(hObject, eventdata, handles)
% % hObject    handle to input_LBC (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% % Hints: get(hObject,'String') returns contents of input_LBC as text
% %        str2double(get(hObject,'String')) returns contents of input_LBC as a double


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @chebguiwindow_OpeningFcn, ...
    'gui_OutputFcn',  @chebguiwindow_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before chebguiwindow is made visible.
function chebguiwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see Output(1-x^2)*exp(-30*(x+.5)^2)Fcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chebguiwindow (see VARARGIN)

% Choose default command line output for chebguiwindow
handles.output = hObject;

initialisefigures(handles)

% Variable that determines whether a solution is available
handles.hasSolution = 0;


% Get the GUI object from the input argument
if ~isempty(varargin)
    handles.guifile = varargin{1};
else
    cgTemp = chebgui('');
    handles.guifile = loadexample(cgTemp,-1,'bvp');
end
% Create a new field that stores the problem type (cleaner than checking
% for the value of the buttons every time)
handles.problemType = handles.guifile.type;

% Store the default length of pausing between plots for BVPs
handles.ODEpause = '0.5';

% Populate the Demos menu
loaddemos(handles.guifile,handles,'bvp')
loaddemos(handles.guifile,handles,'pde')

% % Disable and enable options available based on the type of problem
% if strcmp(handles.problemType,'bvp')
%     set(handles.menu_pdesingle,'Enable','Off')
%     set(handles.menu_pdesystems,'Enable','Off')
% else
%     set(handles.menu_bvps,'Enable','Off')
%     set(handles.menu_ivps,'Enable','Off')
%     set(handles.menu_systems,'Enable','Off')
% end

% Load the input fields
loadfields(handles.guifile,handles);

% Make sure the GUI starts in the correct mode
switchmode(handles.guifile,handles,handles.guifile.type);

% Get the system font size and store in handles
s = char(com.mathworks.services.FontPrefs.getCodeFont);
if s(end-2) == '='
    fs = round(3/4*str2num(s(end-1)));
else
    fs = round(3/4*str2num(s(end-2:end-1)));
end
set(handles.tempedit,'FontSize',fs);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chebguiwindow wait for user response (see UIRESUME)
% uiwait(handles.chebguimainwindow);

% --- Outputs from this function are returned to the command line.
function varargout = chebguiwindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;

% -------------------------------------------------------------------------
% ---------- Callback functions for the objects of the GUI ----------------
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% ------------- Functions which call chebgui methods ----------------------
% -------------------------------------------------------------------------

function button_clear_Callback(hObject, eventdata, handles)
[newGUI handles] = cleargui(handles.guifile,handles);
handles.guifile = newGUI;
guidata(hObject, handles);


function button_solve_Callback(hObject, eventdata, handles)
handles = solveGUI(handles.guifile,handles);
guidata(hObject, handles);

function input_LBC_Callback(hObject, eventdata, handles)
newString = get(hObject,'String');
handles = callbackBCs(handles.guifile,handles,newString,'lbc');
handles.guifile.LBC = newString;
guidata(hObject, handles);


function input_RBC_Callback(hObject, eventdata, handles)
newString = get(hObject,'String');
handles = callbackBCs(handles.guifile,handles,newString,'rbc');
handles.guifile.RBC = newString;
guidata(hObject, handles);

% -------------------------------------------------------------------------
% --------- Functions which do their work without chebgui methods ---------
% -------------------------------------------------------------------------

function dom_left_Callback(hObject, eventdata, handles)
% Store the contents of input1_editText as a string. if the string
% is not a number then input will be empty
input = str2num(get(hObject,'String'));
% Checks to see if input is not numeric or empty. If so, default left end
% of the domain is taken to be -1.
if isempty(input) || isnan(input)
    warndlg('Left endpoint of domain unrecognized, default value -1 used.')
    set(hObject,'String','-1')
end

set(handles.input_GUESS,'Enable','on');
set(handles.toggle_useLatest,'Value',0);
set(handles.toggle_useLatest,'Enable','off');

handles.guifile.DomLeft = get(hObject,'String');
guidata(hObject, handles);


function dom_right_Callback(hObject, eventdata, handles)
input = str2num(get(hObject,'String'));
% Checks to see if input is not numeric or empty. If so, default right end
% of the domain is taken to be 1.
if isempty(input) || isnan(input)
    warndlg('Right endpoint of domain unrecognized, default value 1 used.')
    set(hObject,'String','1')
end

set(handles.input_GUESS,'Enable','on');
set(handles.toggle_useLatest,'Value',0);
set(handles.toggle_useLatest,'Enable','off');

handles.guifile.DomRight = get(hObject,'String');
guidata(hObject, handles);




% -------------------------------------------------------------------------
% ------- Functions which do their work in a couple of lines of code ------
% -------------------------------------------------------------------------

function input_GUESS_Callback(hObject, eventdata, handles)
handles.guifile.guess = get(hObject,'String');
guidata(hObject, handles);


function input_DE_Callback(hObject, eventdata, handles)
handles.guifile.DE = get(hObject,'String');
guidata(hObject, handles);


function input_tol_Callback(hObject, eventdata, handles)
handles.guifile.tol = get(hObject,'String');
guidata(hObject, handles);


function input_DE_RHS_Callback(hObject, eventdata, handles)
handles.guifile.DErhs = get(hObject,'String');
guidata(hObject, handles);

function input_LBC_RHS_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
handles.guifile.LBCrhs = get(hObject,'String');
guidata(hObject, handles);


function input_RBC_RHS_Callback(hObject, eventdata, handles)
handles.guifile.RBCrhs = get(hObject,'String');
guidata(hObject, handles);


function button_holdon_Callback(hObject, eventdata, handles)
set(handles.button_holdoff,'Value',0);


function button_holdoff_Callback(hObject, eventdata, handles)
set(handles.button_holdon,'Value',0);


function input_N_Callback(hObject, eventdata, handles)


function timedomain_Callback(hObject, eventdata, handles)


% -------------------------------------------------------------------------
% -------------------- Unsorted functions  --------------------------------
% -------------------------------------------------------------------------

function button_fignorm_Callback(hObject, eventdata, handles)

% Check the type of the problem
if get(handles.button_ode,'Value');
    latestNorms = handles.latestNorms;
    
    figure;
    
    semilogy(latestNorms,'-*'),title('Norm of updates'), xlabel('Number of iteration')
    if length(latestNorms) > 1
        XTickVec = 1:max(floor(length(latestNorms)/5),1):length(latestNorms);
        set(gca,'XTick', XTickVec), xlim([1 length(latestNorms)]), grid on
    else % Don't display fractions on iteration plots
        set(gca,'XTick', 1)
    end
else
    u = handles.latestSolution;
    % latestNorms = handles.latestNorms;
    tt = handles.latestSolutionT;
    varnames = handles.varnames;
    
    if ~iscell(u)
        figure
        waterfall(u,tt,'simple','linewidth',2)
        xlabel('x'), ylabel('t'); zlabel(varnames{1});
    else
        figure
        for k = 1:numel(u)
            subplot(1,numel(u),k);
            waterfall(u{k},tt,'simple','linewidth',2)
            xlabel('x'), ylabel('t'), zlabel(varnames{k})
            title(varnames{k})
        end
        
        tmp = u{k}(:,1);
        u1 = tmp.vals(1);
        tmp = get(tmp,'vals');
        x1 = tmp(1);
        
        figure
        cols = get(0,'DefaultAxesColorOrder');
        for k = 1:numel(u)
            plot3(x1,tt(1),u1,'linewidth',2,'color',cols(k,:)); hold on
        end
        legend(varnames{:})
        for k = 1:numel(u)
            waterfall(u{k},tt,'simple','linewidth',2,'edgecolor',cols(k,:))
        end
        xlabel('x'), ylabel('t'), grid on
    end
end

function button_figsol_Callback(hObject, eventdata, handles)
if get(handles.button_ode,'Value');
    latestSolution = handles.latestSolution;
    figure
    plot(latestSolution), title('Solution at end of iteration')
else
    u = handles.latestSolution;
    tt = handles.latestSolutionT;
    
    figure
    if ~iscell(u)
        plot(u(:,end))
        title('Solution at final time.')
    else
        v = chebfun;
        for k = 1:numel(u)
            uk = u{k};
            v(:,k) = uk(:,end);
        end
        plot(v);
        title('Solution at final time.')
    end
end


function toggle_useLatest_Callback(hObject, eventdata, handles)
newVal = get(hObject,'Value');

if newVal % User wants to use latest solution
    set(handles.input_GUESS,'String','Using latest solution');
    set(handles.input_GUESS,'Enable','Off');
else
    set(handles.input_GUESS,'String','');
    set(handles.input_GUESS,'Enable','On');
end
guidata(hObject, handles);


% --- Executes when chebguimainwindow is resized.
function chebguimainwindow_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to chebguimainwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function button_ode_Callback(hObject, eventdata, handles)
handles = switchmode(handles.guifile,handles,'bvp');
guidata(hObject, handles);


% --- Executes on button press in button_pde.
function button_pde_Callback(hObject, eventdata, handles)
handles = switchmode(handles.guifile,handles,'pde');
guidata(hObject, handles);



% --- Executes on button press in button_pdeploton.
function button_pdeploton_Callback(hObject, eventdata, handles)
% hObject    handle to button_pdeploton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_pdeploton
% set(handles.button_pdeplotoff,'Value',0);
onoff = 'on';
set(handles.button_pdeplotoff,'Value',0);
set(handles.button_pdeploton,'Value',1);
set(handles.hold_text,'Enable',onoff);
set(handles.button_holdon,'Enable',onoff);
set(handles.button_holdoff,'Enable',onoff);
set(handles.ylim_text,'Enable',onoff);
set(handles.ylim1,'Enable',onoff);
set(handles.text33,'Enable',onoff);
set(handles.ylim2,'Enable',onoff);
set(handles.plotstyle_text,'Enable',onoff);
set(handles.input_plotstyle,'Enable',onoff);


function button_pdeplotoff_Callback(hObject, eventdata, handles)
onoff = 'off';
set(handles.button_pdeploton,'Value',0);
set(handles.button_pdeplotoff,'Value',1);
set(handles.hold_text,'Enable',onoff);
set(handles.button_holdon,'Enable',onoff);
set(handles.button_holdoff,'Enable',onoff);
set(handles.ylim_text,'Enable',onoff);
set(handles.ylim1,'Enable',onoff);
set(handles.text33,'Enable',onoff);
set(handles.ylim2,'Enable',onoff);
set(handles.plotstyle_text,'Enable',onoff);
set(handles.input_plotstyle,'Enable',onoff);


function checkbox_fixN_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.N_text,'Enable','on');
    set(handles.input_N,'Enable','on');
else
    set(handles.N_text,'Enable','off');
    set(handles.input_N,'Enable','off');
end


function input_plotstyle_Callback(hObject, eventdata, handles)


% --- Executes on selection change in iter_list.
function iter_list_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns iter_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from iter_list


% -------------------------------------------------------------------------
% ---------------------- Other subfunctions -------------------------------
% -------------------------------------------------------------------------

function initialisefigures(handles)
cla(handles.fig_sol,'reset');
title('Solutions'), axis off
cla(handles.fig_norm,'reset');
title('Updates')

% -------------------------------------------------------------------------
% ----------------- All CreateFcn are stored here -------------------------
% -------------------------------------------------------------------------

function dom_left_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dom_right_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_DE_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_tol_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_DE_RHS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_RBC_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_GUESS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_LBC_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function iter_list_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fig_logo_CreateFcn(hObject, eventdata, handles)
% Hint: place code in OpeningFcn to populate
f = chebpoly(10);
axes(hObject)
plot(f,'interval',[-1,.957],'linew',3), hold on

t = - cos(pi*(2:8)'/10) *0.99;  % cheb extrema (tweaked)
y = 0*t;
h = text( t, y, num2cell(transpose('chebgui')), ...
    'fontsize',16,'hor','cen','vert','mid') ;

flist = listfonts;
k = strmatch('Rockwell',flist);  % 1st choice
k = [k; strmatch('Luxi Serif',flist)];  % 2nd choice
k = [k; strmatch('luxiserif',flist)];  % 2.5th choice
k = [k; strmatch('Times',flist)];  % 3rd choice
if ~isempty(k), set(h,'fontname',flist{k(1)}), end

axis([-1.02 .98 -2 2]), axis off


function input_RBC_RHS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_LBC_RHS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fig_sol_CreateFcn(hObject, eventdata, handles)
% Hint: place code in OpeningFcn to populate fig_sol


function fig_norm_CreateFcn(hObject, eventdata, handles)
% Hint: place code in OpeningFcn to populate fig_norm


function timedomain_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_N_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tempedit_CreateFcn(hObject, eventdata, handles)

function ylim1_CreateFcn(hObject, eventdata, handles)
function ylim1_Callback(hObject, eventdata, handles)
function ylim2_CreateFcn(hObject, eventdata, handles)
function ylim2_Callback(hObject, eventdata, handles)
function input_plotstyle_CreateFcn(hObject, eventdata, handles)

function button_solve_KeyPressFcn(hObject, eventdata, handles)


% -------------------------------------------------------------------------
% ----------------- Right-clicking functions ------------------------------
% -------------------------------------------------------------------------

function input_DE_ButtonDownFcn(hObject, eventdata, handles)
chebguiedit('chebguiwindow', handles.chebguimainwindow,'input_DE');
function input_LBC_ButtonDownFcn(hObject, eventdata, handles)
chebguiedit('chebguiwindow', handles.chebguimainwindow,'input_LBC');
function input_RBC_ButtonDownFcn(hObject, eventdata, handles)
chebguiedit('chebguiwindow', handles.chebguimainwindow,'input_RBC');
function input_GUESS_ButtonDownFcn(hObject, eventdata, handles)
chebguiedit('chebguiwindow', handles.chebguimainwindow,'input_GUESS');
function input_DE_RHS_ButtonDownFcn(hObject, eventdata, handles)
chebguiedit('chebguiwindow', handles.chebguimainwindow,'input_DE_RHS');
function input_LBC_RHS_ButtonDownFcn(hObject, eventdata, handles)
chebguiedit('chebguiwindow', handles.chebguimainwindow,'input_LBC_RHS');
function input_RBC_RHS_ButtonDownFcn(hObject, eventdata, handles)
chebguiedit('chebguiwindow', handles.chebguimainwindow,'input_RBC_RHS');

function editfontsize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------------
% ----------------- Callbacks for menu items  ----------------------------
% -------------------------------------------------------------------------

% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_opengui_Callback(hObject, eventdata, handles)
% hObject    handle to menu_opengui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_demos_Callback(hObject, eventdata, handles)
% hObject    handle to menu_demos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_bvps_Callback(hObject, eventdata, handles)
% hObject    handle to menu_bvps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_ivps_Callback(hObject, eventdata, handles)
% hObject    handle to menu_ivps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_systems_Callback(hObject, eventdata, handles)
% hObject    handle to menu_systems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_savegui_Callback(hObject, eventdata, handles)
% hObject    handle to menu_savegui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_openhelp_Callback(hObject, eventdata, handles)
% hObject    handle to menu_openhelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
doc('chebguiwindow')


% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_pdesingle_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pdesingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_pdesystems_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pdesystems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_export_Callback(hObject, eventdata, handles)
% Offer more options if a solution exists.
if handles.hasSolution
    set(handles.menu_exportmatfile,'Enable','on')
    set(handles.menu_exportworkspace,'Enable','on')
else
    set(handles.menu_exportmatfile,'Enable','off')
    set(handles.menu_exportworkspace,'Enable','off')
end

% --------------------------------------------------------------------
function menu_exportmfile_Callback(hObject, eventdata, handles)
export(handles.guifile,handles,'.m')


function menu_exportchebgui_Callback(hObject, eventdata, handles)
export(handles.guifile,handles,'GUI')


function menu_exportworkspace_Callback(hObject, eventdata, handles)
export(handles.guifile,handles,'Workspace')


function menu_exportmatfile_Callback(hObject, eventdata, handles)
export(handles.guifile,handles,'.mat')


function menu_options_Callback(hObject, eventdata, handles)

function menu_close_Callback(hObject, eventdata, handles)
delete(handles.chebguimainwindow)

function uipanel13_DeleteFcn(hObject, eventdata, handles)


function tempedit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.



function menu_odedampednewton_Callback(hObject, eventdata, handles)


function menu_odedampednewtonon_Callback(hObject, eventdata, handles)
handles.guifile.damping = '1';
set(handles.menu_odedampednewtonon,'checked','on');
set(handles.menu_odedampednewtonoff,'checked','off');
guidata(hObject, handles);


function menu_odedampednewtonoff_Callback(hObject, eventdata, handles)
handles.guifile.damping = '0';
set(handles.menu_odedampednewtonon,'checked','off');
set(handles.menu_odedampednewtonoff,'checked','on');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_odeplotting_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_pdeplotting_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pdeplotting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_odeplottingon_Callback(hObject, eventdata, handles)
handles.guifile.plotting = handles.ODEpause; % Obtain length of pause from handles
set(handles.menu_odeplottingon,'checked','on');
set(handles.menu_odeplottingoff,'checked','off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_odeplottingoff_Callback(hObject, eventdata, handles)
handles.guifile.plotting = 'off'; % Should store value of plotting length
set(handles.menu_odeplottingon,'checked','off');
set(handles.menu_odeplottingoff,'checked','on');
guidata(hObject, handles)


% --------------------------------------------------------------------
function menu_odeplottingpause_Callback(hObject, eventdata, handles)
options.WindowStyle = 'modal';
valid = 0;
while ~valid
    pauseInput = inputdlg('Length of pause between plots:','Set pause length',...
        1,{handles.ODEpause},options);
    if isempty(pause) % User pressed cancel
        break
    elseif ~isempty(str2num(pauseInput{1})) % Valid input
        valid = 1;
        handles.ODEpause = pauseInput{1};
        % Update length of pause in the chebgui object if it's not off
        if ~strcmp(handles.guifile.plotting,'off')
            handles.guifile.plotting = pauseInput{1}; 
        end
    else
        f = errordlg('Invalid input.', 'Chebgui error', 'modal');
        uiwait(f); 
    end
end
guidata(hObject, handles)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_pdeholdplot_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pdeholdplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_pdefix_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pdefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_pdeplotfield_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pdeplotfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_pdeholdploton_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pdeholdploton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_pdeholdplotoff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pdeholdplotoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_pdeplottingon_Callback(hObject, eventdata, handles)
handles.guifile.plotting = 'on'; % Obtain length of pause from handles
set(handles.menu_pdeplottingon,'checked','on');
set(handles.menu_pdeplottingoff,'checked','off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_pdeplottingoff_Callback(hObject, eventdata, handles)
handles.guifile.plotting = 'off'; % Obtain length of pause from handles
set(handles.menu_pdeplottingon,'checked','off');
set(handles.menu_pdeplottingoff,'checked','on');
guidata(hObject, handles);
