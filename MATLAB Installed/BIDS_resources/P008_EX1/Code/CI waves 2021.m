close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 8/EX1 W Ref and Rep/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames = {'Random','Rand20','Rand60','Rand100','Ref20','Ref60','Ref100','Trans20','Trans60','Trans100'};


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
Random= selectedData.Random.data;
Rand20 = selectedData.Rand20.data;
Rand60 = selectedData.Rand60.data;
Rand100 = selectedData.Rand100.data;
Ref20 = selectedData.Ref20.data;
Ref60 = selectedData.Ref60.data;
Ref100 = selectedData.Ref100.data;
Trans20 = selectedData.Trans20.data;
Trans60 = selectedData.Trans60.data;
Trans100 = selectedData.Trans100.data;
DiffRef20= Ref20 - Random;
DiffRef60= Ref60 - Random;
DiffRef100= Ref100 - Random;
DiffTrans20= Trans20 - Random;
DiffTrans60= Trans60 - Random;
DiffTrans100= Trans100 - Random;
Zeroline = zeros(length(timeVector),1);

RandomIndividuals = ERPerror.Random.amplitudes;
Ref20Indivduals = ERPerror.Ref20.amplitudes;
Ref60Indivduals = ERPerror.Ref60.amplitudes;
Ref100Indivduals = ERPerror.Ref100.amplitudes;
Trans20Indivduals = ERPerror.Trans20.amplitudes;
Trans60Indivduals = ERPerror.Trans60.amplitudes;
Trans100Indivduals = ERPerror.Trans100.amplitudes;



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Ref20],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Ref20'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Ref20Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Ref60],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Ref60'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% plot(timeVector, RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Ref60Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Ref100],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Ref100'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% plot(timeVector, RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Ref100Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Trans20],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Rep20'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% plot(timeVector, RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Trans20Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Trans60],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Rep60'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% plot(timeVector, RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Trans60Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Trans100],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Rep100'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% plot(timeVector, RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Trans100Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')





















%FIGURE 2
low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNRef20 = mean(DiffRef20(ii));
MSPNRef60 = mean(DiffRef60(ii));
MSPNRef100 = mean(DiffRef100(ii));
MSPNTrans20 = mean(DiffTrans20(ii));
MSPNTrans60 = mean(DiffTrans60(ii));
MSPNTrans100 = mean(DiffTrans100(ii));

SPNcheck = [MSPNRef20,MSPNRef60,MSPNRef100,MSPNTrans20,MSPNTrans60,MSPNTrans100];
save('SPNcheck','SPNcheck');

CISPNRef20 = ERPerror.SPNRef20.CI;
CISPNRef60 = ERPerror.SPNRef60.CI;
CISPNRef100 = ERPerror.SPNRef100.CI;
CISPNTrans20 = ERPerror.SPNTrans20.CI;
CISPNTrans60 = ERPerror.SPNTrans60.CI;
CISPNTrans100 = ERPerror.SPNTrans100.CI;

if strcmp(smoothOn, 'on') == 1;
    CISPNRef20 = smooth(CISPNRef20,smoothfactor,'moving');
    CISPNRef60 = smooth(CISPNRef60,smoothfactor,'moving');
    CISPNRef100 = smooth(CISPNRef100,smoothfactor,'moving');
    CISPNTrans20 = smooth(CISPNTrans20,smoothfactor,'moving');
    CISPNTrans60 = smooth(CISPNTrans60,smoothfactor,'moving');
    CISPNTrans100 = smooth(CISPNTrans100,smoothfactor,'moving');
    
end

PosCISPNRef20= DiffRef20+CISPNRef20;
PosCISPNRef60= DiffRef60+CISPNRef60;
PosCISPNRef100= DiffRef100+CISPNRef100;
NegCISPNRef20= DiffRef20-CISPNRef20;
NegCISPNRef60= DiffRef60-CISPNRef60;
NegCISPNRef100= DiffRef100-CISPNRef100;
PosCISPNTrans20= DiffTrans20+CISPNTrans20;
PosCISPNTrans60= DiffTrans60+CISPNTrans60;
PosCISPNTrans100= DiffTrans100+CISPNTrans100;
NegCISPNTrans20= DiffTrans20-CISPNTrans20;
NegCISPNTrans60= DiffTrans60-CISPNTrans60;
NegCISPNTrans100= DiffTrans100-CISPNTrans100;


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNRef20',fliplr(PosCISPNRef20')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRef20,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRef20,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNRef60',fliplr(PosCISPNRef60')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRef60,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRef60,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNRef100',fliplr(PosCISPNRef100')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRef100,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRef100,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNTrans20',fliplr(PosCISPNTrans20')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTrans20,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTrans20,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNTrans60',fliplr(PosCISPNTrans60')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTrans60,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTrans60,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNTrans100',fliplr(PosCISPNTrans100')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTrans100,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTrans100,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
