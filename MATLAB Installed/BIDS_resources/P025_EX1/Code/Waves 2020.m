close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX1 Color and Shape/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};


%ELECTRODES
electrodes = [25 27 62 64]; % PO7 O1 O2 PO8


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
        data = smooth(data,smoothfactor,'moving'); 
    end
    selectedData.(c).data = data;
end

%save('thisPlot','data');

SymmetryColorMem=selectedData.SymmetryColorMem.data;
RandomColorMem=selectedData.RandomColorMem.data;
SymmetryColorPassive= selectedData.SymmetryColorPassive.data;
RandomColorPassive=selectedData.RandomColorPassive.data;
SymmetryShapeMem=selectedData.SymmetryShapeMem.data;
RandomShapeMem=selectedData.RandomShapeMem.data;
SymmetryShapePassive= selectedData.SymmetryShapePassive.data;
RandomShapePassive=selectedData.RandomShapePassive.data;
DiffSymmetryColorMem = SymmetryColorMem-RandomColorMem;
DiffSymmetryColorPassive = SymmetryColorPassive-RandomColorPassive;
DiffSymmetryShapeMem = SymmetryShapeMem-RandomShapeMem;
DiffSymmetryShapePassive = SymmetryShapePassive-RandomShapePassive;
Zeroline = zeros(length(timeVector),1);

%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 0 1],[0 1 0],[0.5 0.5 0.5],[0.5 0 0],[0 0 0.5],[0 0.5 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomColorMem,SymmetryColorMem,RandomColorPassive,SymmetryColorPassive,RandomShapeMem,SymmetryShapeMem,RandomShapePassive,SymmetryShapePassive],'LineWidth',LineWidth);
axis([-200 750 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',0:250:750,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandomColorMemory','SymmetryColorMemory','RandomColorPassive','SymmetryColorPassive','RandomColorMemory','SymmetryShapeMemory','RandomShapePassive','SymmetryShapePassive'},'FontSize',12,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')



%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0.5 0 0],[0 0.5 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffSymmetryColorMem,DiffSymmetryColorPassive,DiffSymmetryShapeMem,DiffSymmetryShapePassive,Zeroline],'LineWidth',LineWidth);
axis([-200 750 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',0:250:750,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'SymmetryColorMemory','SymmetryColorPassive','SymmetryShapeMemory','SymmetryShapePassive'},'FontSize',12,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')



clear
