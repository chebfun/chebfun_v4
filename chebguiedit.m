function varargout = chebguiedit(varargin)
% CHEBGUIEDIT MATLAB code for chebguiedit.fig
%      CHEBGUIEDIT, by itself, creates a new CHEBGUIEDIT or raises the existing
%      singleton*.
%
%      H = CHEBGUIEDIT returns the handle to a new CHEBGUIEDIT or the handle to
%      the existing singleton*.
%
%      CHEBGUIEDIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHEBGUIEDIT.M with the given input arguments.
%
%      CHEBGUIEDIT('Property','Value',...) creates a new CHEBGUIEDIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chebguiedit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chebguiedit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chebguiedit

% Last Modified by GUIDE v2.5 18-Jan-2011 11:23:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chebguiedit_OpeningFcn, ...
                   'gui_OutputFcn',  @chebguiedit_OutputFcn, ...
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


% --- Executes just before chebguiedit is made visible.
function chebguiedit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chebguiedit (see VARARGIN)


% Choose default command line output for chebguiedit
handles.output = hObject;

mainGuiInput = find(strcmp(varargin, 'chebguiwindow'));
if (isempty(mainGuiInput)) ...
    || (length(varargin) <= mainGuiInput) ...
    || (~ishandle(varargin{mainGuiInput+1}))
    disp('-----------------------------------------------------');
    disp('Improper input arguments. ') 
    disp('chebguiedit should only be called from chebgui.')
    disp('-----------------------------------------------------');
end

% Remember the handle, and adjust our position
handles.chebguiwindow = varargin{mainGuiInput+1};

% Obtain handles using GUIDATA with the caller's handle 
mainHandles = guidata(handles.chebguiwindow);
% Set the edit text to the String of the main GUI's button
handles.outputTarget = varargin{3};
set(handles.edit1, 'String', ...
    get(mainHandles.(varargin{3}), 'String'));

% Position to be relative to parent:
parentPosition = getpixelposition(handles.chebguiwindow);
currentPosition = get(hObject, 'Position');  
% Set x to be directly in the middle, and y so that their tops align.
newX = parentPosition(1) + (parentPosition(3)/2 - currentPosition(3)/2);
newY = parentPosition(2) + (parentPosition(4)/2 - currentPosition(4)/2);
%newY = parentPosition(2) + (parentPosition(4) - currentPosition(4));
newW = currentPosition(3);
newH = currentPosition(4);
%     set(hObject, 'Position', [newX, newY, newW, newH]);

% Get the default font size.
set(handles.edit1,'FontSize',get(mainHandles.editfontsize,'fontsize'));

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes chebguiedit wait for user response (see UIRESUME)
uiwait(hObject);




% --- Outputs from this function are returned to the command line.
function varargout = chebguiedit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} =[];

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonOK.
function buttonOK_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% text = get(handles.edit1, 'String');

% Obtain handles using GUIDATA with the caller's handle 
mainHandles = guidata(handles.chebguiwindow);
% Set the edit text to the String of the main GUI's button
set(mainHandles.(handles.outputTarget), 'String', ...
    get(handles.edit1, 'String'));
% Store the used fontsize
set(mainHandles.editfontsize,'FontSize',get(handles.edit1,'FontSize'));
% Resume and close
uiresume(handles.figure1);
delete(handles.figure1)


% --- Executes on button press in buttonCancel.
function buttonCancel_Callback(hObject, eventdata, handles)
% hObject    handle to buttonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Store the used fontsize
mainHandles = guidata(handles.chebguiwindow);
set(mainHandles.editfontsize,'fontsize',get(handles.edit1,'FontSize'));
% Resume and close
uiresume(handles.figure1);
delete(handles.figure1)

% --- Executes on button press in buttonCancel.
function buttonClear_Callback(hObject, eventdata, handles)
% hObject    handle to buttonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'String','');

% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Store the used fontsize
mainHandles = guidata(handles.chebguiwindow);
set(mainHandles.editfontsize,'fontsize',get(handles.edit1,'FontSize'));
% Resume and close
uiresume(hObject);


% --- Executes on button press in fontplusbutton.
function fontplusbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fontplusbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = get(handles.edit1,'FontSize')+1;
set(handles.edit1,'FontSize',fs);

% --- Executes on button press in fontmbutton.
function fontmbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fontmbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = get(handles.edit1,'FontSize')-1;
set(handles.edit1,'FontSize',fs);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit1.
function edit1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Obtain handles using GUIDATA with the caller's handle 