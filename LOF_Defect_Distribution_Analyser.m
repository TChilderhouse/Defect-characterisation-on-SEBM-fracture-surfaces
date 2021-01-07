%% LOF Defect Distribution Analyser
% 07-Jan-2021
% Script for post-processing of BW data files generated using Matlabs Find
% circles function in the segmentImage imageSegmenter app.

%% Setup Parameters

p = 4;                % Pixel Size (micron) 
% D_min = 6;          % Min Powder Dia (pixel)
% D_max = 14;         % Max Powder Dia (pixel)
A = 4050000;          % Specimen X-sectional area (No. of pixels) 

%% Import BW Data Files

% SEBM
BW_H2 = importdata('BW_H2.mat');  % D050
BW_H4 = importdata('BW_H4.mat');  % D100
BW_J2 = importdata('BW_J2.mat');  % As-Built

% SEBM + HIP
BW_G6 = importdata('BW_G6.mat');  % D050
BW_E1 = importdata('BW_E1.mat');  % D100
BW_C5 = importdata('BW_C5.mat');  % As-Built

%% Logic to Matrix
%  This converts the logic BW data files to matrix type

% Specimen H2
for a=1:1435
  for b=1:5117
      if BW_H2(a,b)==true
         H2(a,b)=1;
      else
         H2(a,b)=0;
      end
   end
end

% Specimen H4
for a=1:1435
  for b=1:5117
      if BW_H4(a,b)==true
         H4(a,b)=1;
      else
         H4(a,b)=0;
      end
   end
end

% Specimen J2
for a=1:1434
  for b=1:5117
      if BW_J2(a,b)==true
         J2(a,b)=1;
      else
         J2(a,b)=0;
      end
   end
end

% Specimen G6
for a=1:1434
  for b=1:5117
      if BW_G6(a,b)==true
         G6(a,b)=1;
      else
         G6(a,b)=0;
      end
   end
end

% Specimen E1
for a=1:1434
  for b=1:5117
      if BW_E1(a,b)==true
         E1(a,b)=1;
      else
         E1(a,b)=0;
      end
   end
end

% Specimen C5
for a=1:1434
  for b=1:5117
      if BW_C5(a,b)==true
         C5(a,b)=1;
      else
         C5(a,b)=0;
      end
   end
end

%% Get Distribution

n_H2 = 250; % Offset above specimen:
n_H4 = 230; % This is calculated based on the number of pixels of empty 
n_J2 = 255; % space between the start of the specimen and the top of the image.
n_G6 = 250;
n_E1 = 244;
n_C5 = 258;

x_H2 = linspace(0,1435,1435);
S_H2 = sum(H2,2);
A_H2  = 100*(sum(S_H2)/A);

x_H4 = linspace(0,1435,1435);
S_H4 = sum(H4,2);
A_H4  = 100*(sum(S_H4)/A);

x_J2 = linspace(0,1434,1434);
S_J2 = sum(J2,2);
A_J2  = 100*(sum(S_J2)/A);

x_G6 = linspace(0,1434,1434);
S_G6 = sum(G6,2);
A_G6  = 100*(sum(S_G6)/A);

x_E1 = linspace(0,1434,1434);
S_E1 = sum(E1,2);
A_E1  = 100*(sum(S_E1)/A);

x_C5 = linspace(0,1434,1434);
S_C5 = sum(C5,2);
A_C5  = 100*(sum(S_C5)/A);

%% Plot Spatial Distributions

%  As-built condition
figure
subplot(3,1,1)
plot((x_J2-n_J2)*p,100*(S_J2/A),'k');
hold on
plot((x_C5-n_C5)*p,100*(S_C5/A),'k:');
hold on
patch([0 800 800 0], [2 2 0 0],'k','FaceAlpha',.2,'EdgeColor','none')
patch([800 3600 3800 800], [2 2 0 0],'k','FaceAlpha',.07,'EdgeColor','none')
xlim([0 3800])
ylim([0 0.025])
ytickformat('%.2f')
grid on
box on
set(gca, 'FontName', 'Times New Roman')
set(0,'DefaultAxesTitleFontWeight','normal');
%title('(a)' )
legend('As-built','As-built + HIP','Contoured','Hatched')

%  Machined 0.50 mm
subplot(3,1,2)
plot((x_H2-n_H2)*p,100*(S_H2/A),'r');
hold on
plot((x_G6-n_G6)*p,100*(S_G6/A),'r:');
hold on
patch([0 300 300 0], [2 2 0 0],'k','FaceAlpha',.2,'EdgeColor','none')
patch([300 3800 3800 300], [2 2 0 0],'k','FaceAlpha',.07,'EdgeColor','none')
xlim([0 3800])
ylim([0 0.025])
ytickformat('%.2f')
ylabel({'Area fraction of unmelted powder (%)'})
grid on
box on
%title('(b)')
legend('Machined - 0.50 mm','Machined - 0.50 mm + HIP')
set(gca, 'FontName', 'Times New Roman')

%  Machined 1.00 mm
subplot(3,1,3)
plot((x_H4-n_H4)*p,100*(S_H4/A),'b');
hold on
plot((x_E1-n_E1)*p,100*(S_E1/A),'b:');
hold on
patch([3400 3600 3800 3400], [2 2 0 0],'k','FaceAlpha',.2,'EdgeColor','none')
patch([0 3400 3400 0], [2 2 0 0],'k','FaceAlpha',.07,'EdgeColor','none')
xlim([0 3800])
ylim([0 0.025])
ytickformat('%.2f')
xlabel('Distance from test surface in y-direction (\mum)')
grid on
box on
%title('(c)')
legend({'Machined - 1.00 mm','Machined - 1.00 mm + HIP'},'location','northwest')
set(gca, 'FontName', 'Times New Roman')

%set(gcf,'position', [ 488,265,560,500 ])

%% Overlay Pores Detected on Fractograph Images

J2 = imread('J2.png');
C5 = imread('C5.png');

H2 = imread('H2.png');
G6 = imread('G6.png');

H4 = imread('H4.png');
E1 = imread('E1.png');

%% 
%  As-built condition
figure;
imshow(J2, [], 'Colormap', hot);
alphamask(BW_J2, [1 0 0], 0.5);
title('J2 - As-Built')
%% 
%  As-built condition
figure;
imshow(C5, [], 'Colormap', hot);
alphamask(BW_C5, [1 0 0], 0.5);
title('C5 - As-Built')
%%
%  Machined 0.50 mm
figure;
imshow(H2, [], 'Colormap', hot);
alphamask(BW_H2, [1 0 0], 0.5);
title('H2 - D050')
%%
%  Machined 0.50 mm
figure;
imshow(G6, [], 'Colormap', hot);
alphamask(BW_G6, [1 0 0], 0.5);
title('G6 - D050')
%%
%  Machined 1.00 mm
figure;
imshow(H4, [], 'Colormap', hot);
alphamask(BW_H4, [1 0 0], 0.5);
title('H4 - D100')
%%
%  Machined 1.00 mm
figure;
imshow(E1, [], 'Colormap', hot);
alphamask(BW_E1, [1 0 0], 0.5);
title('E1 - D100')
