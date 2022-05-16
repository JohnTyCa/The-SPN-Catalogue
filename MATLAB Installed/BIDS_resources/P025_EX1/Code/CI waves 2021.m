close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 25/EX1 Color and Shape/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};


%ELECTRODES
electrodes = [25 27 62 64]; % PO7 O1 O2 PO8

%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'off';

%GRAPHICAL PROPERTIES
FontSize = 20;
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

%save('thisPlot','selectedData');

%use this to plot ERPs

SymmetryColorMem=selectedData.SymmetryColorMem.data;
RandomColorMem=selectedData.RandomColorMem.data;
SymmetryColorPassive= selectedData.SymmetryColorPassive.data;
RandomColorPassive=selectedData.RandomColorPassive.data;
SymmetryShapeMem=selectedData.SymmetryShapeMem.data;
RandomShapeMem=selectedData.RandomShapeMem.data;
SymmetryShapePassive= selectedData.SymmetryShapePassive.data;
RandomShapePassive=selectedData.RandomShapePassive.data;

Zeroline = zeros(length(timeVector),1);

SymmetryColorMemIndividuals =  ERPerror.SymmetryShapeMem.amplitudes;
RandomColorMemIndividuals =  ERPerror.RandomShapeMem.amplitudes;
SymmetryShapeMemIndividuals  = ERPerror.SymmetryShapeMem.amplitudes;
RandomShapeMemIndividuals =  ERPerror.RandomShapeMem.amplitudes;

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomColorMem, SymmetryColorMem],'LineWidth',LineWidth);
axis([-200 750 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:250:750);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandomColorMemIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmetryColorMemIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomColorPassive, SymmetryColorPassive],'LineWidth',LineWidth);
axis([-200 750 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:250:750);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandomColorPassiveIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmetryColorPassiveIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomShapeMem, SymmetryShapeMem],'LineWidth',LineWidth);
axis([-200 750 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:250:750);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandomShapeMemIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmetryShapeMemIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomShapePassive, SymmetryShapePassive],'LineWidth',LineWidth);
axis([-200 750 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:250:750);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandomShapePassiveIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmetryShapePassiveIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

















%FIGURE 2
close all
DiffColorMem = SymmetryColorMem-RandomColorMem;
DiffColorPassive = SymmetryColorPassive-RandomColorPassive;
DiffShapeMem = SymmetryShapeMem-RandomShapeMem;
DiffShapePassive = SymmetryShapePassive-RandomShapePassive;

lowEarly = 250
highEarly = 450
ii = find(timeVector >=lowEarly & timeVector <=highEarly);
MSPNColorMemEarly = mean(DiffColorMem(ii));
MSPNColorPassiveEarly = mean(DiffColorPassive(ii));
MSPNShapeMemEarly = mean(DiffShapeMem(ii));
MSPNShapePassiveEarly = mean(DiffShapePassive(ii));



lowLate = 450
highLate = 750
ii = find(timeVector >=lowLate & timeVector <=highLate);
MSPNColorMemLate = mean(DiffColorMem(ii));
MSPNColorPassiveLate = mean(DiffColorPassive(ii));
MSPNShapeMemLate = mean(DiffShapeMem(ii));
MSPNShapePassiveLate = mean(DiffShapePassive(ii));

MSPNColorMem = (MSPNColorMemEarly +MSPNColorMemLate)/2
MSPNColorPassive =(MSPNColorPassiveEarly +MSPNColorPassiveLate)/2
MSPNShapeMem=(MSPNShapeMemEarly +MSPNShapeMemLate)/2
MSPNShapePassive=(MSPNShapePassiveEarly +MSPNShapePassiveLate)/2

SPNcheck = [MSPNColorMem,MSPNColorPassive,MSPNShapeMem,MSPNShapePassive];
save('SPNcheck','SPNcheck');

CIColorMemSPN = ERPerror.ColorMemSPN.CI;
CIColorPassiveSPN = ERPerror.ColorPassiveSPN.CI;
CIShapeMemSPN = ERPerror.ShapeMemSPN.CI;
CIShapePassiveSPN = ERPerror.ShapePassiveSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIColorMemSPN = smooth(CIColorMemSPN,smoothfactor,'moving');
    CIColorPassiveSPN = smooth(CIColorPassiveSPN,smoothfactor,'moving');
    CIShapeMemSPN = smooth(CIShapeMemSPN,smoothfactor,'moving');
    CIShapePassiveSPN = smooth(CIShapePassiveSPN,smoothfactor,'moving');
end

PosCIColorMemSPN= DiffColorMem+CIColorMemSPN;
PosCIColorPassiveSPN= DiffColorPassive+CIColorPassiveSPN;
PosCIShapeMemSPN= DiffShapeMem+CIShapeMemSPN;
PosCIShapePassiveSPN= DiffShapePassive+CIShapePassiveSPN;

NegCIColorMemSPN= DiffColorMem-CIColorMemSPN;
NegCIColorPassiveSPN= DiffColorPassive-CIColorPassiveSPN;
NegCIShapeMemSPN= DiffShapeMem-CIShapeMemSPN;
NegCIShapePassiveSPN= DiffShapePassive-CIShapePassiveSPN;



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIColorMemSPN',fliplr(PosCIColorMemSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffColorMem,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 750 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:250:750,'XMinorTick','on');
yline(MSPNColorMem,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIColorPassiveSPN',fliplr(PosCIColorPassiveSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffColorPassive,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 750 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:250:750,'XMinorTick','on');
yline(MSPNColorPassive,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIShapeMemSPN',fliplr(PosCIShapeMemSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffShapeMem,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 750 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:250:750,'XMinorTick','on');
yline(MSPNShapeMem,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIShapePassiveSPN',fliplr(PosCIShapePassiveSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffShapePassive,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 750 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:250:750,'XMinorTick','on');
yline(MSPNShapePassive,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)