function varargout = chebopbvp(varargin)
% CHEBOPBVP Help for the chebop BVP GUI
%
% Under construction

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

% Last Modified by GUIDE v2.5 29-Mar-2010 22:36:10

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

axes(handles.fig_sol);
fill([0 0 1 1],[0 1 1 0],[1 1 1]), title('Solutions'), axis off

axes(handles.fig_norm);
fill([0 0 1 1],[0 1 1 0],[1 1 1]), title('Updates'), axis off

% Synchronise slider and edit field for pause in plotting
set(handles.slider_pause,'Value',str2double(get(handles.input_pause,'String')));

% Variable that determines whether a solution is available
handles.hasSolution = 0;

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

set(handles.input_GUESS,'String','');
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

set(handles.input_GUESS,'String','');
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
a = str2double(get(handles.dom_left,'String'));
b = str2double(get(handles.dom_right,'String'));

[d,xt] = domain(a,b);
x = xt; t = xt;     % x and t are default choices for indep. var.
% try
%     Switch cheboppref between current and selected state

% Check whether we are working with anonymous functions or natural syntax
% string. Anonymous functions must include @, otherwise we assume natural
% string.
deInput = get(handles.input_DE,'String');

DE = setupFields(deInput,xt,'DE');

lbcInput = get(handles.input_LBC,'String');
rbcInput = get(handles.input_RBC,'String');
lbcRHSInput = get(handles.input_LBC_RHS,'String');
rbcRHSInput = get(handles.input_RBC_RHS,'String');



if ~isempty(lbcInput)
    LBC = setupFields(lbcInput,xt,'BC',lbcRHSInput);
else
    LBC = [];
end
if ~isempty(rbcInput)
  RBC = setupFields(rbcInput,xt,'BC',rbcRHSInput);
else
    RBC = [];
end

if isempty(lbcInput) && isempty(rbcInput)
    error('chebfun:bvpgui','No boundary conditions specified');
end


DErhsInput = get(handles.input_DE_RHS,'String');
DErhsNum = str2num(DErhsInput);
if isempty(DErhsNum)
    % RHS is a string representing a function -- convert to chebfun
    DE_RHS = chebfun(DErhsInput,d);
else
    % RHS is a number - Don't need to construct chebfun
    DE_RHS = DErhsNum;
end

guessInput = get(handles.input_GUESS,'String');

useLatest = strcmpi(guessInput,'Using latest solution');
if isempty(guessInput)
    N = chebop(d,DE,LBC,RBC);
elseif useLatest
    guess = handles.latestSolution;
    N = chebop(d,DE,LBC,RBC,guess);
else
    guess = eval(guessInput);
    if isnumeric(guess)
        guess = 0*x+guess;
    end
    N = chebop(d,DE,LBC,RBC,guess);
end

tolInput = get(handles.input_tol,'String');
tolNum = str2num(tolInput);

options = cheboppref;

% Set the tolerance for the solution process
options.deltol = tolNum;
options.restol = tolNum;


% Always display iter. information
options.display = 'iter';

dampedOnInput = get(handles.damped_on,'Value');
plottingOnInput = get(handles.plotting_on,'Value');

if dampedOnInput
    options.damped = 'on';
else
    options.damped = 'off';
end

set(handles.iter_list,'String','');
set(handles.iter_text,'Visible','On');
set(handles.iter_list,'Visible','On');


guidata(hObject, handles);
if plottingOnInput
    options.plotting = str2double(get(handles.input_pause,'String'));
else
    options.plotting = 'off';
end



guihandles = {handles.fig_sol,handles.fig_norm,handles.iter_text, ...
    handles.iter_list,handles.text_norm};
guidata(hObject, handles);
set(handles.text_norm,'Visible','Off');
set(handles.fig_sol,'Visible','On');
set(handles.fig_norm,'Visible','On');

try
    [u vec] = solvebvp(N,DE_RHS,options,guihandles);
catch
    errordlg('Error in solution process.', 'chebopbvp error', 'modal');
    return
end
% Store in handles latest chebop, solution, vector of norm of updates etc.
% (enables exporting later on)
handles.latestSolution = u;
handles.latestNorms = vec;
handles.latestChebop = N;
handles.latestRHS = DE_RHS;
handles.latestOptions = options;

% Notify the GUI we have a solution available
handles.hasSolution = 1;

% Enable buttons
set(handles.button_useLatest,'Enable','on');
set(handles.button_figures,'Enable','on');

set(handles.text_norm,'Visible','On');


axes(handles.fig_sol)
plot(u), title('Solution at end of iteration')
axes(handles.fig_norm)
semilogy(vec,'-*'),title('Norm of updates'), xlabel('Number of iteration','FontSize',8)
if length(vec) > 1
    XTickVec = 1:max(floor(length(vec)/5),1):length(vec);
    set(gca,'XTick', XTickVec), xlim([1 length(vec)]), grid on
end


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pushbutton3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_RBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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
% try
%     input = str2func(get(hObject,'String'));
% catch

% end

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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Parsing
chebfunpath = which('chebfun');
guifilepath = [chebfunpath(1:end-18), 'guifiles'];
tmppath = pwd;

cd(guifilepath)

inputDEstring = get(handles.input_DE,'String');
set(handles.input_DE,'String',convertToAnon(inputDEstring));
inputLBCstring = get(handles.input_LBC,'String');
set(handles.input_LBC,'String',convertToAnon(inputLBCstring));
inputRBCstring = get(handles.input_RBC,'String');
set(handles.input_RBC,'String',convertToAnon(inputRBCstring));


guidata(hObject, handles);

cd(tmppath)



% --- Executes on button press in button_help.
function button_help_Callback(hObject, eventdata, handles)
% hObject    handle to button_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
doc('chebopbvp')


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




function field  = setupFields(input,xt,type,bcValue)
convertBCtoAnon  = 0;

% Create the variables x and t (corresponding to the linear function on the
% domain).
x = xt; t = xt;
if ~isempty(strfind(input,'@')) % User supplied anon. function
    field = eval(input);
    return
elseif strcmp(type,'BC')        % Allow more types of syntax for BCs
    bcNum = str2num(input);
    
    % Check whether we have a number (OK), allowed strings (OK) or whether
    % we will have to convert the string to anon. function (i.e. the input
    % is on the form u' +1 = 0).
    if ~isempty(bcNum)
        field = bcNum;
    elseif strcmpi(input,'dirichlet') || strcmpi(input,'neumann')
        field = input;
    else
        input = [input ,'-',bcValue]; 
        convertBCtoAnon = 1;
    end
end

if  strcmp(type,'DE') || convertBCtoAnon   % Convert to anon. function
    chebfunpath = which('chebfun');
    guifilepath = [chebfunpath(1:end-18), 'guifiles'];
    tmppath = pwd;
    
    try
        cd(guifilepath)
        field = convertToAnon(input);
        field = eval(field);
        cd(tmppath)
    catch
        error(['chebfun:BVPgui','Incorrect input for differential ' ...
            'equation our boundary conditions']);
        
    end
end





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


% --- Executes on button press in button_useLatest.
function button_useLatest_Callback(hObject, eventdata, handles)
% hObject    handle to button_useLatest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.input_GUESS,'String','Using latest solution');

guidata(hObject, handles);
% ifekki empty
% setja i guess, skrifa latest
% tomt
% skilja eftir tomt


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


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_export.
function button_export_Callback(hObject, eventdata, handles)
% hObject    handle to button_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_export

% Offer more possibilities if solution exists
if handles.hasSolution
    exportType = questdlg('Would you like to export the problem to:', ...
                         'Export to...', ...
                         'Workspace', '.m file', '.mat file', 'Workspace');
else
    exportType = questdlg(['Would you like to export the problem to (more ' ...
                         'possibilities will be available after solving a ' ...
                         'problem):'],'Export to...', ...
                         '.m file','Cancel', '.m file');
end
                     
switch exportType
    case 'Workspace'
        assignin('base','u',handles.latestSolution);
        assignin('base','normVec',handles.latestNorms);
        assignin('base','N',handles.latestChebop);
        assignin('base','rhs',handles.latestRHS);
        assignin('base','options',handles.latestOptions);
    case '.m file'
        % Change to the parsing directory for neater code
        chebfunpath = which('chebfun');
        guifilepath = [chebfunpath(1:end-18), 'guifiles'];
        tmppath = pwd;
        
        try
            [filename, pathname, filterindex] = uiputfile( ...
                {'*.m','M-files (*.m)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Save as', 'bvp.m');
            
            cd(guifilepath)

            export2mfile(pathname,filename,handles)
            cd(tmppath)
        catch
            error(['chebfun:BVPgui','Incorrect input for differential ' ...
                'equation our boundary conditions']);
            
        end
    case '.mat file'
        u = handles.latestSolution;
        normVec= handles.latestNorms;
        N= handles.latestChebop;
        rhs= handles.latestRHS;
        options = handles.latestOptions;
        uisave({'u','normVec','N','rhs','options'},'bvp');
    case 'Cancel'
        return;
end

                   
