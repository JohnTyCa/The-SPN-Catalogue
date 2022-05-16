close all
clear all

% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 12/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'AntiSymmetryDiscReg','SymmetryDiscReg','RandomDiscReg','AntiSymmetryDiscColor','SymmetryDiscColor','RandomDiscColor'};

%ELECTRODES
electrodes = [25 62]; % PO7 PO8


%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 10;
smoothOn = 'on';

%GRAPHICAL PROPERTIES
FontSize = 28;
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

%save('thisPlot','data');

%use this to plot ERPs
SymmetryDiscReg = selectedData.SymmetryDiscReg.data;
AntiSymmetryDiscReg = selectedData.AntiSymmetryDiscReg.data;
RandomDiscReg = selectedData.RandomDiscReg.data;
SymmetryDiscColor = selectedData.SymmetryDiscColor.data;
AntiSymmetryDiscColor = selectedData.AntiSymmetryDiscColor.data;
RandomDiscColor = selectedData.RandomDiscColor.data;
DiffSymmetryDiscReg = SymmetryDiscReg-RandomDiscReg;
DiffAntiSymmetryDiscReg = AntiSymmetryDiscReg-RandomDiscReg;
DiffSymmetryDiscColor = SymmetryDiscColor-RandomDiscColor;
DiffAntiSymmetryDiscColor = AntiSymmetryDiscColor-RandomDiscColor;
Zeroline = zeros(length(timeVector),1);


%Disc Reg Task
%Figure1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 0],[0.5 0.5 0.5]}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [SymmetryDiscReg, AntiSymmetryDiscReg, RandomDiscReg],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Symmetry','AntiSymmetry','Random'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%Figure2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffSymmetryDiscReg,DiffAntiSymmetryDiscReg,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Symmetry','AntiSymmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')


%Disc Col Task
%Figure3
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 0],[0.5 0.5 0.5]}';
figure('color',[1,1,1])
P = plot(timeVector, [SymmetryDiscColor, AntiSymmetryDiscColor, RandomDiscColor],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Symmetry','AntiSymmetry','Random'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%Figure4
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffSymmetryDiscColor,DiffAntiSymmetryDiscColor,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Symmetry','AntiSymmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')



