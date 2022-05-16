close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX1 Color and Shape/Grand Averages'
load timeVectorSamplePlusProbe;
load grandAveragesSamplePlusProbe
%CONDITIONS
conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};


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

NSWSymmetryColor = SymmetryColorMem-SymmetryColorPassive;
NSWRandomColor =RandomColorMem-RandomColorPassive;

NSWSymmetryShape = SymmetryShapeMem-SymmetryShapePassive;
NSWRandomShape =RandomShapeMem-RandomShapePassive;
Zeroline = zeros(length(timeVector),1);




close all
%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 0 1],[0 1 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomColorMem,SymmetryColorMem,RandomColorPassive,SymmetryColorPassive],'LineWidth',LineWidth);
axis([-200 2000 -5 8]);
set(gca,'YTick',-4:2:8);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'ColourMemory(RandomProbe)','ColourMemory(SymmetryProbe)','ColourPassive(RandomProbe)','ColourPassive(SymmetryProbe)'},'FontSize',18,'Location','northwest');
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
P = plot(timeVector, [DiffSymmetryColorMem,DiffSymmetryColorPassive,Zeroline],'LineWidth',LineWidth);
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
P = plot(timeVector, [NSWRandomColor,NSWSymmetryColor,Zeroline],'LineWidth',LineWidth);
axis([-200 2000 -5 5]);
set(gca,'YTick',-5:1:5);
set(gca,'XTick',0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'ColourMemory-ColourPassive(RandomProbe)','ColourMemory-ColourPassive(SymmetryProbe)'},'FontSize',18,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('NSW amplitude (microvolts)');
grid('on')
legend('boxoff')



%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 0 1],[0 1 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomShapeMem,SymmetryShapeMem,RandomShapePassive,SymmetryShapePassive],'LineWidth',LineWidth);
axis([-200 2000 -5 8]);
set(gca,'YTick',-4:2:8);
set(gca,'XTick',0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'ShapeMemory(RandomProbe)','ShapeMemory(SymmetryProbe)','ShapePassive(RandomProbe)','ShapePassive(SymmetryProbe)'},'FontSize',18,'Location','northwest');
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
P = plot(timeVector, [DiffSymmetryShapeMem,DiffSymmetryShapePassive,Zeroline],'LineWidth',LineWidth);
axis([-200 2000 -4 1]);
set(gca,'YTick',-4:1:1);
set(gca,'XTick',0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)

legend({'SymmetryProbe-RandomProbe(Memory)','SymmetryProbe-RandomProbe(Passive)'},'FontSize',18,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')

%Figure 3
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 1],[0.5 0 0.5],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [NSWRandomShape,NSWSymmetryShape,Zeroline],'LineWidth',LineWidth);
axis([-200 2000 -5 5]);
set(gca,'YTick',-5:1:5);
set(gca,'XTick',0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'ShapeMemory-ShapePassive(RandomProbe)','ShapeMemory-ShapePassive(SymmetryProbe)'},'FontSize',18,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('NSW amplitude (microvolts)');
grid('on')
legend('boxoff')