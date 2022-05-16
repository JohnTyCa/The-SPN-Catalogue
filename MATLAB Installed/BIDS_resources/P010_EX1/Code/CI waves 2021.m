close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 10/EX1 Vertical/Grand Averages';
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS
conditionNames={'Reflection','Random'}


%ELECTRODES
electrodes = [24 25 62 61]; %P7 P8 PO7 PO8

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


Random= selectedData.Random.data;
Reflection = selectedData.Reflection.data;
DiffSPN= Reflection - Random;
Zeroline = zeros(length(timeVector),1);

ReflectionIndividuals = ERPerror.Reflection.amplitudes;
RandomIndividuals = ERPerror.Random.amplitudes;

%FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Reflection],'LineWidth',LineWidth);
axis([-200 1500 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:1500,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'Random','Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, ReflectionIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 2

low = 800
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPN=mean(DiffSPN(ii));
SPNcheck = MSPN
save('SPNcheck','SPNcheck');
themeCol = 'blue';
CISPN = ERPerror.SPN.CI;
if strcmp(smoothOn, 'on') == 1;
    CISPN = smooth(CISPN,smoothfactor,'moving');
end

PosCISPN= DiffSPN+CISPN;
NegCISPN= DiffSPN-CISPN;
figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPN',fliplr(PosCISPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffSPN,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1500 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:1500,'XMinorTick','on');
yline(MSPN,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
alpha(0.4)

