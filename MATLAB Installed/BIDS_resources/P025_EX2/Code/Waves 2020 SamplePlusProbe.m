close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX2 Symm Probe Symm/Grand Averages'
load timeVectorSamplePlusProbe;
load grandAveragesSamplePlusProbe
%CONDITIONS
conditionNames={'SymmetryMemory','RandomMemory','SymmetryPassive','RandomPassive'};

%ELECTRODES
electrodes = [25 27 62 64]; % PO7 O1 O2 PO8


%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'on';

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
        data = smooth(data,smoothfactor,'moving'); 
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


NSWSymmetry = SymmetryMemory-SymmetryPassive;
NSWRandom =RandomMemory-RandomPassive;




close all
%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 0 1],[0 1 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomMemory,SymmetryMemory,RandomPassive,SymmetryPassive],'LineWidth',LineWidth);
axis([-200 2000 -5 8]);
set(gca,'YTick',-4:2:8);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Memory(RandomProbe)','Memory(SymmetryProbe)','Passive(RandomProbe)','ColorPassive(SymmetryProbe)'},'FontSize',18,'Location','northwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffSymmetryMemory,DiffSymmetryPassive,Zeroline],'LineWidth',LineWidth);
axis([-200 2000 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'SymmetryProbe-RandomProbe(Memory)','SymmetryProbe-RandomProbe(Passive)'},'FontSize',18,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')

%FIGURE 3
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 1],[0.5 0 0.5],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [NSWRandom,NSWSymmetry,Zeroline],'LineWidth',LineWidth);
axis([-200 2000 -5 5]);
set(gca,'YTick',-5:1:5);
set(gca,'XTick',0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Memory-Passive(RandomProbe)','Memory-Passive(SymmetryProbe)'},'FontSize',18,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('NSW amplitude (microvolts)');
grid('on')
legend('boxoff')
