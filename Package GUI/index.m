function varargout = index(varargin)
% INDEX MATLAB code for index.fig
%      INDEX, by itself, creates a new INDEX or raises the existing
%      singleton*.
%
%      H = INDEX returns the handle to a new INDEX or the handle to
%      the existing singleton*.
%
%      INDEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INDEX.M with the given input arguments.
%
%      INDEX('Property','Value',...) creates a new INDEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before index_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to index_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help index

% Last Modified by GUIDE v2.5 07-Dec-2017 20:48:22


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @index_OpeningFcn, ...
                   'gui_OutputFcn',  @index_OutputFcn, ...
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


% --- Executes just before index is made visible.
function index_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to index (see VARARGIN)

% Choose default command line output for index
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes index wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = index_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Lognormal_analysis.
function Lognormal_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Lognormal_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scrsz = get(groot,'ScreenSize');
disp('Testing Lognormality:')
figure('Position',[2 scrsz(4)/(5) scrsz(3)*(2/  3) scrsz(4)*(6/9)])
PROC_lognormal_test

% --- Executes on button press in Linear_Multifractal_analysis.
function Linear_Multifractal_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Linear_Multifractal_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scrsz = get(groot,'ScreenSize');
disp('Testing Multifractal Linearity')
figure('Position',[2 scrsz(4)/2 scrsz(3)*(2/3) scrsz(4)/2])
PROC_linear_multifractal_analisis

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('studyarea.mat')
load('stationsLocOBS19.mat')
load('stationsLocGEN19.mat')
load('Stations_names19.mat')

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])

imagesc(studyarea)
title('Study Area Stations','interpreter','latex','Fontsize',14)

pause(0.5) %in seconds 

StationPositions=[220 280; 110 220; 200 225; 160 400;...
    280 410 ; 70 200; 400 250; 250 90; 305 305; 375 340;...
    90 440; 160 325; 30 240; 175 445; 260 195; 80 365;...
    170 170; 240 445 ;460 55];

    for i=1:19

    text(StationPositions(i,1),StationPositions(i,2),'$\bullet$','color','r','Fontsize',18,'interpreter','latex','Fontsize',14,'FontWeight','bold')
    text(StationPositions(i,1),StationPositions(i,2)-25,strtrim(names(i,:)),'color','k'...
        ,'BackgroundColor',[1 1 1],'HorizontalAlignment','center','interpreter','latex','Fontsize',14,'FontWeight','bold')
    pause(0.5)
    
    end


% --- Executes on button press in Computing_multifractal.
function Computing_multifractal_Callback(hObject, eventdata, handles)
% hObject    handle to Computing_multifractal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(' ')
disp('Computing multifractal parameters beta and sigma for a whole month, and')
disp('plotting them versus their corresponding mean rainfall values')
disp(' ')

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)*(2/3) scrsz(4)/2])

PROC_BetSig2vsmean



% --- Executes on button press in Downscaling_TRMM.
function Downscaling_TRMM_Callback(hObject, eventdata, handles)
% hObject    handle to Downscaling_TRMM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(' ')
disp('Downscaling TRMM and correcting with ANUSPLINE')
disp(' ')

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)*(2/3) scrsz(4)/2])
PROC_Downscaling


disp('Continue... ')    
pause(0.5)

% Downscaling TRMM and correcting with ANUSPLINE

disp(' ')
disp('Exceedance plot and QQplot')
disp(' ')

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/(5) scrsz(3)*(2/3) scrsz(4)*(6/9)])

PROC_ECDFtemporal
