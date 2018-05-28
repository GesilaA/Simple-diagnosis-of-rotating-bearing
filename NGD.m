function varargout = NGD(varargin)
% NGD MATLAB code for NGD.fig
%      NGD, by itself, creates a new NGD or raises the existing
%      singleton*.
%
%      H = NGD returns the handle to a new NGD or the handle to
%      the existing singleton*.
%
%      NGD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NGD.M with the given input arguments.
%
%      NGD('Property','Value',...) creates a new NGD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NGD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NGD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NGD

% Last Modified by GUIDE v2.5 28-May-2018 12:47:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NGD_OpeningFcn, ...
                   'gui_OutputFcn',  @NGD_OutputFcn, ...
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


% --- Executes just before NGD is made visible.
function NGD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NGD (see VARARGIN)

% Choose default command line output for NGD
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.plotPanel, 'visible', 'off');
set(handles.paraPanel, 'visible', 'off');
set(handles.svmPanel,  'visible', 'off');
handles.parameters = zeros(1, 11);
for n = 1:10
    handles.parameters(n) = 1;
end
handles.parameters(11) = 10;
handles.tableValue = cell(10,2);
handles.tableValue(1, :) = {'方根幅值',0.0};
handles.tableValue(2, :) = {'平均幅值',0.0};
handles.tableValue(3, :) = {'均方根值',0.0};
handles.tableValue(4, :) = {'峰值',    0.0};
handles.tableValue(5, :) = {'峰峰值',  0.0};
handles.tableValue(6, :) = {'波形指标',0.0};
handles.tableValue(7, :) = {'峰值指标',0.0};
handles.tableValue(8, :) = {'脉冲指标',0.0};
handles.tableValue(9, :) = {'裕度指标',0.0};
handles.tableValue(10,:) = {'峭度指标',0.0};
handles.barValue = handles.tableValue;
handles.currentIndex = -1;
set(handles.paraTable, 'data', handles.tableValue);
handles.tableOutput = cell(0,0);
guidata(hObject, handles);
set(handles.paraEdit, 'string', 'DATA');
set(handles.paraEdit2,'string', 'DATA');
set(handles.nickConfirmBtn, 'enable', 'off');
set(handles.funcConfirm, 'enable', 'off');
set(handles.trainStart, 'enable', 'off');
set(handles.svmRunBtn, 'enable', 'off');
set(handles.svmTable, 'data', cell(0, 0));
% UIWAIT makes NGD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NGD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openBtn.
function openBtn_Callback(hObject, eventdata, handles)
% hObject    handle to openBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileNames, filePath, ~] = uigetfile('*.mat', '打开文件', 'MultiSelect', 'on');
if (~ischar(filePath))
    return;
end
if (~iscell(fileNames))
    t = cell(1,1);
    t(1) = {fileNames};
    fileNames = t;
end
[~, c] = size(fileNames);
fileMenuItems = cell(1,c);
handles.originData = cell(1,c);
for n = 1:c
    fullFileName = strcat(filePath, fileNames{n});
    fileMenuItems(n) = {fullFileName};
    handles.originData(n) = {load(fullFileName)};
end
set(handles.fileMenu, 'string', fileMenuItems);
set(handles.trainDataMenu, 'string', fileMenuItems);
set(handles.testDataMenu, 'string', fileMenuItems);
set(handles.fileMenu, 'value', 1);
handles.currentIndex = 1;
guidata(hObject, handles);

% --- Executes on selection change in fileMenu.
function fileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to fileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentFile = get(handles.fileMenu, 'String');
if (strcmp(currentFile, '请选择数据'))
    return;
end
handles.currentIndex = get(handles.fileMenu, 'Value');
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns fileMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileMenu


% --- Executes during object creation, after setting all properties.
function fileMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotBtn.
function plotBtn_Callback(hObject, eventdata, handles)
% hObject    handle to plotBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.plotPanel, 'visible', 'on');
set(handles.paraPanel, 'visible', 'off');
set(handles.svmPanel,  'visible', 'off');

% --- Executes on button press in paraBtn.
function paraBtn_Callback(hObject, eventdata, handles)
% hObject    handle to paraBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.plotPanel, 'visible', 'off');
set(handles.paraPanel, 'visible', 'on');
set(handles.svmPanel,  'visible', 'off');
tableV = get(handles.tableC, 'value');
if (tableV == 1)
    set(handles.paraTablePanel, 'visible', 'on');
    set(handles.paraBarPanel,   'visible', 'off');
else
    set(handles.paraTablePanel, 'visible', 'off');
    set(handles.paraBarPanel,   'visible', 'on');
end

% --- Executes on button press in svmBtn.
function svmBtn_Callback(hObject, eventdata, handles)
% hObject    handle to svmBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.plotPanel, 'visible', 'off');
set(handles.paraPanel, 'visible', 'off');
set(handles.svmPanel,  'visible', 'on');

% --- Executes on button press in timeBtn.
function timeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to timeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.currentIndex == -1)
    msgbox('数据未初始化！', '警告');
    return;
end
x = get(handles.paraEdit2, 'string');
if (~isfield(handles.originData{handles.currentIndex}, x)) 
    msgbox('文件中未找到数据变量名！', '数据名错误');
    return;
end
x = getfield(handles.originData{handles.currentIndex}, x);
dim = ndims(x);
siz = size(x);
if dim(1) ~= 2
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) ~= 1
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) == 1
    x = x';
end
freq = get(handles.freqEdit, 'string');
freq = str2double(freq);
if isnan(freq)
    msgbox('请输入正确的数字（采样频率）', '错误');
    return;
elseif freq <= 0
    msgbox('采样频率必须>=0', '错误');
    return;
end
N = length(x);
t = (0:N-1)/freq;
axes(handles.showArea);
plot(t, x);
handles.t = t;
handles.x = x;
guidata(hObject, handles);

% --- Executes on button press in fftBtn.
function fftBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fftBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.currentIndex == -1)
    msgbox('数据未初始化！', '警告');
    return;
end
x = get(handles.paraEdit2, 'string');
if (~isfield(handles.originData{handles.currentIndex}, x)) 
    msgbox('文件中未找到数据变量名！', '数据名错误');
    return;
end
x = getfield(handles.originData{handles.currentIndex}, x);
dim = ndims(x);
siz = size(x);
if dim(1) ~= 2
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) ~= 1
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) == 1
    x = x';
end
freq = get(handles.freqEdit, 'string');
freq = str2double(freq);
if isnan(freq)
    msgbox('请输入正确的数字（采样频率）', '错误');
    return;
elseif freq <= 0
    msgbox('采样频率必须>=0', '错误');
    return;
end
N = length(x);
f = freq*(0:N/2-1)/N;
axes(handles.showArea);
x = abs(fft(x))*2/N;
plot(f, x(1:N/2));
handles.t = f;
handles.x = x(1:N/2);
guidata(hObject, handles);

% --- Executes on button press in psdBtn.
function psdBtn_Callback(hObject, eventdata, handles)
% hObject    handle to psdBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.currentIndex == -1)
    msgbox('数据未初始化！', '警告');
    return;
end
x = get(handles.paraEdit2, 'string');
if (~isfield(handles.originData{handles.currentIndex}, x)) 
    msgbox('文件中未找到数据变量名！', '数据名错误');
    return;
end
x = getfield(handles.originData{handles.currentIndex}, x);
dim = ndims(x);
siz = size(x);
if dim(1) ~= 2
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) ~= 1
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) == 1
    x = x';
end
freq = get(handles.freqEdit, 'string');
freq = str2double(freq);
if isnan(freq)
    msgbox('请输入正确的数字（采样频率）', '错误');
    return;
elseif freq <= 0
    msgbox('采样频率必须>=0', '错误');
    return;
end
N = length(x);
f = freq*(0:N/2-1)/N;
x = fft(x);
x = x.*conj(x)/N;
x = abs(x)*2;
axes(handles.showArea);
plot(f, x(1:N/2));
handles.t = f;
handles.x = x(1:N/2);
guidata(hObject, handles);


% --- Executes on button press in hilBtn.
function hilBtn_Callback(hObject, eventdata, handles)
% hObject    handle to hilBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.currentIndex == -1)
    msgbox('数据未初始化！', '警告');
    return;
end
x = get(handles.paraEdit2, 'string');
if (~isfield(handles.originData{handles.currentIndex}, x)) 
    msgbox('文件中未找到数据变量名！', '数据名错误');
    return;
end
x = getfield(handles.originData{handles.currentIndex}, x);
dim = ndims(x);
siz = size(x);
if dim(1) ~= 2
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) ~= 1
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) == 1
    x = x';
end
freq = get(handles.freqEdit, 'string');
freq = str2double(freq);
if isnan(freq)
    msgbox('请输入正确的数字（采样频率）', '错误');
    return;
elseif freq <= 0
    msgbox('采样频率必须>=0', '错误');
    return;
end
N = length(x);
f = freq*(0:N/2-1)/N;
x = abs(hilbert(x));
x = abs(fft(x))*2/N;
axes(handles.showArea);
plot(f, x(1:N/2));
handles.t = f;
handles.x = x(1:N/2);
guidata(hObject, handles);

% --- Executes on button press in rootC.
function rootC_Callback(hObject, eventdata, handles)
% hObject    handle to rootC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(1) = -1*handles.parameters(1);
if (handles.parameters(1) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of rootC


% --- Executes on button press in averC.
function averC_Callback(hObject, eventdata, handles)
% hObject    handle to averC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(2) = -1*handles.parameters(2);
if (handles.parameters(2) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of averC


% --- Executes on button press in p2pC.
function p2pC_Callback(hObject, eventdata, handles)
% hObject    handle to p2pC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(5) = -1*handles.parameters(5);
if (handles.parameters(5) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of p2pC


% --- Executes on button press in peakC.
function peakC_Callback(hObject, eventdata, handles)
% hObject    handle to peakC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(4) = -1*handles.parameters(4);
if (handles.parameters(4) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of peakC


% --- Executes on button press in rmsC.
function rmsC_Callback(hObject, eventdata, handles)
% hObject    handle to rmsC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(3) = -1*handles.parameters(3);
if (handles.parameters(3) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of rmsC


% --- Executes on button press in kurtosisC.
function kurtosisC_Callback(hObject, eventdata, handles)
% hObject    handle to kurtosisC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(10) = -1*handles.parameters(10);
if (handles.parameters(10) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of kurtosisC


% --- Executes on button press in marginC.
function marginC_Callback(hObject, eventdata, handles)
% hObject    handle to marginC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(9) = -1*handles.parameters(9);
if (handles.parameters(9) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of marginC


% --- Executes on button press in pulseC.
function pulseC_Callback(hObject, eventdata, handles)
% hObject    handle to pulseC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(8) = -1*handles.parameters(8);
if (handles.parameters(8) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of pulseC


% --- Executes on button press in peakiC.
function peakiC_Callback(hObject, eventdata, handles)
% hObject    handle to peakiC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(7) = -1*handles.parameters(7);
if (handles.parameters(7) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of peakiC


% --- Executes on button press in waveiC.
function waveiC_Callback(hObject, eventdata, handles)
% hObject    handle to waveiC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters(6) = -1*handles.parameters(6);
if (handles.parameters(6) == -1)
    handles.parameters(11) = handles.parameters(11) - 1;
else
    handles.parameters(11) = handles.parameters(11) + 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of waveiC


% --- Executes on button press in paraUpdateBtn.
function paraUpdateBtn_Callback(hObject, eventdata, handles)
% hObject    handle to paraUpdateBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.currentIndex == -1)
    msgbox('数据未初始化！', '警告');
    return;
end
x = get(handles.paraEdit2, 'string');
if (~isfield(handles.originData{handles.currentIndex}, x)) 
    msgbox('文件中未找到数据变量名！', '数据名错误');
    return;
end
x = getfield(handles.originData{handles.currentIndex}, x);
dim = ndims(x);
siz = size(x);
if dim(1) ~= 2
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) ~= 1
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) == 1
    x = x';
end
N = length(x);
root  = power((sum(sqrt(abs(x))))/N,2);    %方根幅值
if handles.parameters(1) == -1
    handles.tableValue(1,2) = {'NULL'};
else
    handles.tableValue(1,2) = {root};
end
aver  = sum(abs(x))/N;                     %均值
if handles.parameters(2) == -1
    handles.tableValue(2,2) = {'NULL'};
else
    handles.tableValue(2,2) = {aver};
end
rms  = sqrt(sum(x.^2)/N);                  %均方根值
if handles.parameters(3) == -1
    handles.tableValue(3,2) = {'NULL'};
else
    handles.tableValue(3,2) = {rms};
end
peak  = max(abs(x));                       %峰值
if handles.parameters(4) == -1
    handles.tableValue(4,2) = {'NULL'};
else
    handles.tableValue(4,2) = {peak};
end
if handles.parameters(5) == -1
    handles.tableValue(5,2) = {'NULL'};
else
    handles.tableValue(5,2)  = {max(x) - min(x)};   %峰峰值
end
if handles.parameters(6) == -1
    handles.tableValue(6,2) = {'NULL'};
else
    handles.tableValue(6,2)  = {rms/aver};			%波形指标	
end
if handles.parameters(7) == -1
    handles.tableValue(7,2) = {'NULL'};
else
    handles.tableValue(7,2)  = {peak/rms};			%峰值指标
end
if handles.parameters(8) == -1
    handles.tableValue(8,2) = {'NULL'};
else
    handles.tableValue(8,2)  = {peak/aver};			%脉冲指标
end
if handles.parameters(9) == -1
    handles.tableValue(9,2) = {'NULL'};
else
    handles.tableValue(9,2)  = {peak/root};			%裕度指标
end
if handles.parameters(10) == -1
    handles.tableValue(10,2) = {'NULL'};
else
    handles.tableValue(10,2) = {kurtosis(x)};       %峭度指标
end
guidata(hObject, handles);
set(handles.paraTable, 'data', handles.tableValue);
maxLen = handles.parameters(11);
T = 1:maxLen;
X = zeros(1,maxLen);
TAG = cell(1, maxLen);
i = 1;
for n = 1:10
    if handles.parameters(n) == -1
        continue;
    end
    X(i) = handles.tableValue{n,2};
    TAG(i) = handles.tableValue(n, 1);
    i = i + 1;
end
axes(handles.paraBar);
bar(T, X), xlim([0, maxLen+1]);
set(gca, 'XTickLabel', TAG);

% --- Executes on button press in tableC.
function tableC_Callback(hObject, ~, handles)
set(handles.paraTablePanel, 'visible', 'on');
set(handles.paraBarPanel,   'visible', 'off');
% hObject    handle to tableC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tableC


% --- Executes on button press in barC.
function barC_Callback(hObject, eventdata, handles)
set(handles.paraTablePanel, 'visible', 'off');
set(handles.paraBarPanel,   'visible', 'on');
% hObject    handle to barC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of barC



function freqEdit_Callback(hObject, eventdata, handles)
% hObject    handle to freqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freqEdit as text
%        str2double(get(hObject,'String')) returns contents of freqEdit as a double


% --- Executes during object creation, after setting all properties.
function freqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function paraEdit_Callback(hObject, eventdata, handles)
% hObject    handle to paraEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
paraName = get(handles.paraEdit, 'string');
set(handles.paraEdit2, 'string', paraName);
% Hints: get(hObject,'String') returns contents of paraEdit as text
%        str2double(get(hObject,'String')) returns contents of paraEdit as a double


% --- Executes during object creation, after setting all properties.
function paraEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paraEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function paraEdit2_Callback(hObject, ~, handles)
% hObject    handle to paraEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
paraName = get(handles.paraEdit2,'string');
set(handles.paraEdit, 'string', paraName);
% Hints: get(hObject,'String') returns contents of paraEdit2 as text
%        str2double(get(hObject,'String')) returns contents of paraEdit2 as a double


% --- Executes during object creation, after setting all properties.
function paraEdit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paraEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dataCount_Callback(hObject, eventdata, handles)
% hObject    handle to dataCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataCount as text
%        str2double(get(hObject,'String')) returns contents of dataCount as a double


% --- Executes during object creation, after setting all properties.
function dataCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in confirmCount.
function confirmCount_Callback(hObject, eventdata, handles)
% hObject    handle to confirmCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
count = get(handles.dataCount, 'string');
count = floor(str2double(count));
if (isnan(count))
    msgbox('请输入有效数字！', '警告');
    return;
elseif (count < 2)
    msgbox('类组数必须>=2！', '警告');
    return;
end
handles.count = count;
kernelName = cell(1,count);
T = count;
count = cell(1,T);
temp = cell(1, T);
trainData = cell(1, T);
for n = 1:T
    count(n) = {int2str(n)};
    temp(n) = {int2str(n)};
    trainData(n) = {'NULL'};
    kernelName{n} = 'linear';
end
set(handles.dataNickName, 'string', '1');
set(handles.dataList, 'string', count);
set(handles.dataLeft, 'string', count);
set(handles.dataRight,'string', count);
set(handles.dataRight,'value' , 2);
handles.svmTrainData = trainData;
handles.svmNickName = temp;
handles.svmKernelFunc = kernelName;
set(handles.nickConfirmBtn, 'enable', 'on');
set(handles.funcConfirm, 'enable', 'on');
set(handles.trainStart, 'enable', 'on');
guidata(hObject, handles);

% --- Executes on selection change in trainDataMenu.
function trainDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to trainDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trainDataMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trainDataMenu


% --- Executes during object creation, after setting all properties.
function trainDataMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dataList.
function dataList_Callback(hObject, eventdata, handles)
% hObject    handle to dataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.dataList, 'string');
if (strcmp(str, '0'))
    msgbox('请先确定数据组！', '警告');
    return;
end
index = get(handles.dataList, 'value');
currentNickName = handles.svmNickName{index};
set(handles.dataNickName, 'string', currentNickName);
% Hints: contents = cellstr(get(hObject,'String')) returns dataList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataList


% --- Executes during object creation, after setting all properties.
function dataList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dataLeft.
function dataLeft_Callback(hObject, eventdata, handles)
% hObject    handle to dataLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.dataLeft, 'value');
if index == handles.count
    set(handles.dataRight, 'value', index-1);
else
    set(handles.dataRight, 'value', index+1);
end
% Hints: contents = cellstr(get(hObject,'String')) returns dataLeft contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataLeft


% --- Executes during object creation, after setting all properties.
function dataLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dataRight.
function dataRight_Callback(hObject, eventdata, handles)
% hObject    handle to dataRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dataRight contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataRight


% --- Executes during object creation, after setting all properties.
function dataRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in kernelFunc.
function kernelFunc_Callback(hObject, eventdata, handles)
% hObject    handle to kernelFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kernelFunc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kernelFunc


% --- Executes during object creation, after setting all properties.
function kernelFunc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kernelFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in defaultKernelBtn.
function defaultKernelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to defaultKernelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function dataNickName_Callback(hObject, eventdata, handles)
% hObject    handle to dataNickName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataNickName as text
%        str2double(get(hObject,'String')) returns contents of dataNickName as a double


% --- Executes during object creation, after setting all properties.
function dataNickName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataNickName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in testDataMenu.
function testDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to testDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns testDataMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from testDataMenu


% --- Executes during object creation, after setting all properties.
function testDataMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in svmRunBtn.
function svmRunBtn_Callback(hObject, eventdata, handles)
% hObject    handle to svmRunBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.testDataMenu, 'string');
if strcmp(str, '请选择数据')
    msgbox('请在下拉框内选择测试数据！', '警告');
    return;
end
param = get(handles.testParam, 'string');
dataIndex = get(handles.testDataMenu, 'value');
if (~isfield(handles.originData{dataIndex}, param)) 
    msgbox('文件中未找到数据变量名！', '数据名错误');
    return;
end
points = get(handles.testDataPoints, 'string');
points = floor(str2double(points));
if isnan(points)
    msgbox('请输入有效样本点数！', '警告');
    return;
elseif points <= 0
    msgbox('样本点数>=1！', '警告');
    return;
end
set(handles.testDataPoints, 'string', int2str(points));
x = getfield(handles.originData{dataIndex}, param);
dim = ndims(x);
siz = size(x);
if dim(1) ~= 2
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) ~= 1
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) == 1
    x = x';
end
delay = get(handles.delayEdit, 'string');
delay = floor(str2double(delay));
m = get(handles.dimEdit, 'string');
m = floor(str2double(m));
S = get(handles.sEdit, 'string');
S = floor(str2double(S));
msgbox('正在处理测试数据并运行，可能耗时较长……', '提示');
N = length(x);
sec = floor(N/points);
MPE = zeros(sec, S);        %testDataCombined
pos = 0;
for n = 1:sec
    MPE(n, :) = MPerm(x(pos+1:pos+points), m, delay, S); 
    pos = pos + points;
end
count = handles.count;
resOutput = cell(1, sec);
for n = 1:sec
    resOutput{n} = 'ERROR';
    for m = 1:count
        if m == count
            resOutput{n} = handles.svmNickName{count};
            break;
        end
        if (svmclassify(handles.SVMs{m}, MPE(n,:)) == 1)
            resOutput{n} = handles.svmNickName{m};
            break;
        end
    end
end
handles.tableOutput = [handles.tableOutput; resOutput];
set(handles.svmTable, 'data', handles.tableOutput);
guidata(hObject, handles);

% --- Executes on button press in nickConfirmBtn.
function nickConfirmBtn_Callback(hObject, eventdata, handles)
% hObject    handle to nickConfirmBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.dataList, 'string');
if strcmp(str, '0')
    msgbox('请选择有效组类', '警告');
    return;
end
str = get(handles.trainDataMenu, 'string');
if strcmp(str, '请选择数据')
    msgbox('请在下拉框内选择训练数据', '警告');
    return;
end
param = get(handles.trainParam, 'string');
dataIndex = get(handles.trainDataMenu, 'value');
if (~isfield(handles.originData{dataIndex}, param)) 
    msgbox('文件中未找到数据变量名！', '数据名错误');
    return;
end
points = get(handles.trainDataPoints, 'string');
points = floor(str2double(points));
if isnan(points)
    msgbox('请输入有效样本点数！', '警告');
    return;
elseif points <= 0
    msgbox('样本点数>=1！', '警告');
    return;
end
set(handles.trainDataPoints, 'string', int2str(points));
index = get(handles.dataList, 'value');
nickName = get(handles.dataNickName, 'string');
x = getfield(handles.originData{dataIndex}, param);
dim = ndims(x);
siz = size(x);
if dim(1) ~= 2
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) ~= 1
    msgbox('请选择一组向量', '错误');
    return;
elseif siz(1) ~= 1 && siz(2) == 1
    x = x';
end
delay = get(handles.delayEdit, 'string');
delay = str2double(delay);
if isnan(delay)
    msgbox('请输入正确的延迟时间！', '错误');
    return;
elseif delay <= 0
    msgbox('延迟时间必须>=1！', '错误');
    return;
end
set(handles.delayEdit, 'string', int2str(delay));
m = get(handles.dimEdit, 'string');
m = str2double(m);
if isnan(m)
    msgbox('请输入正确的维数！', '错误');
    return;
elseif m <= 0
    msgbox('位数必须>=1！', '错误');
    return;
end
set(handles.dimEdit, 'string', int2str(m));
S = get(handles.sEdit, 'string');
S = str2double(S);
if isnan(S)
    msgbox('请输入正确的最大尺度因子！', '错误');
    return;
elseif S <= 0
    msgbox('最大尺度因子必须>=1！', '错误');
    return;
end
set(handles.sEdit, 'string', int2str(S));
msgbox('正在计算多尺度排列熵，可能耗时较长……', '提示');
N = length(x);
sec = floor(N/points);
MPE = zeros(sec, S);
pos = 0;
for n = 1:sec
    MPE(n, :) = MPerm(x(pos+1:pos+points), m, delay, S); 
    pos = pos + points;
end
msgbox('该组数据初始化完成', '完成');
handles.svmTrainData{index} = MPE;
handles.svmNickName{index} = nickName;
set(handles.delayEdit, 'enable', 'off');
set(handles.dimEdit,   'enable', 'off');
set(handles.sEdit,     'enable', 'off');
guidata(hObject, handles);

function trainParam_Callback(hObject, eventdata, handles)
% hObject    handle to trainParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainParam as text
%        str2double(get(hObject,'String')) returns contents of trainParam as a double


% --- Executes during object creation, after setting all properties.
function trainParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testParam_Callback(hObject, ~, handles)
% hObject    handle to testParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testParam as text
%        str2double(get(hObject,'String')) returns contents of testParam as a double


% --- Executes during object creation, after setting all properties.
function testParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in trainStart.
function trainStart_Callback(hObject, eventdata, handles)
% hObject    handle to trainStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
count = handles.count;
errorStr = '';
for n = 1:count
    if ischar(handles.svmTrainData{n})
        errorStr = strcat(errorStr, int2str(n));
        errorStr = strcat(errorStr, ',');
    end;
end
if ~strcmp(errorStr, '')
    errorStr = strcat('未初始化', errorStr);
    errorStr = strcat(errorStr, '组数据！');
    msgbox(errorStr, '警告');
    return;
end
SVMs = cell(1, count-1);
len = zeros(1, count);
for n = 1:count
    [temp,~] = size(handles.svmTrainData{n});
    len(n) = temp;
end
totLen = sum(len);
[r, c] = size(handles.svmTrainData{1});
dataGroup = zeros(1, totLen);
lastPos = 0;
dataCombined = cell2mat(handles.svmTrainData');
for n = 1:count-1
    dataGroup(lastPos+1:lastPos+len(n)) = 1;
    lastPos = lastPos + len(n);
    SVMs{n} = svmtrain(dataCombined, dataGroup, 'kernel_function', ...
                       handles.svmKernelFunc{n});
end
handles.SVMs = SVMs;
handles.dataCombined = dataCombined;
msgbox('训练完成！', '完成');
guidata(hObject, handles);
set(handles.svmRunBtn, 'enable', 'on');


function trainDataPoints_Callback(hObject, eventdata, handles)
% hObject    handle to trainDataPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainDataPoints as text
%        str2double(get(hObject,'String')) returns contents of trainDataPoints as a double


% --- Executes during object creation, after setting all properties.
function trainDataPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainDataPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testDataPoints_Callback(hObject, eventdata, handles)
% hObject    handle to testDataPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testDataPoints as text
%        str2double(get(hObject,'String')) returns contents of testDataPoints as a double


% --- Executes during object creation, after setting all properties.
function testDataPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testDataPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delayEdit_Callback(hObject, eventdata, handles)
% hObject    handle to delayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delayEdit as text
%        str2double(get(hObject,'String')) returns contents of delayEdit as a double


% --- Executes during object creation, after setting all properties.
function delayEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimEdit_Callback(hObject, eventdata, ~)
% hObject    handle to dimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimEdit as text
%        str2double(get(hObject,'String')) returns contents of dimEdit as a double


% --- Executes during object creation, after setting all properties.
function dimEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sEdit_Callback(hObject, eventdata, handles)
% hObject    handle to sEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sEdit as text
%        str2double(get(hObject,'String')) returns contents of sEdit as a double


% --- Executes during object creation, after setting all properties.
function sEdit_CreateFcn(hObject, eventdata, ~)
% hObject    handle to sEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in funcConfirm.
function funcConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to funcConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.dataLeft, 'value');
kernelName = get(handles.kernelFunc, 'string');
i = get(handles.kernelFunc, 'value');
handles.svmKernelFunc{index} = kernelName{i};
guidata(hObject, handles);

% --- Executes on button press in svmReset.
function svmReset_Callback(hObject, eventdata, handles)
% hObject    handle to svmReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.tableOutput = cell(0,0);
set(handles.delayEdit, 'enable', 'on');
set(handles.dimEdit, 'enable', 'on');
set(handles.sEdit, 'enable', 'on');
set(handles.nickConfirmBtn, 'enable', 'off');
set(handles.funcConfirm, 'enable', 'off');
default = cell(1,1);
default{1} = '请选择数据';
set(handles.trainDataMenu, 'string', default);
set(handles.trainDataMenu, 'value', 1);
set(handles.testDataMenu, 'string', default);
set(handles.testDataMenu, 'value', 1);
set(handles.trainParam, 'string', 'DATA');
set(handles.testParam, 'string', 'DATA');
set(handles.trainDataPoints, 'string', '0');
set(handles.testDataPoints, 'string', '0');
set(handles.trainStart, 'enable', 'off');
set(handles.svmTable, 'data', cell(0, 0));
set(handles.dataCount, 'string', '0');
default = cell(1,1);
default{1} = '0';
set(handles.dataList, 'string', default);
set(handles.dataList, 'value', 1);
set(handles.dataNickName, 'string', '');

guidata(hObject, handles);


% --- Executes on button press in openOutsideBtn.
function openOutsideBtn_Callback(hObject, eventdata, handles)
% hObject    handle to openOutsideBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
outerPlot(handles.t, handles.x);


% --- Executes during object creation, after setting all properties.
function showArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate showArea
