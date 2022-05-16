close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 25/EX2 Symm probe Symm/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'SymmetryMemory','RandomMemory','SymmetryPassive','RandomPassive'};

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


SymmetryMemory=selectedData.SymmetryMemory.data;
RandomMemory=selectedData.RandomMemory.data;
SymmetryPassive= selectedData.SymmetryPassive.data;
RandomPassive=selectedData.RandomPassive.data;

Zeroline = zeros(length(timeVector),1);

SymmetryMemoryIndividuals =  ERPerror.SymmetryMemory.amplitudes;
RandomMemoryIndividuals =  ERPerror.RandomMemory.amplitudes;
SymmetryPassiveIndividuals  = ERPerror.SymmetryPassive.amplitudes;
RandomPassiveIndividuals =  ERPerror.RandomPassive.amplitudes;

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomMemory, SymmetryMemory],'LineWidth',LineWidth);
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
% plot(timeVector, RandomMemoryIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmetryMemoryIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomPassive, SymmetryPassive],'LineWidth',LineWidth);
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
% plot(timeVector, RandomPassiveIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmetryPassiveIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')
















%FIGURE 2

DiffMemory = SymmetryMemory-RandomMemory;
DiffPassive = SymmetryPassive-RandomPassive;

lowEarly = 250
highEarly = 450
ii = find(timeVector >=lowEarly & timeVector <=highEarly);
MSPNMemoryEarly = mean(DiffMemory(ii));
MSPNPassiveEarly = mean(DiffPassive(ii));




lowLate = 450
highLate = 750
ii = find(timeVector >=lowLate & timeVector <=highLate);
MSPNMemoryLate = mean(DiffMemory(ii));
MSPNPassiveLate = mean(DiffPassive(ii));


MSPNMemory = (MSPNMemoryEarly +MSPNMemoryLate)/2
MSPNPassive =(MSPNPassiveEarly +MSPNPassiveLate)/2


SPNcheck = [MSPNMemory,MSPNPassive];
save('SPNcheck','SPNcheck');

CIMemorySPN = ERPerror.MemorySPN.CI;
CIPassiveSPN = ERPerror.PassiveSPN.CI;


if strcmp(smoothOn, 'on') == 1;
    CIMemorySPN = smooth(CIMemorySPN,smoothfactor,'moving');
    CIPassiveSPN = smooth(CIPassiveSPN,smoothfactor,'moving');
    
end

PosCIMemorySPN= DiffMemory+CIMemorySPN;
PosCIPassiveSPN= DiffPassive+CIPassiveSPN;

NegCIMemorySPN= DiffMemory-CIMemorySPN;
NegCIPassiveSPN= DiffPassive-CIPassiveSPN;



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIMemorySPN',fliplr(PosCIMemorySPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffMemory,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 750 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:250:750,'XMinorTick','on');
yline(MSPNMemory,themeCol,'LineWidth',LineWidth);
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
patch([timeVector,fliplr(timeVector)],[NegCIPassiveSPN',fliplr(PosCIPassiveSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffPassive,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 750 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:250:750,'XMinorTick','on');
yline(MSPNPassive,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

