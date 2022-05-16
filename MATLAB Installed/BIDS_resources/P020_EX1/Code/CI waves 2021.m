close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 20/Grand Averages';
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS

conditionNames={'RandRandRand','RandsBlack','RandsWhite','RandsBWB','RandsWBW','RefsBlack','RefsWhite','RefsBWB','RefsWBW','RandsConsistent','RandsChanging','RefsConsistent','RefsChanging'};


%ELECTRODES
electrodes = [25 27 62 64]; 

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

RandRandRand= selectedData.RandRandRand.data;
RefsConsistent = selectedData.RefsConsistent.data;
RefsChanging = selectedData.RefsChanging.data;
RandsConsistent = selectedData.RandsConsistent.data;
RandsChanging = selectedData.RandsChanging.data;
RandsBlack = selectedData.RandsBlack.data;
RandsWhite = selectedData.RandsWhite.data;
RefsBlack = selectedData.RefsBlack.data;
RefsWhite = selectedData.RefsWhite.data;
RandsBWB = selectedData.RandsBWB.data;
RandsWBW = selectedData.RandsWBW.data;
RefsBWB = selectedData.RefsBWB.data;
RefsWBW = selectedData.RefsWBW.data;




DiffConsistent = RefsConsistent-RandsConsistent;
DiffChanging = RefsChanging-RandsChanging;

DiffBlack = RefsBlack-RandsBlack;
DiffWhite = RefsWhite-RandsWhite;
DiffWBW = RefsWBW - RandsWBW;
DiffBWB = RefsBWB - RandsBWB;
Zeroline = zeros(length(timeVector),1);


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandsBlack, RefsBlack],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandsBlack','RefsBlack'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandsBlackIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RefsBlackIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandsWhite, RefsWhite],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandsWhite','RefsWhite'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandsWhiteIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RefsWhiteIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')





%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandsBWB, RefsBWB],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandsBWB','RefsBWB'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

 
% plot(timeVector, RandsBWBIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RefsBWBIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandsWBW, RefsWBW],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandsWBW','RefsWBW'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandsWBWIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RefsWBWIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%FIGURE 2
low = 250
high = 600
ii = find(timeVector >=low & timeVector <=high);
MSPNBlack = mean(DiffBlack(ii));
MSPNWhite = mean(DiffWhite(ii));
MSPNWBW = mean(DiffWBW(ii));
MSPNBWB = mean(DiffBWB(ii));

SPNcheck = [MSPNBlack,MSPNWhite,MSPNBWB,MSPNWBW];
save('SPNcheck','SPNcheck');

CIBlackSPN = ERPerror.BlackSPN.CI;
CIWhiteSPN = ERPerror.WhiteSPN.CI;
CIBWBSPN = ERPerror.BWBSPN.CI;
CIWBWSPN = ERPerror.WBWSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIBlackSPN = smooth(CIBlackSPN,smoothfactor,'moving');
    CIWhiteSPN = smooth(CIWhiteSPN,smoothfactor,'moving');
    CIBWBSPN = smooth(CIBWBSPN,smoothfactor,'moving');
    CIWBWSPN = smooth(CIWBWSPN,smoothfactor,'moving');
end

PosCIBlackSPN= DiffBlack+CIBlackSPN;
PosCIWhiteSPN= DiffWhite+CIWhiteSPN;
PosCIWBWSPN= DiffWBW+CIWBWSPN;
PosCIBWBSPN= DiffBWB+CIBWBSPN;

NegCIBlackSPN= DiffBlack-CIBlackSPN;
NegCIWhiteSPN= DiffWhite-CIWhiteSPN;
NegCIWBWSPN= DiffWBW-CIWBWSPN;
NegCIBWBSPN= DiffBWB-CIBWBSPN;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIBlackSPN',fliplr(PosCIBlackSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffBlack,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNBlack,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIWhiteSPN',fliplr(PosCIWhiteSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffWhite,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNWhite,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIBWBSPN',fliplr(PosCIBWBSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffBWB,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNBWB,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIWBWSPN',fliplr(PosCIWBWSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffWBW,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNWBW,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



