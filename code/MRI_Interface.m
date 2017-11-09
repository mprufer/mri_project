function varargout = MRI_Interface(varargin)
% TEST M-file for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 30-Nov-2009 14:46:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.MRImain);

%% INITIALIZING
    imgpath = '../data/';
    %Phantom type
    set(handles.selectPhantom, 'SelectionChangeFcn', @selectPhantom_SelectionChangeFcn);    
    pht1thumb = imread(fullfile(imgpath, 'pht1_thumbnail.png'));
    pht2thumb = imread(fullfile(imgpath, 'pht2_thumbnail.png'));
    axes(handles.axes_pht1thumbnail); imshow(pht1thumb);
    axes(handles.axes_pht2thumbnail); imshow(pht2thumb);

    %Trajectory type
    set(handles.selectTrajectory, 'SelectionChangeFcn', @selectPhantom_SelectionChangeFcn);    
    pht1thumb = imread(fullfile(imgpath, 'trajectory_cartesian.jpg'));
    pht2thumb = imread(fullfile(imgpath, 'trajectory_radial.jpg'));
    axes(handles.axes_Cartesian); imshow(pht1thumb);
    axes(handles.axes_Radial); imshow(pht2thumb);
    
    %show defaullt image
    input_place_img = imread(fullfile(imgpath, 'input_place.jpg'));
    mri_place_img = imread(fullfile(imgpath, 'mri_place.jpg'));
    compare_place_img = imread(fullfile(imgpath, 'compare_place.jpg'));    
    axes(handles.axes_phantom); imshow(input_place_img);
    axes(handles.axes_MRIphantom); imshow(mri_place_img);
    axes(handles.axes_compare); imshow(compare_place_img);
    
    %set invisible text fields
    %default values
    NUM_LINES = 128;
    NUM_POINTS = 128;
    set(handles.text_phantomtype, 'String', '1');
    set(handles.text_trajmethod, 'String', 'Cartesian');
    set(handles.text_param1Val, 'String', num2str(NUM_LINES)); %default value
    set(handles.text_param2Val, 'String', num2str(NUM_POINTS)); %default value    
        
    handles.inputPhantom = -1;
    handles.phantomType = -1;
    handles.resultPhantom = -1;
    handles.compareImage = -1;
    handles.trajInfo = [];
    handles.trajInfo.method = 'Cartesian'; %use Cartesian as default;
    handles.trajInfo.Cartesian_swapping = false; 
    handles.trajInfo.num_lines = NUM_LINES;
    handles.trajInfo.num_points_per_line = NUM_POINTS;    
    guidata(hObject, handles);    
    
%%


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;

    

% --- Executes during object creation, after setting all properties.
function axes_phantom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_phantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_phantom
    handles.output = hObject;



% --- Executes on button press in pushbutton_GeneratePhantom.
function pushbutton_GeneratePhantom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_GeneratePhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    DEFAULT_PHANTOMSIZE = [256 256];
    sliderWValue = get(handles.W_slider,'Value');
    sliderHValue = get(handles.H_slider,'Value');
    
    if(sliderWValue == 0) sliderWValue = 1; end
    if(sliderHValue == 0) sliderHValue = 1; end
    
    barsize = floor([sliderWValue*DEFAULT_PHANTOMSIZE(1)/100  sliderHValue*DEFAULT_PHANTOMSIZE(2)/100]);
    
    if (get(handles.radiobutton_phantom1, 'Value') ~= 0)
        type = 1;
    elseif (get(handles.radiobutton_phantom2, 'Value') ~= 0)
        type = 2;
    else
        'You have to choose one type';
        type = -1;
    end
    
    if type ~= -1
        myphantom = GeneratePhantoms(type, DEFAULT_PHANTOMSIZE, barsize); 

        %display:
        set(handles.text_phantomtype, 'String', sprintf('%d', type));
        set(handles.text_phantomtype, 'Visible', 'on');


        axes(handles.axes_phantom); 
        a=set(handles.axes_phantom);
        imshow(myphantom);
        guidata(hObject, handles);    

        % create structure of handles add some additional data
        handles.phantomType = type;
        handles.inputPhantom = myphantom; 
        % save the structure
        guidata(hObject,handles);
    end;

% --- Executes during object deletion, before destroying properties.
function pushbutton_GeneratePhantom_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_GeneratePhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function W_slider_Callback(hObject, eventdata, handles)
% hObject    handle to W_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    sliderValue = get(hObject, 'Value');
    set(handles.textWSlideValue, 'String', num2str(floor(sliderValue)));


% --- Executes during object creation, after setting all properties.
function W_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to W_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on selection change in phantomtype_listbox.
function phantomtype_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to phantomtype_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns phantomtype_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from phantomtype_listbox


% --- Executes during object creation, after setting all properties.
function phantomtype_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phantomtype_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



% --- Executes during object creation, after setting all properties.
function pushbutton_GeneratePhantom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_GeneratePhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function textSlideValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textSlideValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton_phantom1.
function radiobutton_phantom1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_phantom1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_phantom1
    state = get(hObject, 'Value');
    status1 = str2double(get(handles.radiobutton_phantom1,'Value'));

    'wait here';

% --- Executes on button press in radiobutton_phantom2.
function radiobutton_phantom2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_phantom2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_phantom2


% --- Executes on slider movement.
function H_slider_Callback(hObject, eventdata, handles)
% hObject    handle to H_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    sliderValue = get(hObject, 'Value');
    set(handles.textHSlideValue, 'String', num2str(floor(sliderValue)));


% --- Executes during object creation, after setting all properties.
function H_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end



% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes when selected object is changed in selectPhantom.
function selectPhantom_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in selectPhantom 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'radiobutton_phantom1'
      set(handles.W_slider,'enable','on');
      set(handles.H_slider,'enable','on');

    case 'radiobutton_phantom2'
      set(handles.W_slider,'enable','off');
      set(handles.H_slider,'enable','off');
    otherwise

end
%updates the handles structure
guidata(hObject, handles);



% --- Executes on key press with focus on pushbutton_GeneratePhantom and no controls selected.
function pushbutton_GeneratePhantom_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_GeneratePhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider13_Callback(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider14_Callback(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_saveTrajectory.
function pushbutton_saveTrajectory_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveTrajectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    saveTraj = true;   
    
    param1Val = str2num(get(handles.edit_numlines, 'String'));
    remainder1 = param1Val - floor(param1Val);    
   
    if((remainder1 ~= 0) || (param1Val <= 0))
        msgbox('Number of lines must be a positive integer');        
        saveTraj = false;
    end

    param2Val = str2num(get(handles.edit_numpoints, 'String'));
    remainder2 = param2Val - floor(param2Val);    
    if(remainder2 ~= 0 || param2Val <= 0)
        msgbox('Number of points per line must be a positive integer');        
        saveTraj = false;
    end
        
    if(saveTraj)
        handles.trajInfo.num_lines = floor(param1Val);
        handles.trajInfo.num_points_per_line = floor(param2Val);
        set(handles.text_trajmethod, 'String', handles.trajInfo.method);
        set(handles.text_param1Val, 'String', num2str(handles.trajInfo.num_lines));
        set(handles.text_param2Val, 'String', num2str(handles.trajInfo.num_points_per_line));
        guidata(hObject, handles);
    end

% --- Executes on slider movement.
function slider_param1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function slider_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_param2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValue = get(hObject, 'Value');
if(sliderValue == 0) sliderValue = sliderValue + 1; end;
set(handles.text_2, 'String', num2str(floor(sliderValue)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when selected object is changed in selectTrajectory.
function selectTrajectory_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in selectTrajectory 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'radiobutton_Cartesian'   
        handles.trajInfo.method = 'Cartesian';
    case 'radiobutton_Radial'
        handles.trajInfo.method = 'Radial';
    otherwise
        handles.trajInfo.method = -1;
end
guidata(hObject, handles);


% --- Executes on button press in checkbox_Cartesian_swapping.
function checkbox_Cartesian_swapping_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Cartesian_swapping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Cartesian_swapping
handles.trajInfo.Cartesian_swapping = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in pushbutton_Run.
function pushbutton_Run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%check if there is an image

%check parameters for trajectory

if handles.inputPhantom == -1
    msgbox('You have to choose one phantom first', 'Message Box');
else
%     handles.trajInfo.num_lines = floor(param1Val);
%     handles.trajInfo.num_points_per_line = floor(param2Val);
    [resultPhantom outputMessage] =  AcquireMRIImage(handles.inputPhantom, handles.trajInfo);
    %msgbox(outputMessage, 'MRI accquisiton message');
    %[handles.compareImg] = CompareImages(handles.inputPhantom, resultPhantom);        
    axes(handles.axes_MRIphantom); 
    a=set(handles.axes_MRIphantom);    
    imshow(resultPhantom, [0, max(resultPhantom(:))]);
    
%     compareImg = abs(handles.inputPhantom - resultPhantom);
   compareImg = abs(double(handles.inputPhantom) - double(resultPhantom)); 
    axes(handles.axes_compare); 
    a=set(handles.axes_compare);
    imshow(compareImg, [0 max(compareImg(:))]);

    handles.resultPhantom = resultPhantom;
    handles.compareImage = compareImg;
    handles.outputMessage = outputMessage;
    guidata(hObject, handles);    
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over radiobutton_Cartesian.
function radiobutton_Cartesian_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_Cartesian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.newcomer = 1;
guidata(hObject, handles);
'wait';


% --- Executes during object creation, after setting all properties.
function axes_compare_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_compare


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Run.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_savePhantom.
function pushbutton_savePhantom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_savePhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isdir('..\results'))
    mkdir('..\results');
end

if handles.inputPhantom == -1
    msgbox('You have to create the phantom first', 'MessageBox');
else
    outputstr = sprintf('..\\results\\phantom_%d.jpg', handles.phantomType);

    [fname path] = uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
              '*.*','All Files' },'Save Image',...
              outputstr);
    if(fname(1) ~= 0 && path(1) ~= 0)
        imwrite(uint8(imscale(handles.inputPhantom,0,255)), fullfile(path, fname));     
    end
end

% --- Executes on button press in pushbutton_saveMRIimage.
function pushbutton_saveMRIimage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveMRIimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isdir('..\results'))
    mkdir('..\results');
end

if handles.resultPhantom == -1
	msgbox('You have to run the acquisition first', 'MessageBox');
else
    outputstr = sprintf('..\\results\\phantom-%d_MRI_%s-%d-%d.jpg', handles.phantomType, handles.trajInfo.method, handles.trajInfo.num_lines, handles.trajInfo.num_points_per_line);

    [fname path] = uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
              '*.*','All Files' },'Save Image',...
              outputstr);
    if((~(fname(1) == 0)) && (~(path(1) == 0)))
        imwrite(uint8(imscale(handles.resultPhantom,0,255)), fullfile(path, fname));     
    end %else: do nothing
end


% --- Executes on button press in pushbutton_saveCompareImage.
function pushbutton_saveCompareImage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveCompareImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isdir('..\results'))
    mkdir('..\results');
end

if handles.compareImage == -1
    msgbox('You have to run the acquisition first', 'MessageBox');
else
    outputstr = sprintf('..\\results\\phantom-%d_DIFF_%s-%d-%d.jpg', handles.phantomType, handles.trajInfo.method, handles.trajInfo.num_lines, handles.trajInfo.num_points_per_line);
    [fname path] = uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
              '*.*','All Files' },'Save Image',...
              outputstr);
    if((~(fname(1) == 0)) && (~(path(1) == 0)))
        imwrite(uint8(imscale(handles.compareImage,0,255)), fullfile(path, fname));   
    end
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over checkbox_Cartesian_swapping.
function checkbox_Cartesian_swapping_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to checkbox_Cartesian_swapping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton_Cartesian.
function radiobutton_Cartesian_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Cartesian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Cartesian

handles.trajInfo.method = 'Cartesian';
guidata(hObject, handles);


% --- Executes on button press in radiobutton_Radial.
function radiobutton_Radial_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Radial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Radial
handles.trajInfo.method = 'Radial';
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_1.
function text_1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_2.
function text_2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_numlines_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numlines as text
%        str2double(get(hObject,'String')) returns contents of edit_numlines as a double
%% 'working here'
txtValue = str2num(get(hObject, 'String'));
remainder = txtValue - floor(txtValue);
if(remainder ~= 0 || txtValue <= 0)
    msgbox('Number of lines must be a positive integer');
end

%% 
% --- Executes during object creation, after setting all properties.
function edit_numlines_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_numpoints_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numpoints as text
%        str2double(get(hObject,'String')) returns contents of edit_numpoints as a double
txtValue = str2num(get(hObject, 'String'));
remainder = txtValue - floor(txtValue);
if(remainder ~= 0 || txtValue <= 0)
    msgbox('Number of lines must be a positive integer');
end


% --- Executes during object creation, after setting all properties.
function edit_numpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_browsePht.
function pushbutton_browsePht_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_browsePht (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_newPhantom.
function pushbutton_newPhantom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_newPhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_GeneratePhantom.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_GeneratePhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_savePhantom.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_savePhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider18_Callback(hObject, eventdata, handles)
% hObject    handle to W_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to W_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider19_Callback(hObject, eventdata, handles)
% hObject    handle to H_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function textHSlideValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textHSlideValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


