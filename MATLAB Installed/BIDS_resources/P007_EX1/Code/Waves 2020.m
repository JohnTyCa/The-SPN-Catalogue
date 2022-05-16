close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 7/EX1 Disc Reg/Grand Averages';
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames = {'ReflectionFlat','ReflectionSlant', 'RandomFlat','RandomSlant'};

%ELECTRODES
electrodes = [20 21 22 23 25 26 57 58 59 60 62 63];


%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'on';

%GRAPHICAL PROPERTIES
FontSize = 20;
LineWidth = 4;
set(0,'DefaultAxesFontSize', FontSize);

% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = mean(data(electrodes,1:end),1)';
    if strcmp(smoothOn, 'on') == 1;
        data = smooth(data,smoothfactor,'moving'); % take this off when doing individuals in background plot.
    end
    selectedData.(c).data = data;
end

%save('thisPlot','selectedData');

%use this to plot ERPs
ReflectionFlat= selectedData.ReflectionFlat.data;
ReflectionSlant= selectedData.ReflectionSlant.data;
RandomFlat= selectedData.RandomFlat.data;
RandomSlant= selectedData.RandomSlant.data;
DiffFlat= ReflectionFlat - RandomFlat;
DiffSlant= ReflectionSlant - RandomSlant;
Zeroline = zeros(length(timeVector),1);


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0.5 0 0],[0 0 1],[0 0 0.5]}';
figure('color',[1,1,1])
P = plot(timeVector, [ReflectionFlat,RandomFlat,ReflectionSlant,RandomSlant],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'ReflectionFlat','RandomFlat','ReflectionSlant','RandomSlant'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1],[0 0 0]}'; 
figure('color',[1,1,1])
P = plot(timeVector, [DiffFlat,DiffSlant,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Flat','Slant'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')


close all
%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0.5 0 0],[1 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomSlant,ReflectionSlant],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random Slant','Reflection Slant'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%Figure 2


StyleArray = {'LineStyle'};
StyleOrder = {'-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 0]}'; 
figure('color',[1,1,1])
P = plot(timeVector, [DiffSlant,Zeroline],'LineWidth',LineWidth);
xline(300)
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
%legend({'Flat','Slant'},'FontSize',FontSize,'Location','southeast');
xline(300)
yline(-1.164)
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')