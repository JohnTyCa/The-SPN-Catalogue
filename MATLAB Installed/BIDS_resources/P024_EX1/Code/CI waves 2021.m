close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 24/Grand Averages'
load timeVector;
load grandAverages; 


%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'off';

%GRAPHICAL PROPERTIES
FontSize = 20;
LineWidth = 2;
set(0,'DefaultAxesFontSize', FontSize);



%CONDITIONS
conditionNames={'LCRandRand','RCRandRand','LCRandSymm','RCRandSymm','LCSymmRand','RCSymmRand'};

hemisphere= input('which hemisphere?');
if strcmp(hemisphere, 'left') == 1 % SPNs in left hem
    load ERPerrorLeftBrain;
    electrodes = [23 25 26 27]; %P7 PO3 PO7 O1 left electrodes
end

if strcmp(hemisphere, 'right') == 1 % SPNs in right hem
    load ERPerrorRightBrain;
    electrodes = [60 62 63 64]; %P8 PO4 PO8 O2 right electrodes
end


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


LCRandRand=selectedData.LCRandRand.data;
LCRandSymm= selectedData.LCRandSymm.data;
LCSymmRand= selectedData.LCSymmRand.data;

RCRandRand=selectedData.RCRandRand.data;
RCRandSymm=selectedData.RCRandSymm.data;
RCSymmRand=selectedData.RCSymmRand.data;
Zeroline = zeros(length(timeVector),1);




LCRandRandIndividuals = ERPerror.LCRandRand.amplitudes;
LCRandSymmIndividuals = ERPerror.LCRandSymm.amplitudes;
LCSymmRandIndividuals = ERPerror.LCSymmRand.amplitudes;

RCRandRandIndividuals = ERPerror.RCRandRand.amplitudes;
RCRandSymmIndividuals = ERPerror.RCRandSymm.amplitudes;
RCSymmRandIndividuals = ERPerror.RCSymmRand.amplitudes;


%Figure1 % for left brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [LCRandRand,LCRandSymm],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand < Rand','Rand < Symm'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, LCRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,LCRandSymmIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure1 % for left brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RCRandRand,RCRandSymm],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand > Rand','Rand > Symm'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RCRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RCRandSymmIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')












%Figure1 % for right brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [LCRandRand,LCSymmRand],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand < Rand','Symm < Rand'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, LCRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,LCSymmRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure1 % for right brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RCRandRand,RCSymmRand],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand > Rand','Symm > Rand'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RCRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RCSymmRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%FIGURE 2


DiffLCRandSymm = LCRandSymm-LCRandRand;
DiffLCSymmRand = LCSymmRand-LCRandRand;
DiffRCRandSymm = RCRandSymm-RCRandRand;
DiffRCSymmRand = RCSymmRand-RCRandRand;


lowEarly = 250
highEarly = 350
ii = find(timeVector >=lowEarly & timeVector <=highEarly);
MSPNLCRandSymmEarly = mean(DiffLCRandSymm(ii));
MSPNLCSymmRandEarly = mean(DiffLCSymmRand(ii));
MSPNRCRandSymmEarly = mean(DiffRCRandSymm(ii));
MSPNRCSymmRandEarly = mean(DiffRCSymmRand(ii));

lowLate = 500
highLate = 1000
ii = find(timeVector >=lowLate & timeVector <=highLate);
MSPNLCRandSymmLate = mean(DiffLCRandSymm(ii));
MSPNLCSymmRandLate = mean(DiffLCSymmRand(ii));
MSPNRCRandSymmLate = mean(DiffRCRandSymm(ii));
MSPNRCSymmRandLate = mean(DiffRCSymmRand(ii));

MSPNLCRandSymm = (MSPNLCRandSymmEarly+MSPNLCRandSymmLate)/2; % This project was unusual because there were two windows
MSPNLCSymmRand= (MSPNLCSymmRandEarly+MSPNLCSymmRandLate)/2;
MSPNRCRandSymm = (MSPNRCRandSymmEarly+MSPNRCRandSymmLate)/2;
MSPNRCSymmRand= (MSPNRCSymmRandEarly+MSPNRCSymmRandLate)/2;

%SPNcheck = [MSPNLCRandSymm,MSPNLCSymmRand,MSPNRCRandSymm,MSPNRCSymmRand];
%save('SPNcheck','SPNcheck');

if strcmp(hemisphere, 'left') == 1 % SPNs in left hem
    SPNcheckLeft = [MSPNLCRandSymm,MSPNRCRandSymm]
    save('SPNcheckLeft','SPNcheckLeft')
end

if strcmp(hemisphere, 'right') == 1 % SPNs in left hem
    SPNcheckRight = [MSPNLCSymmRand,MSPNRCSymmRand]
    save('SPNcheckRight','SPNcheckRight')
    
end

CILCRandSymmSPN = ERPerror.LCRandSymmSPN.CI;
CILCSymmRandSPN = ERPerror.LCSymmRandSPN.CI;
CIRCRandSymmSPN = ERPerror.RCRandSymmSPN.CI;
CIRCSymmRandSPN = ERPerror.RCSymmRandSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CILCRandSymmSPN = smooth(CILCRandSymmSPN,smoothfactor,'moving');
    CILCSymmRandSPN = smooth(CILCSymmRandSPN,smoothfactor,'moving');
    CIRCRandSymmSPN = smooth(CIRCRandSymmSPN,smoothfactor,'moving');
    CIRCSymmRandSPN = smooth(CIRCSymmRandSPN,smoothfactor,'moving');
end

PosCILCRandSymmSPN= DiffLCRandSymm+CILCRandSymmSPN;
PosCILCSymmRandSPN= DiffLCSymmRand+CILCSymmRandSPN;
PosCIRCRandSymmSPN= DiffRCRandSymm+CIRCRandSymmSPN;
PosCIRCSymmRandSPN= DiffRCSymmRand+CIRCSymmRandSPN;

NegCILCRandSymmSPN= DiffLCRandSymm-CILCRandSymmSPN;
NegCILCSymmRandSPN= DiffLCSymmRand-CILCSymmRandSPN;
NegCIRCRandSymmSPN= DiffRCRandSymm-CIRCRandSymmSPN;
NegCIRCSymmRandSPN= DiffRCSymmRand-CIRCSymmRandSPN;

close all
% left hem contra SPN 155
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCILCRandSymmSPN',fliplr(PosCILCRandSymmSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffLCRandSymm,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNLCRandSymm,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

% left hem contra SPN
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRCRandSymmSPN',fliplr(PosCIRCRandSymmSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRCRandSymm,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRCRandSymm,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


% right hem contra SPN
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCILCSymmRandSPN',fliplr(PosCILCSymmRandSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffLCSymmRand,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNLCSymmRand,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

% right hem contra SPN
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRCSymmRandSPN',fliplr(PosCIRCSymmRandSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRCSymmRand,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRCSymmRand,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)