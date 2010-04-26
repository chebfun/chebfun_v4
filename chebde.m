function varargout = chebde(varargin)
% CHEBDE Help for the chebop PDE GUI
%
% Under construction


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @chebde_OpeningFcn, ...
    'gui_OutputFcn',  @chebde_OutputFcn, ...
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

% --- Executes just before chebde is made visible.
function chebde_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chebde (see VARARGIN)

% Choose default command line output for chebde
handles.output = hObject;

initialisefigures(handles)

% Synchronise slider and edit field for pause in plotting
set(handles.slider_pause,'Value',str2double(get(handles.input_pause,'String')));

% Variable that determines whether a solution is available
handles.hasSolution = 0;

% This will be set to 1 when we want to interupt the computation.
set(handles.slider_pause,'Value',false)

% Load an example depending on the user input (argument to the chebde
% call). If no argument is passed, use a random example (which we will get
% if the exampleNumber is negative).
if isempty(varargin)
    exampleNumber = -1;
else
    exampleNumber = varargin{1};
end
temppath = folderchange;
loadexample(handles,exampleNumber,'bvp')
loaddemos(handles,'bvp')

% Create a new field that stores the problem type (cleaner than checking
% for the value of the buttons every time)
handles.problemType = 'bvp';
cd(temppath)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chebde wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = chebde_OutputFcn(hObject, eventdata, handles)
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

% set(handles.input_GUESS,'String','');
set(handles.input_GUESS,'Enable','on');
set(handles.toggle_useLatest,'Value',0);
set(handles.toggle_useLatest,'Enable','off');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dom_left_CreateFcn(hObject, eventdata, handles)
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

% set(handles.input_GUESS,'String','');
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

if strcmp(get(handles.button_solve,'string'),'Solve')
% In solve mode
    % CD to the guifiles directory and call the function solveGUIBVP which does
    % all the work of managing the solution process.
    % try
        temppath = folderchange;
        if get(handles.button_bvp,'Value')
            handles = solveGUIBVP(handles);
        else
            handles = solveGUIPDE(handles);
        end
        cd(temppath)
    % catch ME
    %     error(['chebfun:PDEgui','Incorrect input for differential ' ...
    %         'equation or boundary conditions']);
    % end

    % Update the GUI and return to the original directory
    guidata(hObject, handles);
    cd(temppath);
else
    set(handles.button_solve,'Enable','Off');
end
    



function input_RBC_Callback(hObject, eventdata, handles)
% hObject    handle to input_RBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_RBC as text
%        str2double(get(hObject,'String')) returns contents of input_RBC as a double
newString = get(hObject,'String');

% For syetems we check a row at a time
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
set(handles.timedomain,'String','');
set(handles.input_DE,'String','');
set(handles.input_LBC,'String','');
set(handles.input_RBC,'String','');
set(handles.input_DE_RHS,'String','');
set(handles.input_LBC_RHS,'String','');
set(handles.input_RBC_RHS,'String','');
set(handles.input_GUESS,'String','');
set(handles.timedomain,'String','');
set(handles.input_tol,'String','');


% Clear the figures
initialisefigures(handles)

% Hide the iteration information
set(handles.iter_list,'String','');
set(handles.iter_text,'Visible','Off');
set(handles.iter_list,'Visible','Off');
set(handles.text_norm,'Visible','Off');

% Disable export figures
set(handles.button_figures,'Enable','off');
set(handles.button_solve,'Enable','on');
set(handles.button_solve,'String','Solve');

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


if get(handles.button_bvp,'Value');
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
else
    u = handles.latestSolution;
    % latestNorms = handles.latestNorms;
    tt = handles.latestSolutionT;
    figure
    if ~iscell(u)
        subplot(1,2,1);
        plot(u(:,end))
        title('Solution at final time.')
        subplot(1,2,2);
        surf(u,tt,'facecolor','interp')
    else
        v = chebfun;
        for k = 1:numel(u)
            uk = u{k};
            v(:,k) = uk(:,end);
        end
        plot(v);
    end
end

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

function input_LBC_RHS_Callback(hObject, eventdata, handles)
% hObject    handle to input_LBC_RHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_LBC_RHS as text
%        str2double(get(hObject,'String')) returns contents of
%        input_LBC_RHS as a double

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

% --- Executes on button press in toggle_useLatest.
function toggle_useLatest_Callback(hObject, eventdata, handles)
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


% --- Executes on button press in button_demos.
function button_demos_Callback(hObject, eventdata, handles)
% hObject    handle to button_demos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temppath = folderchange;
set(handles.button_solve,'Enable','On')
set(handles.button_solve,'String','Solve')
    
% Obtain the DE of all available examples
DE = '';
demoString = [];
counter = 1;

if get(handles.button_bvp,'Value')
    type = 'bvp';
    while ~strcmp(DE,'0')
        [a b DE DErhs LBC LBCrhs RBC RBCrhs guess tol name] = bvpexamples(counter,'demo');
        counter = counter+1;
        demoString = [demoString,{name}];
    end
else
    type = 'pde';
    while ~strcmp(DE,'0')
        [a b tt DE DErhs LBC LBCrhs RBC RBCrhs guess tol name] = pdeexamples(counter,'demo');
        counter = counter+1;
        demoString = [demoString,{name}];
    end
end
demoString(end) = []; % Throw away the last demo since it's the flag 0
[selection,okPressed] = listdlg('PromptString','Select a demo:',...
    'SelectionMode','single',...
    'ListString',demoString);
if okPressed
    loadexample(handles,selection,type);
end
cd(temppath)

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function timedomain_Callback(hObject, eventdata, handles)
% hObject    handle to timedomain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timedomain as text
%        str2double(get(hObject,'String')) returns contents of timedomain as a double


% --- Executes during object creation, after setting all properties.
function timedomain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timedomain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function initialisefigures(handles)
cla(handles.fig_sol,'reset');
title('Solutions'), axis off
cla(handles.fig_norm,'reset');
title('Updates'), axis off


% --- Executes on button press in button_bvp.
function button_bvp_Callback(hObject, eventdata, handles)
% hObject    handle to button_bvp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_bvp
set(handles.button_bvp,'Value',1)
set(handles.button_pde,'Value',0)
set(handles.uipanel1,'Visible','on')
set(handles.panel_updates,'Visible','on')
set(handles.text_pause1,'Visible','on')
set(handles.text_pause2,'Visible','on')
set(handles.input_pause,'Visible','on')
set(handles.slider_pause,'Visible','on')
set(handles.toggle_useLatest,'Visible','on')

set(handles.text_timedomain,'Visible','off')
set(handles.timedomain,'Visible','off')

% Load a new random BVP example and change the demos popup menu
temppath = folderchange;
loadexample(handles,-1,'bvp')
loaddemos(handles,'bvp')
cd(temppath)

% Create a new field that stores the problem type (cleaner than checking
% for the value of the buttons every time)
handles.problemType = 'bvp';
guidata(hObject, handles);

% --- Executes on button press in button_pde.
function button_pde_Callback(hObject, eventdata, handles)
% hObject    handle to button_pde (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_pde
set(handles.button_bvp,'Value',0)
set(handles.button_pde,'Value',1)
set(handles.uipanel1,'Visible','off')
set(handles.panel_updates,'Visible','off')
set(handles.text_pause1,'Visible','off')
set(handles.text_pause2,'Visible','off')
set(handles.input_pause,'Visible','off')
set(handles.slider_pause,'Visible','off')
set(handles.toggle_useLatest,'Visible','off')

set(handles.text_timedomain,'Visible','on')
set(handles.timedomain,'Visible','on')



temppath = folderchange;
loadexample(handles,-1,'pde')
loaddemos(handles,'pde')
cd(temppath)

% Create a new field that stores the problem type (cleaner than checking
% for the value of the buttons every time)
handles.problemType = 'pde';
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_demos.
function popupmenu_demos_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_demos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_demos contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_demos

demoNumber = get(hObject,'Value')-1; % Subtract 1 since Demos... is the first item in the list

if demoNumber > 0 % Only update GUI if a demo was indeed selected
temppath = folderchange;
loadexample(handles,demoNumber,handles.problemType)
cd(temppath);
end

set(hObject,'Value',1)

% --- Executes during object creation, after setting all properties.
function popupmenu_demos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_demos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function temppath = folderchange
% The function cd-s to the chebfun folder, and returns the path to the
% folder the user was currently in.
temppath = pwd;
chebfunpath = fileparts(which('chebtest.m'));
guifilepath = fullfile(chebfunpath,'guifiles');
cd(guifilepath);
