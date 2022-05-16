close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 4/EX1 Reg or Valence (first 24)/Grand Averages'
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS
conditionNames = {'RandomGoodValence','RandomBadValence','ReflectionGoodValence','ReflectionBadValence','RandomGoodRegularity','RandomBadRegularity','ReflectionGoodRegularity','ReflectionBadRegularity'};

%ELECTRODES
electrodes = [22 23 24 25 59 60 61 62]; % Left and right (Scott et al. 2009)

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
%use this to plot ERPs
RandomGoodValence= selectedData.RandomGoodValence.data;
RandomBadValence = selectedData.RandomBadValence.data;
ReflectionGoodValence= selectedData.ReflectionGoodValence.data;
ReflectionBadValence = selectedData.ReflectionBadValence.data;
RandomGoodRegularity= selectedData.RandomGoodRegularity.data;
RandomBadRegularity = selectedData.RandomBadRegularity.data;
ReflectionGoodRegularity= selectedData.ReflectionGoodRegularity.data;
ReflectionBadRegularity = selectedData.ReflectionBadRegularity.data;

DiffGoodValence = ReflectionGoodValence - RandomGoodValence;
DiffBadValence = ReflectionBadValence - RandomBadValence;
DiffGoodRegularity = ReflectionGoodRegularity - RandomGoodRegularity;
DiffBadRegularity = ReflectionBadRegularity - RandomBadRegularity;
Zeroline = zeros(length(timeVector),1);

RandomGoodValenceIndividuals= ERPerror.RandomGoodValence.amplitudes;
RandomBadValenceIndividuals = ERPerror.RandomBadValence.amplitudes;
ReflectionGoodValenceIndividuals= ERPerror.ReflectionGoodValence.amplitudes;
ReflectionBadValenceIndividuals = ERPerror.ReflectionBadValence.amplitudes;
RandomGoodRegularityIndividuals= ERPerror.RandomGoodRegularity.amplitudes;
RandomBadRegularityIndividuals = ERPerror.RandomBadRegularity.amplitudes;
ReflectionGoodRegularityIndividuals= ERPerror.ReflectionGoodRegularity.amplitudes;
ReflectionBadRegularityIndividuals = ERPerror.ReflectionBadRegularity.amplitudes;




% %Figure 1
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','-','-','-','-'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0.5 0 0],[0 1 0],[0 0.5 0],[0 0 1],[0 0 0.5],[0 1 1],[0 0.5 0.5]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [RandomGoodValence,RandomBadValence,ReflectionGoodValence,ReflectionBadValence,RandomGoodRegularity,RandomBadRegularity,ReflectionGoodRegularity,ReflectionBadRegularity],'LineWidth',LineWidth);
% axis([-200 1000 -10 10]);
% set(gca,'YTick',-10:5:10);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on');
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'RandomGoodValence','RandomBadValence','ReflectionGoodValence','ReflectionBadValence','RandomGoodRegularity','RandomBadRegularity','ReflectionGoodRegularity','ReflectionBadRegularity'},'FontSize',FontSize,'Location','northeast');
% xlabel('Time from stimulus onset (ms)');
% ylabel('Amplitude (microvolts)');
% grid('on')
% legend('boxoff')

% 

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomGoodValence,ReflectionGoodValence],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandomGoodValence','ReflectionGoodValence'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
load grandAverages;

% hold on
% plot(timeVector,RandomGoodValenceIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionGoodValenceIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomBadValence,ReflectionBadValence],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandomBadValence','ReflectionBadValence'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% hold on
% plot(timeVector,RandomBadValenceIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionBadValenceIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 3
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomGoodRegularity,ReflectionGoodRegularity],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandomGoodRegularity','ReflectionGoodRegularity'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector,RandomGoodRegularityIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionGoodRegularityIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 4
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomBadRegularity,ReflectionBadRegularity],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandomBadRegularity','ReflectionBadRegularity'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector,RandomBadRegularityIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionBadRegularityIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%FIGURE 1
low = 250
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNGoodValence = mean(DiffGoodValence(ii));
MSPNBadValence = mean(DiffBadValence(ii));
MSPNGoodRegularity = mean(DiffGoodRegularity(ii));
MSPNBadRegularity = mean(DiffBadRegularity(ii));

SPNcheck = [MSPNGoodValence,MSPNBadValence,MSPNGoodRegularity,MSPNBadRegularity];
save('SPNcheck','SPNcheck');


CISPNGoodValence = ERPerror.SPNGoodValence.CI;
CISPNBadValence = ERPerror.SPNBadValence.CI;
CISPNGoodRegularity = ERPerror.SPNGoodRegularity.CI;
CISPNBadRegularity = ERPerror.SPNBadRegularity.CI;

if strcmp(smoothOn, 'on') == 1;
    CISPNSPNGoodValence = smooth(CISPNSPNGoodValence,smoothfactor,'moving');
    CISPNSPNBadValence = smooth(CISPNSPNBadValence,smoothfactor,'moving');    
    CISPNSPNGoodValence = smooth(CISPNSPNGoodValence,smoothfactor,'moving');
    CISPNSPNBadValence = smooth(CISPNSPNBadValence,smoothfactor,'moving');
end

PosCISPNGoodValence= DiffGoodValence+CISPNGoodValence;
NegCISPNGoodValence= DiffGoodValence-CISPNGoodValence;
PosCISPNBadValence= DiffBadValence+CISPNBadValence;
NegCISPNBadValence= DiffBadValence-CISPNBadValence;
PosCISPNGoodRegularity= DiffGoodRegularity+CISPNGoodRegularity;
NegCISPNGoodRegularity= DiffGoodRegularity-CISPNGoodRegularity;
PosCISPNBadRegularity= DiffBadRegularity+CISPNBadRegularity;
NegCISPNBadRegularity= DiffBadRegularity-CISPNBadRegularity;

% Figure 1
figure('color',[1,1,1])
themeCol = 'blue'
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNGoodValence',fliplr(PosCISPNGoodValence')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffGoodValence,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNGoodValence,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

% Figure 2
figure('color',[1,1,1])
themeCol = 'blue'
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNBadValence',fliplr(PosCISPNBadValence')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffBadValence,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNBadValence,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


% Figure 3
figure('color',[1,1,1])
themeCol = 'blue'
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNGoodRegularity',fliplr(PosCISPNGoodRegularity')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffGoodRegularity,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNGoodRegularity,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

% Figure 4
figure('color',[1,1,1])
themeCol = 'blue'
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNBadRegularity',fliplr(PosCISPNBadRegularity')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffBadRegularity,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNBadRegularity,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
clear all