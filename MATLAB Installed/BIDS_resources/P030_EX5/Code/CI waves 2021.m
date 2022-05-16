close all
clear all

cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 30/EX5 Gerbino PNG1and3/Grand Averages';
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS



conditionNames = {'RandomConvex1','RandomConcave1','RefConvex1','RefConcave1','RandomConvex3','RandomConcave3','RefConvex3','RefConcave3'}; 

%ELECTRODES
electrodes = [25 26 27 62 63 64];

%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'off';

%GRAPHICAL PROPERTIES
FontSize = 20;
LineWidth = 2;
set(0,'DefaultAxesFontSize', FontSize);
IndividualBackground = 1

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

RandomConvex1 = selectedData.RandomConvex1.data;
RandomConcave1 = selectedData.RandomConcave1.data;
RefConvex1 = selectedData.RefConvex1.data;
RefConcave1 = selectedData.RefConcave1.data;


RandomConvex3 = selectedData.RandomConvex3.data;
RandomConcave3 = selectedData.RandomConcave3.data;
RefConvex3 = selectedData.RefConvex3.data;
RefConcave3 = selectedData.RefConcave3.data;


RandomConvex1Individuals = ERPerror.RandomConvex1.amplitudes;
RandomConcave1Individuals = ERPerror.RandomConcave1.amplitudes;
RefConvex1Individuals = ERPerror.RefConvex1.amplitudes;
RefConcave1Individuals = ERPerror.RefConcave1.amplitudes;

RandomConvex3Individuals = ERPerror.RandomConvex3.amplitudes;
RandomConcave3Individuals = ERPerror.RandomConcave3.amplitudes;
RefConvex3Individuals = ERPerror.RefConvex3.amplitudes;
RefConcave3Individuals = ERPerror.RefConcave3.amplitudes;
Zeroline = zeros(length(timeVector),1);
%FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomConvex1, RefConvex1],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% hold on
% plot(timeVector,RandomConvex1Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RefConvex1Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomConcave1, RefConcave1],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')



% hold on
% plot(timeVector,RandomConcave1Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RefConcave1Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 1

StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomConvex3, RefConvex3],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% hold on
% plot(timeVector,RandomConvex3Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RefConvex3Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomConcave3, RefConcave3],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')



% hold on
% plot(timeVector,RandomConcave3Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RefConcave3Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 2
close all
low = 300
high = 1000

DiffConvex1  = RefConvex1  - RandomConvex1;
DiffConcave1 = RefConcave1 - RandomConcave1;
DiffConvex3  = RefConvex3  - RandomConvex3;
DiffConcave3 = RefConcave3 - RandomConcave3;

ii = find(timeVector >=low & timeVector <=high);
MSPNConvex1=mean(DiffConvex1(ii));
MSPNConcave1=mean(DiffConcave1(ii));
MSPNConvex3=mean(DiffConvex3(ii));
MSPNConcave3=mean(DiffConcave3(ii));


SPNcheck = [MSPNConvex1,MSPNConcave1,MSPNConvex3,MSPNConcave3];
save('SPNcheck','SPNcheck');


CISPNConvex1 = ERPerror.ConvexSPN1.CI;
CISPNConcave1 = ERPerror.ConcaveSPN1.CI;
CISPNConvex3 = ERPerror.ConvexSPN3.CI;
CISPNConcave3 = ERPerror.ConcaveSPN3.CI;



if strcmp(smoothOn, 'on') == 1;
    CISPNConvex1 = smooth(CISPNConvex1,smoothfactor,'moving');
    CISPNConcave1 = smooth(CISPNConcave1,smoothfactor,'moving');
    CISPNConvex3 = smooth(CISPNConvex3,smoothfactor,'moving');
    CISPNConcave3 = smooth(CISPNConcave3,smoothfactor,'moving');
end

PosCISPNConvex1= DiffConvex1+CISPNConvex1;
PosCISPNConcave1= DiffConcave1+CISPNConcave1;

NegCISPNConvex1= DiffConvex1-CISPNConvex1;
NegCISPNConcave1= DiffConcave1-CISPNConcave1;

PosCISPNConvex3= DiffConvex3+CISPNConvex3;
PosCISPNConcave3= DiffConcave3+CISPNConcave3;

NegCISPNConvex3= DiffConvex3-CISPNConvex3;
NegCISPNConcave3= DiffConcave3-CISPNConcave3;



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNConvex1',fliplr(PosCISPNConvex1')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffConvex1,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNConvex1,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNConcave1',fliplr(PosCISPNConcave1')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffConcave1,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNConcave1,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNConvex3',fliplr(PosCISPNConvex3')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffConvex3,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNConvex3,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNConcave3',fliplr(PosCISPNConcave3')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffConcave3,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNConcave3,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
alpha(0.4)