close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX2 Symm probe Symm/Grand Averages'
load timeVector;
load grandAverages;
load grandAveragesNoICA;
%CONDITIONS
conditionNames={'SymmetryMemory','RandomMemory','SymmetryPassive','RandomPassive'};

%ELECTRODES
%electrodes = [25 27 62 64]; % PO7 O1 O2 PO8
electrodes = [1 33 34]; % FP1 FPz FP2



%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 10;
smoothOn = 'off';

%GRAPHICAL PROPERTIES
FontSize = 28;
LineWidth = 2;
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

SymmetryMemory=selectedData.SymmetryMemory.data;
RandomMemory=selectedData.RandomMemory.data;
SymmetryPassive= selectedData.SymmetryPassive.data;
RandomPassive=selectedData.RandomPassive.data;
DiffSymmetryMemory = SymmetryMemory-RandomMemory;
DiffSymmetryPassive = SymmetryPassive-RandomPassive;
Zeroline = zeros(length(timeVector),1);

%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 0 1],[0 1 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomMemory,SymmetryMemory,RandomPassive,SymmetryPassive],'LineWidth',LineWidth);
axis([-200 750 -4 9]);
set(gca,'YTick',-4:2:8);
set(gca,'XTick',-0:250:750,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random Memory','Symmetry Memory','Random Passive','Symmetry Passive'},'FontSize',20,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffSymmetryMemory,DiffSymmetryPassive,Zeroline],'LineWidth',LineWidth);
axis([-200 750 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',0:250:750,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Symmetry Memory','Symmetry Passive'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')




