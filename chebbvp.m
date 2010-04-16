function varargout = chebbvp(varargin)
% CHEBBVP Help for the chebop BVP GUI
%
% Under construction

% CHEBBVP M-file for chebbvp.fig
%      CHEBBVP, by itself, creates a new CHEBBVP or raises the existing
%      singleton*.
%
%      H = CHEBBVP returns the handle to a new CHEBBVP or the handle to
%      the existing singleton*.
%
%      CHEBBVP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHEBBVP.M with the given input arguments.
%
%      CHEBBVP('Property','Value',...) creates a new CHEBBVP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chebbvp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chebbvp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chebbvp

% Last Modified by GUIDE v2.5 06-Apr-2010 16:55:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @chebbvp_OpeningFcn, ...
    'gui_OutputFcn',  @chebbvp_OutputFcn, ...
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

% --- Executes just before chebbvp is made visible.
function chebbvp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chebbvp (see VARARGIN)

% Choose default command line output for chebbvp
handles.output = hObject;

axes(handles.fig_sol);
fill([0 0 1 1],[0 1 1 0],[1 1 1]), title('Solutions'), axis off

axes(handles.fig_norm);
fill([0 0 1 1],[0 1 1 0],[1 1 1]), title('Updates'), axis off

% Synchronise slider and edit field for pause in plotting
set(handles.slider_pause,'Value',str2double(get(handles.input_pause,'String')));

% Variable that determines whether a solution is available
handles.hasSolution = 0;

% Load an example depending on the user input (argument to the chebbvp
% call). If no argument is passed, use a random example (which we will get
% if the exampleNumber is negative).
if isempty(varargin)
    exampleNumber = -1;
else
    exampleNumber = varargin{1};
end

loadExample(handles,exampleNumber)

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes chebbvp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = chebbvp_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dom_left_Callback(hObject, eventdata, handles)
% hObject    handle to dom_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dom_left as text
%        str2double(get(hObject,'String')) returns contents of dom_left as a double
%store the contents of input1_editText as a string. if the string
%is not a number then input will be empty
input = str2double(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
    set(hObject,'String','0')
end

set(handles.input_GUESS,'String','');
set(handles.input_GUESS,'Enable','on');
set(handles.toggle_useLatest,'Value',0);
set(handles.toggle_useLatest,'Enable','off');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dom_left_CreateFcn(hObject, eventdata, handles)  %#ok<*INUSD>
% hObject    handle to dom_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dom_right_Callback(hObject, eventdata, handles)
% hObject    handle to dom_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dom_right as text
%        str2double(get(hObject,'String')) returns contents of dom_right as a double
input = str2double(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
    set(hObject,'String','0')
end

set(handles.input_GUESS,'String','');
set(handles.input_GUESS,'Enable','on');
set(handles.toggle_useLatest,'Value',0);
set(handles.toggle_useLatest,'Enable','off');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dom_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dom_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_solve.
function button_solve_Callback(hObject, eventdata, handles)
% hObject    handle to button_solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CD to the guifiles directory and call the function solveGUIBVP which does
% all the work of managing the solution process.
try
    temppath = pwd;
    chebfunpath = fileparts(which('chebtest.m'));
    guifilepath = fullfile(chebfunpath,'guifiles');
    cd(guifilepath);
    handles = solveGUIBVP(handles);
    cd(temppath)
catch ME
    error(['chebfun:BVPgui','Incorrect input for differential ' ...
        'equation or boundary conditions']);
end

% Update the GUI and return to the original directory
guidata(hObject, handles);
cd(temppath);

function input_RBC_Callback(hObject, eventdata, handles)
% hObject    handle to input_RBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_RBC as text
%        str2double(get(hObject,'String')) returns contents of input_RBC as a double
newString = get(hObject,'String');
flag = false;
if ~iscell(newString), newString = {newString}; end
for k = 1:numel(newString)
    if ~isempty(strfind(newString{k},'@')) || strcmpi(newString{k},'dirichlet') ...
        || strcmpi(newString{k},'neumann') || ~isempty(str2num(newString{k}))
        flag = true; break
    end
end
if flag
    set(handles.input_RBC_RHS,'Enable','off');
    set(handles.text_eq3,'Enable','off');
    set(handles.input_RBC_RHS,'String','');
else
    set(handles.input_RBC_RHS,'Enable','on');
    set(handles.text_eq3,'Enable','on');
end

% --- Executes during object creation, after setting all properties.
function input_RBC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_RBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_GUESS_Callback(hObject, eventdata, handles)
% hObject    handle to input_GUESS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_GUESS as text
%        str2double(get(hObject,'String')) returns contents of input_GUESS as a double


% --- Executes during object creation, after setting all properties.
function input_GUESS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_GUESS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function input_LBC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_LBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_DE_Callback(hObject, eventdata, handles)
% hObject    handle to input_DE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_DE as text
%        str2double(get(hObject,'String')) returns contents of input_DE as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function input_DE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_DE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on button_solve and none of its controls.
function button_solve_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to button_solve (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over button_solve.
function button_solve_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to button_solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function input_tol_Callback(hObject, eventdata, handles)
% hObject    handle to input_tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_tol as text
%        str2double(get(hObject,'String')) returns contents of input_tol as a double


% --- Executes during object creation, after setting all properties.
function input_tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function input_DE_RHS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_DE_RHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_help.
function button_help_Callback(hObject, eventdata, handles)
% hObject    handle to button_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
doc('chebbvp')


% --- Executes during object creation, after setting all properties.
function iter_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iter_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fig_logo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fig_logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate
f = chebpoly(10);
axes(hObject)
plot(f,'interval',[-1,.957],'linew',3), hold on

t = - cos(pi*(2:8)'/10) *0.99;  % cheb extrema (tweaked)
y = 0*t;
h = text( t, y, num2cell(transpose('chebfun')), ...
    'fontsize',16,'hor','cen','vert','mid') ;

flist = listfonts;
k = strmatch('Rockwell',flist);  % 1st choice
k = [k; strmatch('Luxi Serif',flist)];  % 2nd choice
k = [k; strmatch('Times',flist)];  % 3rd choice
if ~isempty(k), set(h,'fontname',flist{k(1)}), end

axis([-1.02 .98 -2 2]), axis off


% --- Executes on button press in button_clear.
function button_clear_Callback(hObject, eventdata, handles)
% hObject    handle to button_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear the input fields
set(handles.dom_left,'String','');
set(handles.dom_right,'String','');
set(handles.input_DE,'String','');
set(handles.input_LBC,'String','');
set(handles.input_RBC,'String','');
set(handles.input_DE_RHS,'String','');
set(handles.input_LBC_RHS,'String','');
set(handles.input_RBC_RHS,'String','');
set(handles.input_tol,'String','');


% Clear the figures
axes(handles.fig_sol);
fill([0 0 1 1],[0 1 1 0],[1 1 1]), title('Solutions'), axis off
axes(handles.fig_norm);
fill([0 0 1 1],[0 1 1 0],[1 1 1]), title('Updates'), axis off

% Hide the iteration information
set(handles.iter_list,'String','');
set(handles.iter_text,'Visible','Off');
set(handles.iter_list,'Visible','Off');
set(handles.text_norm,'Visible','Off');

% Disable export figures
set(handles.button_figures,'Enable','off');

% Enable RHS of BCs again
set(handles.input_LBC_RHS,'Enable','on');
set(handles.input_RBC_RHS,'Enable','on');

% We don't have a solution available anymore
handles.hasSolution = 0;

guidata(hObject, handles);



% --- Executes on button press in button_figures.
function button_figures_Callback(hObject, eventdata, handles)
% hObject    handle to button_figures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
latestSolution = handles.latestSolution;
latestNorms = handles.latestNorms;

figure;
subplot(1,2,1);
plot(latestSolution), title('Solution at end of iteration')


subplot(1,2,2);
semilogy(latestNorms,'-*'),title('Norm of updates'), xlabel('Number of iteration')
if length(latestNorms) > 1
    XTickVec = 1:max(floor(length(latestNorms)/5),1):length(latestNorms);
    set(gca,'XTick', XTickVec), xlim([1 length(latestNorms)]), grid on
else % Don't display fractions on iteration plots
    set(gca,'XTick', 1)
end
set(gcf,'Position',[270   305   685   299]);

% --- Executes during object creation, after setting all properties.
function input_RBC_RHS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_RBC_RHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function input_LBC_RHS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_LBC_RHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_DE_RHS_Callback(hObject, eventdata, handles)
% hObject    handle to input_DE_RHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_DE_RHS as text
%        str2double(get(hObject,'String')) returns contents of input_DE_RHS as a double



function input_LBC_RHS_Callback(hObject, eventdata, handles)
% hObject    handle to input_LBC_RHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_LBC_RHS as text
%        str2double(get(hObject,'String')) returns contents of input_LBC_RHS as a double



function input_RBC_RHS_Callback(hObject, eventdata, handles)
% hObject    handle to input_RBC_RHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_RBC_RHS as text
%        str2double(get(hObject,'String')) returns contents of input_RBC_RHS as a double



function input_LBC_Callback(hObject, eventdata, handles)
% hObject    handle to input_LBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_LBC as text
%        str2double(get(hObject,'String')) returns contents of input_LBC as a double
newString = get(hObject,'String');
flag = false;
if ~iscell(newString), newString = {newString}; end
for k = 1:numel(newString)
    if ~isempty(strfind(newString{k},'@')) || strcmpi(newString{k},'dirichlet') ...
        || strcmpi(newString{k},'neumann') || ~isempty(str2num(newString{k}))
        flag = true; break
    end
end
if flag
    set(handles.input_LBC_RHS,'Enable','off');
    set(handles.input_LBC_RHS,'String','');
    set(handles.text_eq2,'Enable','off');
else
    set(handles.input_LBC_RHS,'Enable','on');
    set(handles.text_eq2,'Enable','on');
end

% --- Executes on slider movement.
function slider_pause_Callback(hObject, eventdata, handles)
% hObject    handle to slider_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% currVal = str2double(get(handles.input_pause,'String'));
% set(handles.input_pause,'String',num2str(currVal+0.1))
set(handles.input_pause,'String',get(hObject,'Value'))
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_pause_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',0.5);


function input_pause_Callback(hObject, eventdata, handles)
% hObject    handle to input_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_pause as text
%        str2double(get(hObject,'String')) returns contents of input_pause as a double

% Update the slider to include the input from the field (i.e. if the user
% specifies the length of the pause without using the slider).

newVal = str2double(get(hObject,'String'));
maxVal = get(handles.slider_pause,'Max');
minVal = get(handles.slider_pause,'Min');
if isnan (newVal) % Not a number input
    set(hObject,'String',get(handles.slider_pause,'Value'));
elseif newVal >= minVal && newVal <= maxVal
    set(handles.slider_pause,'Value',newVal);
else
    extremaVal = maxVal*(sign(newVal)+1)/2; % Either 0 or maxVal
    set(handles.slider_pause,'Value',extremaVal);
    set(hObject,'String',extremaVal);
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function input_pause_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fig_sol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fig_sol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate fig_sol

% --- Executes during object creation, after setting all properties.
function fig_norm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fig_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate fig_norm


% --- Executes when selected object is changed in panel_updates.
function panel_updates_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_updates
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if eventdata.NewValue < eventdata.OldValue % Changed from on to off
    set(handles.input_pause,'Enable','off')
    set(handles.slider_pause,'Enable','off')
    set(handles.text_pause1,'Enable','off')
    set(handles.text_pause2,'Enable','off')
else
    set(handles.input_pause,'Enable','on')
    set(handles.slider_pause,'Enable','on')
    set(handles.text_pause1,'Enable','on')
    set(handles.text_pause2,'Enable','on')
end

guidata(hObject, handles);


% --- Executes on button press in button_export.
function button_export_Callback(hObject, eventdata, handles)
% hObject    handle to button_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_export

% Change to the guifiles path for neater code    
try   
    temppath = pwd;
    chebfunpath = fileparts(which('chebtest.m'));
    guifilepath = fullfile(chebfunpath,'guifiles');
    
    cd(guifilepath)
    export(handles);
    cd(temppath)
catch ME
    cd(temppath)
    ME
end






% --- Executes on button press in toggle_useLatest.
function toggle_useLatest_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to toggle_useLatest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_useLatest
newVal = get(hObject,'Value');

if newVal % User wants to use latest solution
    set(handles.input_GUESS,'String','Using latest solution');
    set(handles.input_GUESS,'Enable','Off');
else
    set(handles.input_GUESS,'String','');
    set(handles.input_GUESS,'Enable','On');
end
guidata(hObject, handles);


% --- Used to load example into the GUI
function loadExample(handles,exampleNumber)
try
    % cd to the folder that contains the gui-work files
    chebfunpath = which('chebfun');
    guifilepath = [chebfunpath(1:end-18), 'guifiles'];
    tmppath = pwd;
    cd(guifilepath)
    
    [a,b,DE,DErhs,LBC,LBCrhs,RBC,RBCrhs,guess,tol] = bvpexamples(exampleNumber);
    
    
    % Fill the String fields of the handles
    set(handles.dom_left,'String',a);
    set(handles.dom_right,'String',b);
    set(handles.input_DE,'String',DE);
    set(handles.input_DE_RHS,'String',DErhs);
    set(handles.input_LBC,'String',LBC);
    set(handles.input_LBC_RHS,'String',LBCrhs);
    set(handles.input_RBC,'String',RBC);
    set(handles.input_RBC_RHS,'String',RBCrhs);
    set(handles.input_GUESS,'String',guess);
    set(handles.input_tol,'String',tol);
    
    % If input for BCs is a number, anon. func. or dirichlet/neumann,
    % disable BC rhs input
    lflag = false;
    if ~iscell(LBC), LBC = {LBC}; end
    for k = 1:numel(LBC)
        if ~isempty(strfind(LBC{k},'@')) || strcmpi(LBC{k},'dirichlet') ...
            || strcmpi(LBC{k},'neumann') || ~isempty(str2num(LBC{k}))
            lflag = true; break
        end
    end
    if lflag
        set(handles.input_LBC_RHS,'Enable','off');
        set(handles.text_eq2,'Enable','off');
    else
        set(handles.input_LBC_RHS,'Enable','on');
        set(handles.text_eq2,'Enable','on');
    end
    
    rflag = false;
    if ~iscell(RBC), RBC = {RBC}; end
    for k = 1:numel(RBC)
        if ~isempty(strfind(RBC{k},'@')) || strcmpi(RBC{k},'dirichlet') ...
            || strcmpi(RBC{k},'neumann') || ~isempty(str2num(RBC{k}))
            rflag = true; break
        end
    end
    if rflag
        set(handles.input_RBC_RHS,'Enable','off');
        set(handles.text_eq3,'Enable','off');
    else
        set(handles.input_RBC_RHS,'Enable','on');
        set(handles.text_eq3,'Enable','on');
    end
    cd(tmppath)
catch
    error(['chebfun:BVPgui','Error loading an example']);
end


% --- Executes on button press in button_demos.
function button_demos_Callback(hObject, eventdata, handles)
% hObject    handle to button_demos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chebfunpath = which('chebfun');
guifilepath = [chebfunpath(1:end-18), 'guifiles'];
tmppath = pwd;
cd(guifilepath)

% Obtain the DE of all available examples
DE = '';
demoString = [];
counter = 1;
while ~strcmp(DE,'0')
    [a b DE DErhs LBC LBCrhs RBC RBCrhs guess tol name] = bvpexamples(counter,'demo');
    counter = counter+1;
    demoString = [demoString,{name}];
end
demoString(end) = []; % Throw away the last demo since it's the flag 0
[selection,okPressed] = listdlg('PromptString','Select a demo:',...
    'SelectionMode','single',...
    'ListString',demoString);
if okPressed
    loadExample(handles,selection);
end
cd(tmppath)


% --- Executes on button press in button_stop.
function button_stop_Callback(hObject, eventdata, handles)
% hObject    handle to button_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
