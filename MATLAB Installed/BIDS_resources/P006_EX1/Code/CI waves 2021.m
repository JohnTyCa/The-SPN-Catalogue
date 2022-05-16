close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 6/Grand Averages';
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'ReflectionVertical','TranslationVertical','ReflectionHorizontal','TranslationHorizontal'}


%ELECTRODES
electrodes = [25 26 27 62 63 64]; % These will be used if no dogma selected

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
ReflectionVertical= selectedData.ReflectionVertical.data;
ReflectionHorizontal = selectedData.ReflectionHorizontal.data;
TranslationVertical= selectedData.TranslationVertical.data;
TranslationHorizontal = selectedData.TranslationHorizontal.data;
DiffVertical= ReflectionVertical - TranslationVertical;
DiffHorizontal= ReflectionHorizontal - TranslationHorizontal;
Zeroline = zeros(length(timeVector),1);

ReflectionVerticalIndividuals = ERPerror.ReflectionVertical.amplitudes;
ReflectionHorizontalIndividuals = ERPerror.ReflectionHorizontal.amplitudes;
TranslationVerticalIndividuals = ERPerror.TranslationVertical.amplitudes;
TranslationHorizontalIndividuals = ERPerror.TranslationHorizontal.amplitudes;


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [TranslationVertical,ReflectionVertical],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'TranslationVertical','RelflectionVertical'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 


% plot(timeVector, TranslationVerticalIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionVerticalIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [TranslationHorizontal,ReflectionHorizontal],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'TranslationHorizontal','RelflectionHorizontal'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on

% plot(timeVector, TranslationHorizontalIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionHorizontalIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%FIGURE 2
low = 250
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNVertical = mean(DiffVertical(ii))
MSPNHorizontal = mean(DiffHorizontal(ii))

SPNcheck = [MSPNVertical,MSPNHorizontal];
save('SPNcheck','SPNcheck');

CISPNVertical = ERPerror.SPNVertical.CI;
CISPNHorizontal = ERPerror.SPNHorizontal.CI;


if strcmp(smoothOn, 'on') == 1;
    CISPNVertical = smooth(CISPNVertical,smoothfactor,'moving');
    CISPNHorizontal = smooth(CISPNHorizontal,smoothfactor,'moving');
end

PosCISPNVertical= DiffVertical+CISPNVertical;
NegCISPNVertical= DiffVertical-CISPNVertical;
PosCISPNHorizontal= DiffHorizontal+CISPNHorizontal;
NegCISPNHorizontal= DiffHorizontal-CISPNHorizontal;

figure('color',[1,1,1])
themeCol = 'blue'
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNVertical',fliplr(PosCISPNVertical')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffVertical,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNVertical,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



figure('color',[1,1,1])
themeCol = 'blue'
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNHorizontal',fliplr(PosCISPNHorizontal')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffHorizontal,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNHorizontal,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

