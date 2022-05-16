close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX1 Crowding HV/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerrorLeftBrain

%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'off';

%GRAPHICAL PROPERTIES
FontSize = 20;
LineWidth = 2;
set(0,'DefaultAxesFontSize', FontSize);



%CONDITIONS
conditionNames={'TargetSymL','TargetRandL','SymFlankerVL','RandFlankerVL','SymFlankerHL','RandFlankerHL','TargetSymR','TargetRandR','SymFlankerVR','RandFlankerVR','SymFlankerHR','RandFlankerHR'};

hemisphere= input('which hemisphere?');
if strcmp(hemisphere, 'left') == 1 % SPNs in left hem
    load ERPerrorLeftBrain;
    electrodes = [23 24 25 27];
end

if strcmp(hemisphere, 'right') == 1 % SPNs in right hem
    load ERPerrorRightBrain;
    electrodes = [60 61 62 64]; 
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

TargetSymL= selectedData.TargetSymL.data;
TargetRandL = selectedData.TargetRandL.data;
SymFlankerHL= selectedData.SymFlankerHL.data;
SymFlankerVL = selectedData.SymFlankerVL.data;
RandFlankerHL= selectedData.RandFlankerHL.data;
RandFlankerVL = selectedData.RandFlankerVL.data;


TargetSymR= selectedData.TargetSymR.data;
TargetRandR = selectedData.TargetRandR.data;
SymFlankerHR= selectedData.SymFlankerHR.data;
SymFlankerVR = selectedData.SymFlankerVR.data;
RandFlankerHR= selectedData.RandFlankerHR.data;
RandFlankerVR = selectedData.RandFlankerVR.data;
Zeroline = zeros(length(timeVector),1);


%Figure1 % for right brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [TargetRandL,TargetSymL],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'TargetRandL','TargetSymL'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, TargetRandLIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,TargetSymLIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure1 % for right brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerVL,SymFlankerVL],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandFlankerVL','SymFlankerVL'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerVLIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlankerVLIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure1 % for right brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerHL,SymFlankerHL],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandFlankerHL','SymFlankerHL'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerHLIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlankerHLIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

close all
%Figure1 % for left brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [TargetRandR,TargetSymR],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'TargetRandR','TargetSymR'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, TargetRandRIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,TargetSymRIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure1 % for left brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerVR,SymFlankerVR],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandFlankerVR','SymFlankerVR'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerVRIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlankerVRIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure1 % for left brain contralateral SPNS
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerHR,SymFlankerHR],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandFlankerHR','SymFlankerHR'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerHRIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlankerHRIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')














%FIGURE 2


DiffTargetL = TargetSymL-TargetRandL;
DiffFlankerHL = SymFlankerHL-RandFlankerHL;
DiffFlankerVL = SymFlankerVL-RandFlankerVL;


DiffTargetR = TargetSymR-TargetRandR;
DiffFlankerHR = SymFlankerHR-RandFlankerHR;
DiffFlankerVR = SymFlankerVR-RandFlankerVR;




low = 200
high = 600
ii = find(timeVector >=low & timeVector <=high);
MSPNTargetL = mean(DiffTargetL(ii));
MSPNFlankerHL = mean(DiffFlankerHL(ii));
MSPNFlankerVL = mean(DiffFlankerVL(ii));
MSPNTargetR = mean(DiffTargetR(ii));
MSPNFlankerHR = mean(DiffFlankerHR(ii));
MSPNFlankerVR = mean(DiffFlankerVR(ii));


if strcmp(hemisphere, 'left') == 1 % SPNs in left hem
    SPNcheckLeft = [MSPNTargetR,MSPNFlankerVR,MSPNFlankerHR];
    save('SPNcheckLeft','SPNcheckLeft');
    
end
if strcmp(hemisphere, 'right') == 1 % SPNs in left hem
    SPNcheckRight = [MSPNTargetL,MSPNFlankerVL,MSPNFlankerHL];
    save('SPNcheckRight','SPNcheckRight');
    
end
CITargetLSPN = ERPerror.TargetLSPN.CI;
CIFlankerHLSPN = ERPerror.FlankerHLSPN.CI;
CIFlankerVLSPN = ERPerror.FlankerVLSPN.CI;
CITargetRSPN = ERPerror.TargetRSPN.CI;
CIFlankerHRSPN = ERPerror.FlankerHRSPN.CI;
CIFlankerVRSPN = ERPerror.FlankerVRSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CITargetLSPN = smooth(CICITargetLSPN,smoothfactor,'moving');
    CIFlankerHLSPN = smooth(CIFlankerHLSPN,smoothfactor,'moving');
    CIFlankerVLSPN = smooth(CIFlankerVLSPN,smoothfactor,'moving');
    CITargetRSPN = smooth(CICITargetRSPN,smoothfactor,'moving');
    CIFlankerHRSPN = smooth(CIFlankerHRSPN,smoothfactor,'moving');
    CIFlankerVRSPN = smooth(CIFlankerVRSPN,smoothfactor,'moving'); 
end

PosCITargetLSPN= DiffTargetL+CITargetLSPN;
PosCIFlankerHLSPN= DiffFlankerHL+CIFlankerHLSPN;
PosCIFlankerVLSPN= DiffFlankerVL+CIFlankerVLSPN;
PosCITargetRSPN= DiffTargetR+CITargetRSPN;
PosCIFlankerHRSPN= DiffFlankerHR+CIFlankerHRSPN;
PosCIFlankerVRSPN= DiffFlankerVR+CIFlankerVRSPN;


NegCITargetLSPN= DiffTargetL-CITargetLSPN;
NegCIFlankerHLSPN= DiffFlankerHL-CIFlankerHLSPN;
NegCIFlankerVLSPN= DiffFlankerVL-CIFlankerVLSPN;
NegCITargetRSPN= DiffTargetR-CITargetRSPN;
NegCIFlankerHRSPN= DiffFlankerHR-CIFlankerHRSPN;
NegCIFlankerVRSPN= DiffFlankerVR-CIFlankerVRSPN;
% for right brain contralateral SPNs 
close all
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCITargetLSPN',fliplr(PosCITargetLSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTargetL,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTargetL,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIFlankerVLSPN',fliplr(PosCIFlankerVLSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFlankerVL,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFlankerVL,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIFlankerHLSPN',fliplr(PosCIFlankerHLSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFlankerHL,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFlankerHL,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)





% for left brain contralateral SPNs 
close all
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCITargetRSPN',fliplr(PosCITargetRSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTargetR,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTargetR,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIFlankerVRSPN',fliplr(PosCIFlankerVRSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFlankerVR,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFlankerVR,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIFlankerHRSPN',fliplr(PosCIFlankerHRSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFlankerHR,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFlankerHR,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

