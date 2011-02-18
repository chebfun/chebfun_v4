function varargout = chebguiwindow(varargin)
%CHEBGUIWINDOW Chebfun BVP and PDE GUI for solvebvp and pde15s.
% INTRODUCTION
% 
% Chebgui is a graphical user interface to Chebfun's capabilities
% for solving ODEs and PDEs (ordinary and partial differential
% equations).  More precisely, it deals with these types of
% problems:
% 
% ODE BVP (boundary-value problem): an ODE or system of ODEs on
% an interval [a,b] with boundary conditions at both boundaries.
% 
% ODE IVP (initial-value problem): an ODE or system of ODEs on an
% interval [a,b] with boundary conditions at just one boundary.
% (However, for complicated IVPs like the Lorenz equations, other
% more specialized methods will be much more effective.)
% 
% PDE BVP: a time-dependent problem of the form u_t = N(u,x),
% where N is a linear or nonlinear differential operator.
% 
% For ODEs, Chebgui assumes that the independent variable, which
% varies over the interval [a,b], is either x or t, and that
% the dependent variable(s) have name(s) different from x and t.
% 
% For PDEs, Chebgui assumes that the space variable, on [a,b],
% is x, and that the time variable, which ranges over an interval
% [t1,t2] is t.
% 
% Here's a three-sentence sketch of how the solutions are
% computed.  Both types of ODE problems are solved by Chebfun's
% automated Chebyshev spectral methods underlying the Chebfun
% commands <backslash> and SOLVEBVP.  The discretizations
% involved will be described in a forthcoming paper by Driscoll
% and Hale, and the Newton and damped Newton iterations used to
% handle nonlinearity will be described in a forthcoming paper
% by Birkisson and Driscoll.  The PDE problems are solved by
% Chebfun's PDE15S method, due to Hale, which is based on spectral
% discretization in x coupled with Matlab's ODE15S solution in t.
% 
% To use Chebgui, the simplest method is to type chebgui at
% the Matlab prompt.  The GUI will appear with a demo already
% loaded and ready to run; you can get its solution by pressing
% the green SOLVE button.  To try other preloaded examples, open
% the DEMOS menu at the top.  To input your own example on the
% screen, change the windows in ways which we hope are obvious.
% Inputs are vectorized, so x*u and x.*u are equivalent, for
% example.  Derivatives are indicated by single or double primes,
% so a second derivative is u'' or u".
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
% Finally, the most valuable Chebgui capability of all is
% Export-to-M-file in the FILE -> EXPORT menu.  With this feature,
% you can turn an ODE or PDE solution from the GUI into an M-file
% in standard Chebfun syntax.  This is a great starting point
% for more serious explorations.
%
% See http://www.maths.ox.ac.uk/chebfun for Chebfun information.
%
% See also chebop/solvebvp, chebfun/pde15s
%
% Copyright 2002-2011 by The Chebfun Team.


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

% Variable which stores the initial guess/condition
handles.init = [];

% Variable which stores imported variables from workspace
handles.importedVar = struct;


% Get the GUI object from the input argument
if ~isempty(varargin)
    handles.guifile = varargin{1};
else
    cgTemp = chebgui('dummy');
    handles.guifile = loadexample(cgTemp,3,'bvp'); % Start with Airy as a default
end
% Create a new structure which contains information about the latest
% solution obtained
handles.latest = struct;

% Store the default length of pausing between plots for BVPs and the
% tolerance in the userdata field of relevant menu objects.
set(handles.menu_odeplottingpause,'UserData','0.5');
set(handles.menu_tolerance,'UserData','1e-10');

% Create UserData for the Fix-Y-axis options (so that we can display
% something if it gets called without selecting a demo).
set(handles.menu_pdefixon,'UserData',{''});

% Populate the Demos menu, but only once (i.e. if user calls chebgui again,
% don't reload the examples).
if ~isfield(handles,'demosLoaded')
    loaddemo_menu(handles.guifile,handles,'bvp');
    loaddemo_menu(handles.guifile,handles,'pde');
    loaddemo_menu(handles.guifile,handles,'eig');
    handles.demosLoaded = 1;
end
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

% set(handles.check_uselatest,'String',{'Use latest';'solution'}); 

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
if strcmp(get(handles.button_clear,'String'),'Clear all')
    [newGUI handles] = cleargui(handles.guifile,handles);
    handles.guifile = newGUI;
    guidata(hObject, handles);
elseif strcmp(get(handles.button_clear,'String'),'Pause')
    set(handles.button_clear,'String','Continue');
    set(handles.button_clear,'BackgroundColor',[43 129 86]/256);
    % Re-enable figure buttons
    set(handles.button_figsol,'Enable','on');
    set(handles.button_fignorm,'Enable','on');
else
    % Disable figure buttons
    set(handles.button_figsol,'Enable','off');
    set(handles.button_fignorm,'Enable','off');
    set(handles.button_clear,'String','Pause');
    set(handles.button_clear,'BackgroundColor',[255 179 0]/256);  
end

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
newString = get(hObject,'String');

handles.guifile.init = newString;
if isempty(newString)
    handles.init = '';
    axes(handles.fig_sol);
    cla(handles.fig_sol,'reset');
    return
end

loadVariables(handles.importedVar)

xtTemp = chebfun('x',[str2num(handles.guifile.DomLeft) ...
    str2num(handles.guifile.DomRight)]);
% handles.init
if ~exist('x','var'), x = xtTemp; end
if ~exist('t','var'), t = xtTemp; end
% Do something clever with multilines
str = cellstr(get(hObject,'String'));
init = [];
for k = 1:numel(str)
    init = [init eval(vectorize(str{k}))];
end
handles.init = init;
axes(handles.fig_sol);
plot(handles.init)
guidata(hObject, handles);

function loadVariables(importedVar)
fNames = fieldnames(importedVar);
for i=1:length(fNames), assignin('caller',fNames{i},importedVar.(fNames{i})), end


function input_DE_Callback(hObject, eventdata, handles)
handles.guifile.DE = get(hObject,'String');
guidata(hObject, handles);


function input_tol_Callback(hObject, eventdata, handles)
handles.guifile.tol = get(hObject,'String');
guidata(hObject, handles);


% function input_DE_RHS_Callback(hObject, eventdata, handles)
% inputString = get(hObject,'String');
% handles.guifile.DErhs = inputString;
% % Check whether we might be entering into PDE mode.
% % Find whether any line contains _
% underscoreLocations = strfind(cellstr(inputString),'_');
% % Check whether the results are empty using cellfun
% containsUnderscore = ~cellfun(@isempty,underscoreLocations);
% if get(handles.button_ode,'Value') && any(containsUnderscore)
%     switch2pde = questdlg('You appear to be entering a PDE. Would you like to swtich the PDE mode?', ...
%         'Switch to PDE mode?', 'Yes', 'No','Yes');
%     if strcmp(switch2pde,'Yes')
%         set(handles.button_ode,'Value',0);
%         set(handles.button_ode,'Value',1);
%         button_pde_Callback(hObject, eventdata, handles);
%     end
% end
% guidata(hObject, handles);


function timedomain_Callback(hObject, eventdata, handles)
handles.guifile.timedomain = get(hObject,'String');
guidata(hObject, handles);

% -------------------------------------------------------------------------
% -------------------- Unsorted functions  --------------------------------
% -------------------------------------------------------------------------

function button_fignorm_Callback(hObject, eventdata, handles)

% Check the type of the problem
if get(handles.button_ode,'Value');
    latestNorms = handles.latest.norms;
    
    figure;
    
    semilogy(latestNorms,'-*','Linewidth',2),title('Norm of updates'), xlabel('Number of iteration')
    if length(latestNorms) > 1
        XTickVec = 1:max(floor(length(latestNorms)/5),1):length(latestNorms);
        set(gca,'XTick', XTickVec), xlim([1 length(latestNorms)]), grid on
    else % Don't display fractions on iteration plots
        set(gca,'XTick', 1)
    end
elseif get(handles.button_pde,'Value');
    u = handles.latest.solution;
    % latestNorms = handles.latestNorms;
    tt = handles.latest.solutionT;
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
else % eigs
    
    figure, h1 = gca;
    
    if strcmp(handles.latest.type,'eig')
        selection = get(handles.iter_list,'Value');
        ploteigenmodes(handles.guifile,handles,selection,[],h1);
    end
    
end

function button_figsol_Callback(hObject, eventdata, handles)
if get(handles.button_ode,'Value');
    latestSolution = handles.latest.solution;
    figure
    plot(latestSolution,'Linewidth',2), title('Solution at end of iteration')
    % Turn on grid
    if handles.guifile.options.grid, grid on,  end
elseif get(handles.button_pde,'Value');
    u = handles.latest.solution;
    tt = handles.latest.solutionT;
    
    figure
    if ~iscell(u)
        plot(u(:,end),'Linewidth',2)
        title('Solution at final time.')
    else
        v = chebfun;
        for k = 1:numel(u)
            uk = u{k};
            v(:,k) = uk(:,end);
        end
        plot(v,'Linewidth',2);
        title('Solution at final time.')
    end
    % Turn on grid
    if handles.guifile.options.grid, grid on,  end
    
    % Turn on fixed y-limits
    if ~isempty(handles.guifile.options.fixYaxisLower)
        ylim([str2num(handles.guifile.options.fixYaxisLower) ...
            str2num(handles.guifile.options.fixYaxisUpper)]);
    end
else
    figure, h1 = gca;
    if strcmp(handles.latest.type,'eig')
        selection = get(handles.iter_list,'Value');
        ploteigenmodes(handles.guifile,handles,selection,h1,[]);
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

% --- Executes on button press in button_pde.
function button_eig_Callback(hObject, eventdata, handles)
handles = switchmode(handles.guifile,handles,'eig');
guidata(hObject, handles);

% --- Executes on button press in button_pdeploton.
function button_pdeploton_Callback(hObject, eventdata, handles)
% hObject    handle to button_pdeploton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_pdeploton
% set(handles.button_pdeplotoff,'Value',0);
onoff = 'on';
set(handles.ylim_text,'Enable',onoff);
set(handles.ylim1,'Enable',onoff);
set(handles.text33,'Enable',onoff);
set(handles.ylim2,'Enable',onoff);
set(handles.plotstyle_text,'Enable',onoff);
set(handles.input_plotstyle,'Enable',onoff);


function button_pdeplotoff_Callback(hObject, eventdata, handles)
onoff = 'off';
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

% Selecting from the list only does something when we are in e-value mode
% Display corresponding e-funcs when clicking on e-value.

% set(handles.fig_sol,'XLimMode','Manual');

if strcmp(handles.latest.type,'eig')
    selection = get(handles.iter_list,'Value');
    ploteigenmodes(handles.guifile,handles,selection);
end

% xlim(handles.fig_norm,xlim_norm); ylim(handles.fig_norm,ylim_norm);
% -------------------------------------------------------------------------
% ---------------------- Other subfunctions -------------------------------
% -------------------------------------------------------------------------

function initialisefigures(handles)
cla(handles.fig_sol,'reset');
title('Solutions'), box on
cla(handles.fig_norm,'reset');
title('Updates'), box on

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
h = text( t, y, num2cell(transpose('chebfun')), ...
    'fontsize',16,'hor','cen','vert','mid') ;

flist = listfonts;
k = strmatch('Rockwell',flist);  % 1st choice
k = [k; strmatch('Luxi Serif',flist)];  % 2nd choice
k = [k; strmatch('luxiserif',flist)];  % 2.5th choice
k = [k; strmatch('Times',flist)];  % 3rd choice
if ~isempty(k), set(h,'fontname',flist{k(1)}), end

axis([-1.02 .98 -2 2]), axis off


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

function button_solve_ButtonDownFcn(hObject, eventdata, handles)
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
[filename pathname filterindex] = uigetfile('*.guifile','Pick a file');
if ~filterindex, return, end
cgTemp = chebgui(fullfile(pathname,filename));
loadfields(cgTemp,handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_savegui_Callback(hObject, eventdata, handles)
[filename pathname filterindex] = uiputfile('*.guifile','Pick a file');
if ~filterindex, return, end

% name = input('What would you like to name this GUI file? ');
name = '';

if get(handles.button_ode,'value')
    demotype = 'bvp';
elseif get(handles.button_pde,'value')
    demotype = 'pde';
else
    demotype = 'eig';
end
a = get(handles.dom_left,'string');
b = get(handles.dom_right,'string');
t = get(handles.timedomain,'string');
DE = get(handles.input_DE,'string');
LBC = get(handles.input_LBC,'string');
RBC = get(handles.input_RBC,'string');
init = get(handles.input_GUESS,'string');
tol = '';
damping = '';
plotting = '';

DE = mycell2str(DE);
LBC = mycell2str(LBC);
RBC = mycell2str(RBC);
init = mycell2str(init);

s = sprintf(['name = ''%s'';\n', ...
            'demotype = ''%s'';\n', ...
            'a = ''%s'';\n', ... 
            'b = ''%s'';\n', ...
            't = ''%s'';\n', ...
            'DE = %s;\n', ...
            'LBC = %s;\n', ...
            'RBC = %s;\n', ...
            'init = %s;\n', ...
            'tol = ''%s'';\n', ...
            'damping = ''%s'';\n', ...
            'plotting = ''%s'';'], ...
    name, demotype, a, b, t, DE, LBC, RBC, init, tol, damping, plotting);
fid = fopen(fullfile(pathname,filename),'w+');
fprintf(fid,s);
fclose(fid);

function out = mycell2str(in)
isc = iscell(in);
if ~isc
    in = {in};
    out = '';
else
    out = '{';
end
for k = 1:numel(in)
    if k > 1,  out = [out ' ; ']; end
    out = [out '''' strrep(in{k},'''','''''') ''''];
end
if isc
    out = [out '}'];
end

% --------------------------------------------------------------------
function menu_demos_Callback(hObject, eventdata, handles)


function menu_bvps_Callback(hObject, eventdata, handles)


function menu_ivps_Callback(hObject, eventdata, handles)


function menu_systems_Callback(hObject, eventdata, handles)


function menu_help_Callback(hObject, eventdata, handles)


function menu_openhelp_Callback(hObject, eventdata, handles)

doc('chebguiwindow')


% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_pdesingle_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_pdesystems_Callback(hObject, eventdata, handles)


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





function menu_odedampednewton_Callback(hObject, eventdata, handles)


function menu_odedampednewtonon_Callback(hObject, eventdata, handles)
handles.guifile.options.damping = '1';
set(handles.menu_odedampednewtonon,'checked','on');
set(handles.menu_odedampednewtonoff,'checked','off');
guidata(hObject, handles);


function menu_odedampednewtonoff_Callback(hObject, eventdata, handles)
handles.guifile.options.damping = '0';
set(handles.menu_odedampednewtonon,'checked','off');
set(handles.menu_odedampednewtonoff,'checked','on');
guidata(hObject, handles);


function menu_odeplotting_Callback(hObject, eventdata, handles)

function menu_pdeplotting_Callback(hObject, eventdata, handles)

function menu_odeplottingon_Callback(hObject, eventdata, handles)
% Obtain length of pause from handles
handles.guifile.options.plotting = get(handles.menu_odeplottingpause,'UserData'); 
set(handles.menu_odeplottingon,'checked','on');
set(handles.menu_odeplottingoff,'checked','off');
guidata(hObject, handles);


function menu_odeplottingoff_Callback(hObject, eventdata, handles)
handles.guifile.options.plotting = 'off'; % Should store value of plotting length
set(handles.menu_odeplottingon,'checked','off');
set(handles.menu_odeplottingoff,'checked','on');
guidata(hObject, handles)


function menu_odeplottingpause_Callback(hObject, eventdata, handles)
options.WindowStyle = 'modal';
valid = 0;
while ~valid
    pauseInput = inputdlg('Length of pause between plots:','Set pause length',...
        1,{get(hObject,'UserData')},options);
    if isempty(pauseInput) % User pressed cancel
        break
    elseif ~isempty(str2num(pauseInput{1})) % Valid input
        valid = 1;
        % Store new value in the UserData of the object
        set(hObject,'UserData',pauseInput{1});
        % Update length of pause in the chebgui object
        handles.guifile.options.plotting = pauseInput{1};
        % Change the marking of the options
        set(handles.menu_odeplottingon,'checked','on');
        set(handles.menu_odeplottingoff,'checked','off');
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
function menu_showgrid_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_pdeholdplot_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menu_pdefix_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_pdeplotfield_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_pdeholdploton_Callback(hObject, eventdata, handles)
handles.guifile.options.pdeholdplot = 1; % Turn holding off
set(handles.menu_pdeholdploton,'checked','on');
set(handles.menu_pdeholdplotoff,'checked','off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_pdeholdplotoff_Callback(hObject, eventdata, handles)
handles.guifile.options.pdeholdplot = 0; % Turn holding off
set(handles.menu_pdeholdploton,'checked','off');
set(handles.menu_pdeholdplotoff,'checked','on');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_pdeplottingon_Callback(hObject, eventdata, handles)
handles.guifile.options.plotting = 'on'; % Obtain length of pause from handles
set(handles.menu_pdeplottingon,'checked','on');
set(handles.menu_pdeplottingoff,'checked','off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_pdeplottingoff_Callback(hObject, eventdata, handles)
handles.guifile.options.plotting = 'off'; % Obtain length of pause from handles
set(handles.menu_pdeplottingon,'checked','off');
set(handles.menu_pdeplottingoff,'checked','on');
guidata(hObject, handles);


function menu_tolerance_Callback(hObject, eventdata, handles)
options.WindowStyle = 'modal';
valid = 0;
while ~valid
    tolInput = inputdlg('Tolerance for solution:','Set tolerance',...
        1,{get(hObject,'UserData')},options);
    if isempty(tolInput) % User pressed cancel
        break
    elseif ~isempty(str2num(tolInput{1})) % Valid input
        valid = 1;
        % Store new value in the UserData of the object
        set(hObject,'UserData',tolInput{1});
        % Update the chebgui object
        handles.guifile.tol = tolInput{1};
    else
        f = errordlg('Invalid input.', 'Chebgui error', 'modal');
        uiwait(f); 
    end
end
guidata(hObject, handles)


% --- Executes on button press in check_uselatest.
function check_uselatest_Callback(hObject, eventdata, handles)
% hObject    handle to check_uselatest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_uselatest


% --------------------------------------------------------------------
function menu_showgridon_Callback(hObject, eventdata, handles)
handles.guifile.options.grid = 1; % Turn grid on
set(handles.menu_showgridon,'checked','on');
set(handles.menu_showgridoff,'checked','off');
axes(handles.fig_sol);  grid on
axes(handles.fig_norm); grid on
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_showgridoff_Callback(hObject, eventdata, handles)
handles.guifile.options.grid = 0; % Turn grid off
set(handles.menu_showgridon,'checked','off');
set(handles.menu_showgridoff,'checked','on');
axes(handles.fig_sol); grid off
axes(handles.fig_norm);  grid off
guidata(hObject, handles);


function menu_fixN_Callback(hObject, eventdata, handles)


function menu_annotateplots_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_pdefixon_Callback(hObject, eventdata, handles)
options.WindowStyle = 'modal';
valid = 0;
defaultAnswer = {handles.guifile.options.fixYaxisLower,...
    handles.guifile.options.fixYaxisUpper};
while ~valid
    fixInput = inputdlg({'Lower y-limit:','Upper y-limit:'},'Fix y-axis',...
        1,defaultAnswer,options);
    if isempty(fixInput) % User pressed cancel
        break
    elseif ~isempty(str2num(fixInput{1})) &&  ~isempty(str2num(fixInput{2})) % Valid input
        valid = 1;
        % Store new value in the UserData of the object
        set(hObject,'UserData',fixInput);
        % Update the chebgui object
        handles.guifile.options.fixYaxisLower = fixInput{1};
        handles.guifile.options.fixYaxisUpper = fixInput{2};
    else
        f = errordlg('Invalid input.', 'Chebgui error', 'modal');
        uiwait(f); 
    end
end

% Change checking
set(handles.menu_pdefixon,'checked','on');
set(handles.menu_pdefixoff,'checked','off');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_pdefixoff_Callback(hObject, eventdata, handles)
% Clear out fix information
handles.guifile.options.fixYaxisLower = '';
handles.guifile.options.fixYaxisUpper = '';

% Change checking
set(handles.menu_pdefixon,'checked','off');
set(handles.menu_pdefixoff,'checked','on');
guidata(hObject, handles);

function sigma_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function sigma_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_eigsscalar_Callback(hObject, eventdata, handles)

% --- Executes on button press in button_export.
function button_export_Callback(hObject, eventdata, handles)
export(handles.guifile,handles,'.m');


% --- Executes on button press in button_realplot.
function button_realplot_Callback(hObject, eventdata, handles)
set(handles.button_realplot,'Value',1)
set(handles.button_imagplot,'Value',0)
set(handles.button_envelope,'Value',0)
selection = get(handles.iter_list,'Value');
ploteigenmodes(handles.guifile,handles,selection)
    
% --- Executes on button press in button_imagplot.
function button_imagplot_Callback(hObject, eventdata, handles)
set(handles.button_realplot,'Value',0)
set(handles.button_imagplot,'Value',1)
set(handles.button_envelope,'Value',0)
selection = get(handles.iter_list,'Value');
ploteigenmodes(handles.guifile,handles,selection)

% --- Executes on button press in button_envelope.
function button_envelope_Callback(hObject, eventdata, handles)
set(handles.button_realplot,'Value',0)
set(handles.button_imagplot,'Value',0)
set(handles.button_envelope,'Value',1)
selection = get(handles.iter_list,'Value');
ploteigenmodes(handles.guifile,handles,selection)


% --------------------------------------------------------------------
function menu_fixNon_Callback(hObject, eventdata, handles)
options.WindowStyle = 'modal';
valid = 0;
defaultAnswer = {handles.guifile.options.fixN};
while ~valid
    fixInput = inputdlg({'Number of gridpoints:'},'Fix space discretisation',...
        1,defaultAnswer,options);
    if isempty(fixInput) % User pressed cancel
        break
    elseif ~mod(str2num(fixInput{1}),1) % Only allow integers 
        valid = 1;
        % Store new value in the UserData of the object
        set(hObject,'UserData',fixInput);
        % Update the chebgui object
        handles.guifile.options.fixN = fixInput{1};
    else
        f = errordlg('Invalid input.', 'Chebgui error', 'modal');
        uiwait(f); 
    end
end

% Change checking
set(handles.menu_fixNon,'checked','on');
set(handles.menu_fixNoff,'checked','off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_fixNoff_Callback(hObject, eventdata, handles)
handles.guifile.options.fixN = '';
% Change checking
set(handles.menu_fixNon,'checked','off');
set(handles.menu_fixNoff,'checked','on');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_sigma_Callback(hObject, eventdata, handles)
% options.WindowStyle = 'modal';
% valid = 0;
% defaultAnswer = {handles.guifile.sigma};
% while ~valid
%     in = inputdlg({'Set sigma, e.g., ''LR'',''SR'',''LM'', ''SM'', etc'},'Set sigma',...
%         1,defaultAnswer,options);
%     if isempty(in) % User pressed cancel
%         break
%     elseif any(strcmpi(in{1},{'LR','SR','LM', 'SM'})) || ~isempty(str2num(in{1}))
%         in = in{1};
%         valid = 1;
%         % Store new value in the UserData of the object
%         set(hObject,'UserData',in);
%         % Update the chebgui object
%         handles.guifile.sigma = in;
%     else
%         f = errordlg('Invalid input.', 'Chebgui error', 'modal');
%         uiwait(f); 
%     end
% end
% guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_eigno_Callback(hObject, eventdata, handles)
% options.WindowStyle = 'modal';
% valid = 0;
% defaultAnswer = {handles.guifile.options.numeigs};
% if isempty(defaultAnswer{:}), defaultAnswer = {'6'}; end % As defined in linop/eigs
% while ~valid
%     in = inputdlg({'Number of eigenvalues to find?'},'Number of eigenvalues?',...
%         1,defaultAnswer,options);
%     if isempty(in) % User pressed cancel
%         break
%     elseif ~mod(str2num(in{1}),1) % Only allow integers
%         in = in{1};
%         valid = 1;
%         % Store new value in the UserData of the object
%         set(hObject,'UserData',in);
%         % Update the chebgui object
%         handles.guifile.options.numeigs = in;
%     else
%         f = errordlg('Invalid input.', 'Chebgui error', 'modal');
%         uiwait(f); 
%     end
% end
% guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_import_Callback(hObject, eventdata, handles)
% Obtain a 'whos' list from the base workspace
variables =  evalin('base','whos');
baseVarNames = {variables.name};
% Create a list dialog
[selection,OK] = listdlg('PromptString','Select variable(s) to import:',...
    'ListString',baseVarNames,'Name','Import variables to GUI',...
    'OKString','Import','ListSize',[160 200]);
if ~OK, return, end % User pressed cancel

% Store all the selected variables in the handles
for selCounter = 1:length(selection)
    handles.importedVar.(baseVarNames{selection(selCounter)}) = ...
        evalin('base',baseVarNames{selection(selCounter)});
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_eigssystem_Callback(hObject, eventdata, handles)
% hObject    handle to menu_eigssystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on chebguimainwindow and none of its controls.
function chebguimainwindow_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to chebguimainwindow (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
edata = eventdata;
if ~isempty(edata.Modifier) && strcmp(edata.Modifier{1},'control')
    switch edata.Key
        case 'return'
            button_solve_Callback(hObject, eventdata, handles);
        case 'e'
            button_export_Callback(hObject, eventdata, handles);
    end
    
end
% PressedKeyNo = double(get(gcbo,'CurrentCharacter'))



function edit_eigN_Callback(hObject, eventdata, handles)
in = get(handles.edit_eigN,'String');
if ~isempty(in) && isempty(str2num(in))
    errordlg('Invalid input. Number of eigenvalues must be an integer.', 'Chebgui error', 'modal');
    set(handles.edit_eigN,'String',handles.guifile.options.numeigs);
else
    handles.guifile.options.numeigs = in;
end
guidata(hObject, handles);

function edit_eigN_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit37_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit37_Callback(hObject, eventdata, handles)
in = get(handles.edit_eigN,'String');
if ~isempty(in) && isempty(str2num(in))
    errordlg('Invalid input.', 'Chebgui error', 'modal');
else
    handles.guifile.options.numeigs = in;
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenu_sigma.
function popupmenu_sigma_Callback(hObject, eventdata, handles)
selected = get(hObject,'Value');
switch selected
    case 1
        handles.guifile.sigma = '';
    case 2
        handles.guifile.sigma = 'lm';
    case 3
        handles.guifile.sigma = 'sm';
    case 4
        handles.guifile.sigma = 'lr';
    case 5
        handles.guifile.sigma = 'sr';
    case 6
        handles.guifile.sigma = 'li';
    case 7
        handles.guifile.sigma = 'si';
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_annotateon_Callback(hObject, eventdata, handles)
% hObject    handle to menu_annotateon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_annotateoff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_annotateoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
