function varargout = main_GUI1(varargin)
% MAIN_GUI1 MATLAB code for main_GUI1.fig
%      MAIN_GUI1, by itself, creates a new MAIN_GUI1 or raises the existing
%      singleton*.
%
%      H = MAIN_GUI1 returns the handle to a new MAIN_GUI1 or the handle to
%      the existing singleton*.
%
%      MAIN_GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI1.M with the given input arguments.
%
%      MAIN_GUI1('Property','Value',...) creates a new MAIN_GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_GUI1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_GUI1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_GUI1

% Last Modified by GUIDE v2.5 21-Mar-2015 16:13:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_GUI1_OpeningFcn, ...
                   'gui_OutputFcn',  @main_GUI1_OutputFcn, ...
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


% --- Executes just before main_GUI1 is made visible.
function main_GUI1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_GUI1 (see VARARGIN)

% Choose default command line output for main_GUI1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_GUI1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_GUI1_OutputFcn(hObject, eventdata, handles) 
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

global I numfiles output pro spacev
load Trainfea



d = dir('Dataset/*.jpg');
numfiles = length(d);
for iii=1:numfiles 
 testimage=imread(['Dataset/',num2str(iii),'.jpg']);
 I=testimage;
 ima=I;
 ima=imresize(ima,[256,256]);
      [a b c]=size(I);
      if (I==3)
          I=rgb2gray(I);
      end
   Sx=3; 
 Sy=3; 
  L=8; 
f=[1/3.2,1/3.4,1/3.6,1/3.8]*2*pi; 
  th=[10:10:360];
   p1=ones(64,64); 
   level=graythresh(I);
   bw=im2bw(I,level); 
    [i,j]=find(bw==0); 
    imin=min(i); 
    imax=max(i); 
    jmin=min(j); 
    jmax=max(j); 
    bw1=bw(imin:imax,jmin:jmax); 
    rate=64/max(size(bw1)); 
    bw1=imresize(bw1,rate); 
    [i,j]=size(bw1); 
    i1=round((64-i)/2); 
    j1=round((64-j)/2); 
    p1(i1+1:i1+i,j1+1:j1+j)=bw1; 
    p1=double(p1); 
    m=1;
for fre=1:4 
   for i=1:L 
     sp = 1;  
   theta=(pi*i)/8;
     for x = -fix(Sx):fix(Sx) 
          for y = -fix(Sy):fix(Sy) 
            xPrime = x * cos(theta) + y * sin(theta); 
            yPrime = y * cos(theta) - x * sin(theta); 
             G(fix(Sx)+x+1,fix(Sy)+y+1) = exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2))*cos(2*pi*f(1,fre)*xPrime); 
          end 
     end 
  
      Imgabout = conv2( p1,double(imag(G)),'same'); 
     Regabout = conv2(p1,double(real(G)),'same'); 
  axes(handles.axes1);
   imshow(Regabout);
   pause(.1)
  axes(handles.axes3);
   imhist(Regabout)
convim{m}=mat2gray(Regabout);
m=m+1;
 
     imfea1(i)=mean2(Imgabout);
     imfea2(i)=mean2(Regabout);
     stfea1(i)=std2(Imgabout);
     srfea2(i)=std2(Regabout);
     medfea2(i)=mean(var(Regabout));     
end  
end 
 gabfea=[imfea2 srfea2 medfea2];
   I1=ima(1:256,1:64);
  I2=ima(1:256,65:128);
   I3=ima(1:256,129:192);
    I4=ima(1:256,193:256);
   lab = bwlabel(I1, 4);
STATS = regionprops(lab,'Area');
  stat1=regionprops(lab,'Centroid');
 stat3=regionprops(lab,'Eccentricity');
 stat2=regionprops(lab,'EquivDiameter');
  stat4=regionprops(lab,'Extent');
    stat8=regionprops(lab,'MajoraxisLength');
     stat9=regionprops(lab,'MinorAxisLength');
      stat5=regionprops(lab,'Orientation');
       stat6=regionprops(lab,'perimeter');
 regionfea=[STATS(1:1,1).Area stat1(1:1,1).Centroid stat2(1:1,1).EquivDiameter stat3(1:1,1).Eccentricity  stat4(1:1,1).Extent  stat5(1:1,1).Orientation stat6(1:1,1).Perimeter stat8(1:1,1).MajorAxisLength stat9(1:1,1).MinorAxisLength];

 lab1 = bwlabel(I2, 4);
staS = regionprops(lab1,'Area');
  sta1=regionprops(lab1,'Centroid');
 sta3=regionprops(lab1,'Eccentricity');
 sta2=regionprops(lab1,'EquivDiameter');
  sta4=regionprops(lab1,'Extent');
    sta8=regionprops(lab1,'MajoraxisLength');
     sta9=regionprops(lab1,'MinorAxisLength');
      sta5=regionprops(lab1,'Orientation');
       sta6=regionprops(lab1,'perimeter');
 regionfea1=[staS(1:1,1).Area sta1(1:1,1).Centroid sta2(1:1,1).EquivDiameter sta3(1:1,1).Eccentricity  sta4(1:1,1).Extent  sta5(1:1,1).Orientation sta6(1:1,1).Perimeter sta8(1:1,1).MajorAxisLength sta9(1:1,1).MinorAxisLength];

 lab2 = bwlabel(I3, 4);
sttat1 = regionprops(lab2,'Area');
  stta1=regionprops(lab2,'Centroid');
 stta3=regionprops(lab2,'Eccentricity');
 stta2=regionprops(lab2,'EquivDiameter');
  stta4=regionprops(lab2,'Extent');
    stta8=regionprops(lab2','MajoraxisLength');
     stta9=regionprops(lab2','MinorAxisLength');
      stta5=regionprops(lab2','Orientation');
       stta6=regionprops(lab2,'perimeter');
 regionfea2=[sttat1(1:1,1).Area stta1(1:1,1).Centroid stta2(1:1,1).EquivDiameter stta3(1:1,1).Eccentricity  stta4(1:1,1).Extent  stta5(1:1,1).Orientation stta6(1:1,1).Perimeter stta8(1:1,1).MajorAxisLength stta9(1:1,1).MinorAxisLength];
 lab4 = bwlabel(I4, 4);
    sttate1 = regionprops(lab2,'Area');
  state1=regionprops(lab2,'Centroid');
 state3=regionprops(lab2,'Eccentricity');
 state2=regionprops(lab2,'EquivDiameter');
  state4=regionprops(lab2,'Extent');
    state8=regionprops(lab2,'MajoraxisLength');
     state9=regionprops(lab2,'MinorAxisLength');
      state5=regionprops(lab2,'Orientation');
       state6=regionprops(lab2,'perimeter');
 regionfea3=[sttate1(1:1,1).Area state1(1:1,1).Centroid state2(1:1,1).EquivDiameter state3(1:1,1).Eccentricity  state4(1:1,1).Extent  state5(1:1,1).Orientation state6(1:1,1).Perimeter state8(1:1,1).MajorAxisLength state9(1:1,1).MinorAxisLength];
 fea=[gabfea regionfea regionfea1 regionfea2 regionfea3];
testfea(iii,:)=fea;     
end 
save testfea testfea
set(handles.uitable1,'data',testfea);
load final_train
set(handles.uitable2,'data',final_train);
a=2;
spacev(1)=1;
for i=2:length(pro)-1
if (pro(i).BoundingBox(1)-(pro(i-1).BoundingBox(1)+pro(i-1).BoundingBox(3)))>10
spacev(a) = i;a=a+1;
end
end
spacev(a)=length(pro)
testimage=imresize(testimage,[256,256]);
 for i =1:256
     for j=1:256
         npd(i,j)=(100-testimage(i,j))/100;
     end
 end
% % %%%%%%%%%%%%%%%%classification%%%%%%%%%%%%
 load target;
  load trainfea;
  load net;
  load label
  load testfea
  load final_train
  load target_of
  load trainfeat
  load  trainings_train
  load my_train
  
%   load testfea;
Tw1 = ind2vec(target');
spread=1;
net = newpnn(trainfea',Tw1,spread);
for i=1:numfiles
    testfea1=testfea(i,:);
yt1 = net(testfea1');
view(net);
 yt1=knnclassify(testfea(i,:), my_train,target_of);
%  yt1 = multisvm( ttt , ta' , testfea);
output(i) = (yt1);
end





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global iii numfiles output spacev

% -----------------------------RECOGNITION--------------------------------%
b=[];
for i=1:numfiles
a=imread(['PrintedCharacter/',num2str(output(i)),'.jpg']);
a=imresize(a,[50,50]);
s{i,:}=a;
b=[b a];
s{i,:}={a};
end
axes(handles.axes2);
imshow(b);title('Recognized word');
a=1;
for i=2:length(spacev)-1
outp{a}=output(spacev(i-1):spacev(i)-1);
a=a+1;
end
outp{a}=output(spacev(end-1):spacev(end));
load label
temp = label;
word = actxserver('Word.Application');
word.Visible = 1;
document = word.Documents.Add;
selection = word.Selection;
for i=1:length(outp)
selection.TypeText(' ');
    for j=1:length(outp{i})
        tt = temp{i};
        tq = temp{j};
       clc;
selection.TypeText(char(label{outp{i}(j)}));
selection.Style='Heading 1';
H1 = document.Styles.Item('Heading 1');
H1.Font.Name = 'Kruti Dev 060';
H1.Font.Size = 20;
H1.Font.Bold = 0;
    end
end
