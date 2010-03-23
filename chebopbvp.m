function varargout = chebopbvp(varargin)
% CHEBOPBVP M-file for chebopbvp.fig
%      CHEBOPBVP, by itself, creates a new CHEBOPBVP or raises the existing
%      singleton*.
%
%      H = CHEBOPBVP returns the handle to a new CHEBOPBVP or the handle to
%      the existing singleton*.
%
%      CHEBOPBVP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHEBOPBVP.M with the given input arguments.
%
%      CHEBOPBVP('Property','Value',...) creates a new CHEBOPBVP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chebopbvp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chebopbvp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chebopbvp

% Last Modified by GUIDE v2.5 23-Mar-2010 14:46:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chebopbvp_OpeningFcn, ...
                   'gui_OutputFcn',  @chebopbvp_OutputFcn, ...
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


% --- Executes just before chebopbvp is made visible.
function chebopbvp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chebopbvp (see VARARGIN)

% Choose default command line output for chebopbvp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chebopbvp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = chebopbvp_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);

% --- Executes on button press in button_solve.
function button_solve_Callback(hObject, eventdata, handles)
% hObject    handle to button_solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = str2double(get(handles.dom_left,'String'));
b = str2double(get(handles.dom_right,'String'));
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together

[d,x] = domain(a,b);
% try
%     Switch cheboppref between current and selected state
DE = eval(get(handles.input_DE,'String'));

lbcInput = get(handles.input_LBC,'String');
rbcInput = get(handles.input_RBC,'String');

lbcNum = str2num(lbcInput);
rbcNum = str2num(rbcInput);

if isnumeric(lbcNum)
    LBC = lbcNum;
else
    LBC = str2func(lbcInput);
end

if isnumeric(rbcNum)
    RBC = rbcNum;
else
    RBC = str2func(rbcInput);
end


rhsInput = get(handles.input_RHS,'String');
rhsNum = str2num(rhsInput);
if isempty(rhsNum)
    % RHS is a string representing a function -- convert to chebfun
    RHS = chebfun(rhsInput,d);
else
    % RHS is a number - Don't need to construct chebfun
    RHS = rhsNum;
end

guessInput = get(handles.input_GUESS,'String');
if isempty(guessInput)
    N = chebop(d,DE,LBC,RBC);
else
    guess = eval(guessInput)
    if isnumeric(guess)
        guess = guess*x;
    end
    N = chebop(d,DE,LBC,RBC,guess)
end

tolInput = get(handles.input_tol,'String');
tolNum = str2num(tolInput);

options = cheboppref;

options.deltol = tolNum;
options.restol = tolNum;

dampedOnInput = get(handles.damped_on,'Value');
displayOnInput = get(handles.display_on,'Value');
plottingOnInput = get(handles.plotting_on,'Value');

if dampedOnInput
    options.damped = 'on';
else
    options.damped = 'off';
end

if displayOnInput
    options.display = 'iter';
    set(handles.iter_list,'String','');
    set(handles.iter_text,'Visible','On');
    set(handles.iter_list,'Visible','On');
else
    options.display = 'off';
    set(handles.iter_text,'Visible','Off');
    set(handles.iter_list,'Visible','Off');
end
guidata(hObject, handles);
if plottingOnInput
    options.plotting = 'on';
else
    options.plotting = 'off';
end

guihandles = {handles.fig_sol,handles.fig_norm,handles.iter_text, ...
    handles.iter_list,handles.text_norm};
guidata(hObject, handles);
set(handles.text_norm,'Visible','Off');
set(handles.fig_sol,'Visible','On');
set(handles.fig_norm,'Visible','On');

[u vec] = solvebvp(N,RHS,options,guihandles);

set(handles.text_norm,'Visible','On');
guidata(hObject, handles);
% catch
%     disp('Invalid input');
% end
%

axes(handles.fig_sol)
plot(u), title('Solution at end of iteration')
axes(handles.fig_norm)
semilogy(vec,'-*'),title('Norm of updates')
if length(vec) > 1
    set(gca,'XTick',1:floor(length(vec)/5):length(vec)),xlim([1 length(vec)]), grid on
end


1+2;

function input_RBC_Callback(hObject, eventdata, handles)
% hObject    handle to input_RBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_RBC as text
%        str2double(get(hObject,'String')) returns contents of input_RBC as a double


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



function input_LBC_Callback(hObject, eventdata, handles)
% hObject    handle to input_LBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_LBC as text
%        str2double(get(hObject,'String')) returns contents of input_LBC as a double


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
try
    input = str2func(get(hObject,'String'));
catch
    
end

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



function input_RHS_Callback(hObject, eventdata, handles)
% hObject    handle to input_RHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_RHS as text
%        str2double(get(hObject,'String')) returns contents of input_RHS as a double


% --- Executes during object creation, after setting all properties.
function input_RHS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_RHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in iter_list.
function iter_list_Callback(hObject, eventdata, handles)
% hObject    handle to iter_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns iter_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from iter_list


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

% Hint: place code in OpeningFcn to populate fig_logo
logo = imread('@chebop/private/cheblogo.png');
axes(hObject);
image(logo), box off, axis off

