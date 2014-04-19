function varargout = redfishbluefish(varargin)
% REDFISHBLUEFISH MATLAB code for redfishbluefish.fig
%      REDFISHBLUEFISH, by itself, creates a new REDFISHBLUEFISH or raises the existing
%      singleton*.
%
%      H = REDFISHBLUEFISH returns the handle to a new REDFISHBLUEFISH or the handle to
%      the existing singleton*.
%
%      REDFISHBLUEFISH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REDFISHBLUEFISH.M with the given input arguments.
%
%      REDFISHBLUEFISH('Property','Value',...) creates a new REDFISHBLUEFISH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before redfishbluefish_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to redfishbluefish_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help redfishbluefish

% Last Modified by GUIDE v2.5 18-Apr-2014 20:50:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @redfishbluefish_OpeningFcn, ...
                   'gui_OutputFcn',  @redfishbluefish_OutputFcn, ...
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

% --- Executes just before redfishbluefish is made visible.
function redfishbluefish_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to redfishbluefish (see VARARGIN)

% Choose default command line output for redfishbluefish
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using redfishbluefish.
if strcmp(get(hObject,'Visible'),'off')
    set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
    set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
end


% UIWAIT makes redfishbluefish wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = redfishbluefish_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

% Save initial numbers of fish
handles.nred = str2double(get(handles.edit1, 'String'));
handles.nblue = str2double(get(handles.edit2, 'String'));
set(handles.text19, 'String', num2str(handles.nred));
set(handles.text20, 'String', num2str(handles.nblue));

% Save probabilities
handles.prepred = str2double(get(handles.edit7, 'String'));
handles.prepblue = str2double(get(handles.edit8, 'String'));
handles.pdcsred = str2double(get(handles.edit9, 'String'));
handles.pdcsblue = str2double(get(handles.edit10, 'String'));
handles.pdcored = str2double(get(handles.edit11, 'String'));
handles.pdcoblue = str2double(get(handles.edit12, 'String'));

% Check if pond is overcrowded
if (handles.nred + handles.nblue > 2500)
    fprintf('Error: Total number of fish must be less than 2500.\n');
    fprintf('Setting initial conditions to 10 red fish, 4 blue fish.\n');
    handles.nred = 10;
    handles.nblue = 4;
    set(handles.text19, 'String', num2str(handles.nred));
    set(handles.text20, 'String', num2str(handles.nblue));
end

% Initialize grid
% 0 means no fish
% 1 means red fish
% 2 means blue fish
handles.fishgrid = zeros(50);
for ii=1:handles.nred
    mm = randi(50);
    nn = randi(50);
    while handles.fishgrid(mm, nn) > 0
        mm = randi(50);
        nn = randi(50);
    end
    handles.fishgrid(mm, nn) = 1;
end
for ii=1:handles.nblue
    mm = randi(50);
    nn = randi(50);
    while handles.fishgrid(mm, nn) > 0
        mm = randi(50);
        nn = randi(50);
    end
    handles.fishgrid(mm, nn) = 2;
end

% Initialize plot
plot(1000, 1000); % not on grid
hold on;
for ii=1:size(handles.fishgrid, 1)
    for jj=1:size(handles.fishgrid, 2)
        if (handles.fishgrid(ii, jj) == 1)
            plot(ii, jj, 'r*', 'MarkerSize', 4);
        end
        if (handles.fishgrid(ii, jj) == 2)
            plot(ii, jj, 'b*', 'MarkerSize', 4);
        end
    end
end
axis([0.5, 50.5, 0.5, 50.5]);
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);

% Update grid and plot forever
data = guidata(gcf);
data.stop = 0;
guidata(gcf, data);
while data.stop ~= 1
    % Update grid step 1: movement
    for ii=1:size(handles.fishgrid, 1)
        for jj=1:size(handles.fishgrid, 2)
            if (handles.fishgrid(ii, jj) > 0)
                randmov = rand();
                if randmov < 0.2 && handles.fishgrid(ii, mod(jj, 50) + 1) == 0
                    handles.fishgrid(ii, mod(jj, 50) + 1) = -handles.fishgrid(ii, jj);
                    handles.fishgrid(ii, jj) = 0;
                elseif randmov < 0.4 && handles.fishgrid(ii, mod(jj - 2, 50) + 1) == 0
                    handles.fishgrid(ii, mod(jj - 2, 50) + 1) = -handles.fishgrid(ii, jj);
                    handles.fishgrid(ii, jj) = 0;
                elseif randmov < 0.6 && handles.fishgrid(mod(ii - 2, 50) + 1, jj) == 0
                    handles.fishgrid(mod(ii - 2, 50) + 1, jj) = -handles.fishgrid(ii, jj);
                    handles.fishgrid(ii, jj) = 0;
                elseif randmov < 0.8 && handles.fishgrid(mod(ii, 50) + 1, jj) == 0
                    handles.fishgrid(mod(ii, 50) + 1, jj) = -handles.fishgrid(ii, jj);
                    handles.fishgrid(ii, jj) = 0;
                end
            end
        end
    end
    for ii=1:size(handles.fishgrid, 1)
        for jj=1:size(handles.fishgrid, 2)
            handles.fishgrid(ii, jj) = abs(handles.fishgrid(ii, jj));
        end
    end
    
    % Update grid step 2: collision
    for ii=1:size(handles.fishgrid, 1)
        for jj=1:size(handles.fishgrid, 2)
            if (handles.fishgrid(ii, jj) > 0)
                neighbors = [];
                if handles.fishgrid(ii, mod(jj, 50) + 1) ~= 0
                    neighbors = [neighbors, abs(handles.fishgrid(ii, mod(jj, 50) + 1))];
                elseif handles.fishgrid(ii, mod(jj - 2, 50) + 1) ~= 0
                    neighbors = [neighbors, abs(handles.fishgrid(ii, mod(jj - 2, 50) + 1))];
                elseif handles.fishgrid(mod(ii - 2, 50) + 1, jj) ~= 0
                    neighbors = [neighbors, abs(handles.fishgrid(mod(ii - 2, 50) + 1, jj))];
                elseif handles.fishgrid(mod(ii, 50) + 1, jj) ~= 0
                    neighbors = [neighbors, abs(handles.fishgrid(mod(ii, 50) + 1, jj))];
                end
                for kk=1:numel(neighbors)
                    pdeath = 0;
                    if (handles.fishgrid(ii, jj) == 1 && neighbors(kk) == 1)
                        pdeath = handles.pdcsred;
                    elseif (handles.fishgrid(ii, jj) == 1 && neighbors(kk) == 2)
                        pdeath = handles.pdcored;
                    elseif (handles.fishgrid(ii, jj) == 2 && neighbors(kk) == 1)
                        pdeath = handles.pdcoblue;
                    elseif (handles.fishgrid(ii, jj) == 2 && neighbors(kk) == 2)
                        pdeath = handles.pdcsblue;
                    end
                    if (rand() < pdeath)
                        handles.fishgrid(ii, jj) = -handles.fishgrid(ii, jj);
                        break;
                    end
                end
            end
        end
    end
    for ii=1:size(handles.fishgrid, 1)
        for jj=1:size(handles.fishgrid, 2)
            if (handles.fishgrid(ii, jj) < 0)
                handles.fishgrid(ii, jj) = 0;
            end
        end
    end
    
    % Update grid step 3: reproduction
    for ii=1:size(handles.fishgrid, 1)
        for jj=1:size(handles.fishgrid, 2)
            if (handles.fishgrid(ii, jj) > 0)
                randrep = rand();
                prep = 0;
                if handles.fishgrid(ii, jj) == 1
                    prep = handles.prepred;
                elseif handles.fishgrid(ii, jj) == 2
                    prep = handles.prepblue;
                end
                if rand() < prep
                    if randrep < 0.25 && handles.fishgrid(ii, mod(jj, 50) + 1) == 0
                        handles.fishgrid(ii, mod(jj, 50) + 1) = -handles.fishgrid(ii, jj);
                    elseif randrep < 0.5 && handles.fishgrid(ii, mod(jj - 2, 50) + 1) == 0
                        handles.fishgrid(ii, mod(jj - 2, 50) + 1) = -handles.fishgrid(ii, jj);
                    elseif randrep < 0.75 && handles.fishgrid(mod(ii - 2, 50) + 1, jj) == 0
                        handles.fishgrid(mod(ii - 2, 50) + 1, jj) = -handles.fishgrid(ii, jj);
                    elseif randrep < 1 && handles.fishgrid(mod(ii, 50) + 1, jj) == 0
                        handles.fishgrid(mod(ii, 50) + 1, jj) = -handles.fishgrid(ii, jj);
                    end
                end
            end
        end
    end
    for ii=1:size(handles.fishgrid, 1)
        for jj=1:size(handles.fishgrid, 2)
            handles.fishgrid(ii, jj) = abs(handles.fishgrid(ii, jj));
        end
    end
    
    % Update plot
    hold off;
    plot(1000, 1000); % not on grid
    hold on;
    for ii=1:size(handles.fishgrid, 1)
        for jj=1:size(handles.fishgrid, 2)
            if (handles.fishgrid(ii, jj) == 1)
                plot(ii, jj, 'r*', 'MarkerSize', 4);
            end
            if (handles.fishgrid(ii, jj) == 2)
                plot(ii, jj, 'b*', 'MarkerSize', 4);
            end
        end
    end
    axis([0.5, 50.5, 0.5, 50.5]);
    set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
    set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);

    % Refresh everything
    set(handles.text19, 'String', num2str(sum(sum(handles.fishgrid == 1))));
    set(handles.text20, 'String', num2str(sum(sum(handles.fishgrid == 2))));
    pause(0.1);
    data = guidata(gcf);
end

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stop updating grid and plot
data = guidata(gcf);
data.stop = 1;
guidata(gcf, data);


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
