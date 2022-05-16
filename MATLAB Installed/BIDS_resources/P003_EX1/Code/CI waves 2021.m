close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 3/EX1 Reg/Grand Averages'
load timeVector;
load LowPass40grandAverages; %
load ERPerror;
%CONDITIONS
conditionNames = {'ReflectionOne','ReflectionTwo', 'TranslationOne', 'TranslationTwo'};

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
ReflectionOne= selectedData.ReflectionOne.data;
ReflectionTwo = selectedData.ReflectionTwo.data;
TranslationOne= selectedData.TranslationOne.data;
TranslationTwo = selectedData.TranslationTwo.data;
DiffOne= ReflectionOne - TranslationOne;
DiffTwo= ReflectionTwo - TranslationTwo;
Zeroline = zeros(length(timeVector),1);

ReflectionOneIndividuals = ERPerror.ReflectionOne.amplitudes;
ReflectionTwoIndividuals = ERPerror.ReflectionTwo.amplitudes;
TranslationOneIndividuals = ERPerror.TranslationOne.amplitudes;
TranslationTwoIndividuals = ERPerror.TranslationTwo.amplitudes;


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [TranslationOne,ReflectionOne],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'TranslationOne','RelflectionOne'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 


% plot(timeVector, TranslationOneIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionOneIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [TranslationTwo,ReflectionTwo],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'TranslationTwo','RelflectionTwo'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on

% plot(timeVector, TranslationTwoIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionTwoIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%FIGURE 2
low = 250
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNOne = mean(DiffOne(ii));
MSPNTwo = mean(DiffTwo(ii));
SPNcheck = [MSPNOne,MSPNTwo];
save('SPNcheck','SPNcheck');

CISPNOne = ERPerror.SPNOne.CI;
CISPNTwo = ERPerror.SPNTwo.CI;


if strcmp(smoothOn, 'on') == 1;
    CISPNOne = smooth(CISPNOne,smoothfactor,'moving');
    CISPNTwo = smooth(CISPNTwo,smoothfactor,'moving');
end

PosCISPNOne= DiffOne+CISPNOne;
NegCISPNOne= DiffOne-CISPNOne;
PosCISPNTwo= DiffTwo+CISPNTwo;
NegCISPNTwo= DiffTwo-CISPNTwo;

figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNOne',fliplr(PosCISPNOne')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffOne,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNOne,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNTwo',fliplr(PosCISPNTwo')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTwo,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTwo,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

