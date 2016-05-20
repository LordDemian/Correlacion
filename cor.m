function varargout = cor(varargin)
% COR MATLAB code for cor.fig
%      COR, by itself, creates a new COR or raises the existing
%      singleton*.
%
%      H = COR returns the handle to a new COR or the handle to
%      the existing singleton*.
%
%      COR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COR.M with the given input arguments.
%
%      COR('Property','Value',...) creates a new COR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cor

% Last Modified by GUIDE v2.5 17-May-2016 15:21:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cor_OpeningFcn, ...
                   'gui_OutputFcn',  @cor_OutputFcn, ...
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


% --- Executes just before cor is made visible.
function cor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cor (see VARARGIN)

% Choose default command line output for cor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cor wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global A A2 A3 A4 M
load('AM.mat','A','M');
load('A.mat','A2','A3','A4');

% --- Outputs from this function are returned to the command line.
function varargout = cor_OutputFcn(hObject, eventdata, handles) 
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
global A A2 A3 A4 M

Fs=8000;
recorder = audiorecorder(Fs,16,1);
disp('Start speaking.');
recordblocking(recorder, 1.5);
disp('End of recording');
B=getaudiodata(recorder);
sound(B,Fs)

B=B/abs(max(B));


% corrA=xcorr(A,A);
% corrM=xcorr(M,M);
% corrAB=xcorr(A,B);
% corrMB=xcorr(M,B);

% corrAord=sort(corrA);
% corrABord=sort(corrAB);
% corrMord=sort(corrM);
% corrMBord=sort(corrMB);
% 
% v=50;
% vi=1500+v;
% L=length(corrAord);
% L1=length(corrABord);
% mA=(corrAord(L-v)-corrAord(L-vi))/(vi-v);
% mAB=(corrABord(L1-v)-corrABord(L1-vi))/(vi-v);
% pncAB=(mAB/mA)*100
% 
% L=length(corrMord);
% L1=length(corrMBord);
% mM=(corrMord(L-v)-corrMord(L-vi))/(vi-v);
% mMB=(corrMBord(L1-v)-corrMBord(L1-vi))/(vi-v);
% pncMB=(mMB/mM)*100

maxlagsA = numel(A)*0.5;
maxlagsA2 = numel(A2)*0.5;
maxlagsA3 = numel(A3)*0.5;
maxlagsA4 = numel(A4)*0.5;

maxlagsM = numel(M)*0.5;

[corrA,lagA]=xcorr(A,A,maxlagsA);
[corrA2,lagA2]=xcorr(A2,A2,maxlagsA2);
[corrA3,lagA3]=xcorr(A3,A3,maxlagsA3);
[corrA4,lagA4]=xcorr(A4,A4,maxlagsA4);


[corrM,lagM]=xcorr(M,M,maxlagsM);


[corrAB,lagAB]=xcorr(A,B,maxlagsA);
[corrA2B,lagA2B]=xcorr(A2,B,maxlagsA2);
[corrA3B,lagA3B]=xcorr(A3,B,maxlagsA3);
[corrA4B,lagA4B]=xcorr(A4,B,maxlagsA4);

[corrMB,lagMB]=xcorr(M,B,maxlagsM);

[~,dfA] = findpeaks(corrA,'MinPeakDistance',5*2*24*10);
[~,dfA2] = findpeaks(corrA2,'MinPeakDistance',5*2*24*10);
[~,dfA3] = findpeaks(corrA3,'MinPeakDistance',5*2*24*10);
[~,dfA4] = findpeaks(corrA4,'MinPeakDistance',5*2*24*10);

[~,dfM] = findpeaks(corrM,'MinPeakDistance',5*2*24*10);

[~,dfAB] = findpeaks(corrAB,'MinPeakDistance',5*2*24*10);
[~,dfA2B] = findpeaks(corrA2B,'MinPeakDistance',5*2*24*10);
[~,dfA3B] = findpeaks(corrA3B,'MinPeakDistance',5*2*24*10);
[~,dfA4B] = findpeaks(corrA4B,'MinPeakDistance',5*2*24*10);

[~,dfMB] = findpeaks(corrMB,'MinPeakDistance',5*2*24*10);

P100A=corrA(dfA(3))-corrA(dfA(4));
P100A2=corrA2(dfA2(3))-corrA2(dfA2(4));
P100A3=corrA3(dfA3(2))-corrA3(dfA3(3));
P100A4=corrA4(dfA4(3))-corrA4(dfA4(4));

P100M=corrM(dfM(3))-corrM(dfM(4));
pAB=abs(corrAB(dfAB(3))-corrAB(dfAB(4)));
pA2B=abs(corrA2B(dfA2B(3))-corrA2B(dfA2B(4)));
pA3B=abs(corrA3B(dfA3B(3))-corrA3B(dfA3B(4)));
pA4B=abs(corrA4B(dfA4B(3))-corrA4B(dfA4B(4)));

pMB=abs(corrMB(dfMB(3))-corrMB(dfMB(4)));

pAB=(pAB/P100A)*100
pA2B=(pA2B/P100A2)*100
pA3B=(pA3B/P100A3)*100
pA4B=(pA4B/P100A4)*100
promA=(pAB+pA2B+pA3B+pA4B)/4
%pABmax=max([pAB pA2B pA3B pA4B])

pMB=(pMB/P100M)*100

if pMB>=15 || promA>=30
    if pMB>promA
    axes(handles.axes1)
    matlabImage = imread('elcapo.jpg');
    image(matlabImage)
    axis off
    axis image
    else
    axes(handles.axes1)
    matlabImage = imread('demilindo.jpg');
    image(matlabImage)
    axis off
    axis image
    end
else
axes(handles.axes1)
matlabImage = imread('404.jpg');
image(matlabImage)
axis off
axis image
end
