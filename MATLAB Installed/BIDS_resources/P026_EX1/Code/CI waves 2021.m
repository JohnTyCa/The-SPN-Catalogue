close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 26/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'SymmAlc','RandAlc','SymmPla','RandPla'}; 

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
SymmAlc=selectedData.SymmAlc.data;
RandAlc=selectedData.RandAlc.data;
SymmPla= selectedData.SymmPla.data;
RandPla=selectedData.RandPla.data;

Zeroline = zeros(length(timeVector),1);



SymmAlcIndividuals =  ERPerror.SymmAlc.amplitudes;
RandAlcIndividuals =  ERPerror.RandAlc.amplitudes;
SymmPlaIndividuals  = ERPerror.SymmPla.amplitudes;
RandPlaIndividuals =  ERPerror.RandPla.amplitudes;

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandAlc, SymmAlc],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandAlcIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmAlcIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandPla, SymmPla],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandPlaIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmPlaIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')











%FIGURE 2
close all
DiffAlc = SymmAlc-RandAlc;
DiffPla = SymmPla-RandPla;

lowEarly = 200
highEarly = 400
ii = find(timeVector >=lowEarly & timeVector <=highEarly);
MSPNAlcEarly = mean(DiffAlc(ii));
MSPNPlaEarly = mean(DiffPla(ii));



lowLate = 400
highLate = 1000
ii = find(timeVector >=lowLate & timeVector <=highLate);
MSPNAlcLate = mean(DiffAlc(ii));
MSPNPlaLate = mean(DiffPla(ii));

MSPNAlc = (MSPNAlcEarly +MSPNAlcLate)/2
MSPNPla =(MSPNPlaEarly +MSPNPlaLate)/2


SPNcheck = [MSPNAlc,MSPNPla];
save('SPNcheck','SPNcheck');

CIAlcSPN = ERPerror.AlcSPN.CI;
CIPlaSPN = ERPerror.PlaSPN.CI;


if strcmp(smoothOn, 'on') == 1;
    CIAlcSPN = smooth(CIAlcSPN,smoothfactor,'moving');
    CIPlaSPN = smooth(CIPlaSPN,smoothfactor,'moving');
    
end

PosCIAlcSPN=DiffAlc+CIAlcSPN;
PosCIPlaSPN=DiffPla+CIPlaSPN;


NegCIAlcSPN=DiffAlc-CIAlcSPN;
NegCIPlaSPN=DiffPla-CIPlaSPN;



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIAlcSPN',fliplr(PosCIAlcSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffAlc,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNAlc,themeCol,'LineWidth',LineWidth);
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
patch([timeVector,fliplr(timeVector)],[NegCIPlaSPN',fliplr(PosCIPlaSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffPla,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNPla,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

