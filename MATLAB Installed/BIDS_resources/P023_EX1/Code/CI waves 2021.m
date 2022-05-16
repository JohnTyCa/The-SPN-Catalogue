close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 23/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'AntiSymmBW','SymmBW','RandBW','AntiSymmCol','SymmCol','RandCol'};

%ELECTRODES
electrodes = [25 62];

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

AntiSymmBW=selectedData.AntiSymmBW.data;
SymmBW=selectedData.SymmBW.data;
RandBW= selectedData.RandBW.data;
AntiSymmCol=selectedData.AntiSymmCol.data;
SymmCol=selectedData.SymmCol.data;
RandCol= selectedData.RandCol.data;
DiffAntiSymmBW = AntiSymmBW-RandBW;
DiffSymmBW = SymmBW-RandBW;
DiffAntiSymmCol = AntiSymmCol-RandCol;
DiffSymmCol = SymmCol-RandCol;
Zeroline = zeros(length(timeVector),1);



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandBW, AntiSymmBW],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandBW','AntiSymmBW'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandBWIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,AntiSymmBWIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandBW, SymmBW],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandBW','SymmBW'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandBWIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmBWIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandCol, AntiSymmCol],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandCol','AntiSymmCol'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandColIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,AntiSymmColIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandCol, SymmCol],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandCol','SymmCol'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandColIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymmColIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

















%FIGURE 2
low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNAntiSymmBW = mean(DiffAntiSymmBW(ii));
MSPNSymmBW = mean(DiffSymmBW(ii));
MSPNAntiSymmCol = mean(DiffAntiSymmCol(ii));
MSPNSymmCol = mean(DiffSymmCol(ii));


SPNcheck = [MSPNAntiSymmBW,MSPNSymmBW,MSPNAntiSymmCol,MSPNSymmCol];
save('SPNcheck','SPNcheck');

CIAntiSymmBWSPN = ERPerror.AntiSymmBWSPN.CI;
CISymmBWSPN = ERPerror.SymmBWSPN.CI;
CIAntiSymmColSPN = ERPerror.AntiSymmColSPN.CI;
CISymmColSPN = ERPerror.SymmColSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIAntiSymmBWSPN = smooth(CIAntiSymmBWSPN,smoothfactor,'moving');
    CISymmBWSPN = smooth(CISymmBWSPN,smoothfactor,'moving');
    CIAntiSymmColSPN = smooth(CIAntiSymmColSPN,smoothfactor,'moving');
    CISymmColSPN = smooth(CISymmColSPN,smoothfactor,'moving');
end

PosCIAntiSymmBWSPN= DiffAntiSymmBW+CIAntiSymmBWSPN;
PosCISymmBWSPN= DiffSymmBW+CISymmBWSPN;
PosCIAntiSymmColSPN= DiffAntiSymmCol+CIAntiSymmColSPN;
PosCISymmColSPN= DiffSymmCol+CISymmColSPN;

NegCIAntiSymmBWSPN= DiffAntiSymmBW-CIAntiSymmBWSPN;
NegCISymmBWSPN= DiffSymmBW-CISymmBWSPN;
NegCIAntiSymmColSPN= DiffAntiSymmCol-CIAntiSymmColSPN;
NegCISymmColSPN= DiffSymmCol-CISymmColSPN;



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIAntiSymmBWSPN',fliplr(PosCIAntiSymmBWSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffAntiSymmBW,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNAntiSymmBW,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISymmBWSPN',fliplr(PosCISymmBWSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSymmBW,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSymmBW,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)




figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIAntiSymmColSPN',fliplr(PosCIAntiSymmColSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffAntiSymmCol,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNAntiSymmCol,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)




figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISymmColSPN',fliplr(PosCISymmColSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSymmCol,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSymmCol,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
