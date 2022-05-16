close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 36/Grand Averages';
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS
conditionNames = {'RefFirst','RefSecond','RefThird','RandFirst','RandSecond','RandThird'};
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
RefFirst= selectedData.RefFirst.data;
RefSecond = selectedData.RefSecond.data;
RefThird = selectedData.RefThird.data;

RandFirst = selectedData.RandFirst.data;
RandSecond = selectedData.RandSecond.data;
RandThird = selectedData.RandThird.data;

Zeroline = zeros(length(timeVector),1);

RefFirstIndividuals = ERPerror.RefFirst.amplitudes;
RefSecondIndividuals = ERPerror.RefSecond.amplitudes;
RefThirdIndividuals = ERPerror.RefThird.amplitudes;
RandFirstIndividuals = ERPerror.RandFirst.amplitudes;
RandSecondIndividuals = ERPerror.RandSecond.amplitudes;
RandThirdIndividuals = ERPerror.RandThird.amplitudes;

%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFirst,RefFirst],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandFirstIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RefFirstIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% uistack(P,'top')
% legend('off')


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandSecond,RefSecond],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandSecondIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RefSecondIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% uistack(P,'top')
% legend('off')


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandThird,RefThird],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandThirdIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RefThirdIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% uistack(P,'top')
% legend('off')



%FIGURE 2
close all
DiffFirst= RefFirst - RandFirst;
DiffSecond= RefSecond - RandSecond;
DiffThird= RefThird- RandThird;


low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);

MSPNFirst =mean(DiffFirst(ii));
MSPNSecond =mean(DiffSecond(ii));
MSPNThird =mean(DiffThird(ii));

SPNcheck = [MSPNFirst,MSPNSecond,MSPNThird];
save('SPNcheck','SPNcheck');

CISPNFirst = ERPerror.SPNFirst.CI;
CISPNSecond = ERPerror.SPNSecond.CI;
CISPNThird = ERPerror.SPNThird.CI;

if strcmp(smoothOn, 'on') == 1;
    CISPNFirst = smooth(CISPNFirst,smoothfactor,'moving');
    CISPNSecond = smooth(CISPNSecond,smoothfactor,'moving');
    CISPNThird = smooth(CISPNThird,smoothfactor,'moving');
end

PosCISPNFirst= DiffFirst+CISPNFirst;
NegCISPNFirst= DiffFirst-CISPNFirst;
PosCISPNSecond= DiffSecond+CISPNSecond;
NegCISPNSecond= DiffSecond-CISPNSecond;
PosCISPNThird= DiffThird+CISPNThird;
NegCISPNThird= DiffThird-CISPNThird;


figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNFirst',fliplr(PosCISPNFirst')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFirst,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFirst,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
alpha(0.4);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')

figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNSecond',fliplr(PosCISPNSecond')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSecond,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSecond,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
alpha(0.4);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')

figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNThird',fliplr(PosCISPNThird')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffThird,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNThird,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
alpha(0.4);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')



