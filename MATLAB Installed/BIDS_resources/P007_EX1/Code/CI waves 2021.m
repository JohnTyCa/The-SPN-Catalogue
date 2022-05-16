close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 7/EX1 Disc Reg/Grand Averages';
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'ReflectionFlat','RandomFlat','ReflectionSlant','RandomSlant'}


%ELECTRODES
electrodes = [20 21 22 23 25 26 57 58 59 60 62 63];

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
ReflectionFlat= selectedData.ReflectionFlat.data;
ReflectionSlant = selectedData.ReflectionSlant.data;
RandomFlat= selectedData.RandomFlat.data;
RandomSlant = selectedData.RandomSlant.data;
DiffFlat= ReflectionFlat - RandomFlat;
DiffSlant= ReflectionSlant - RandomSlant;
Zeroline = zeros(length(timeVector),1);

ReflectionFlatIndividuals = ERPerror.ReflectionFlat.amplitudes;
ReflectionSlantIndividuals = ERPerror.ReflectionSlant.amplitudes;
RandomFlatIndividuals = ERPerror.RandomFlat.amplitudes;
RandomSlantIndividuals = ERPerror.RandomSlant.amplitudes;


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandomFlat,ReflectionFlat],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandomFlat','RelflectionFlat'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 


% plot(timeVector, RandomFlatIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionFlatIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandomSlant,ReflectionSlant],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandomSlant','RelflectionSlant'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on

% plot(timeVector, RandomSlantIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionSlantIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%FIGURE 2
low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNFlat = mean(DiffFlat(ii));
MSPNSlant = mean(DiffSlant(ii));

SPNcheck = [MSPNFlat,MSPNSlant];
save('SPNcheck','SPNcheck');

CISPNFlat = ERPerror.SPNFlat.CI;
CISPNSlant = ERPerror.SPNSlant.CI;


if strcmp(smoothOn, 'on') == 1;
    CISPNFlat = smooth(CISPNFlat,smoothfactor,'moving');
    CISPNSlant = smooth(CISPNSlant,smoothfactor,'moving');
end

PosCISPNFlat= DiffFlat+CISPNFlat;
NegCISPNFlat= DiffFlat-CISPNFlat;
PosCISPNSlant= DiffSlant+CISPNSlant;
NegCISPNSlant= DiffSlant-CISPNSlant;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNFlat',fliplr(PosCISPNFlat')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFlat,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFlat,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNSlant',fliplr(PosCISPNSlant')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSlant,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSlant,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

