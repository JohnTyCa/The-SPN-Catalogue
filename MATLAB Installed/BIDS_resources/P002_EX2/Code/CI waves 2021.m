close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 2/EX2 Regularity/Grand Averages'
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS
conditionNames={'Reflection','Rotation','Random','Translation'};

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
Reflection= selectedData.Reflection.data;
Rotation = selectedData.Rotation.data;
Random = selectedData.Random.data;
Translation = selectedData.Translation.data;


DiffReflection= Reflection - Random;
DiffRotation= Rotation - Random;
DiffTranslation= Translation - Random;
Zeroline = zeros(length(timeVector),1);

ReflectionIndividuals = ERPerror.Reflection.amplitudes;
RotationIndividuals = ERPerror.Rotation.amplitudes;
TranslationIndividuals = ERPerror.Translation.amplitudes;
RandomIndividuals = ERPerror.Random.amplitudes;


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [Random,Reflection],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, ReflectionIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% uistack(P,'top')
% legend('off')

%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [Random,Translation],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Translation'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, TranslationIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% uistack(P,'top')
% legend('off')


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [Random,Rotation],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Rotation'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RotationIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% uistack(P,'top')
% legend('off')



%FIGURE 2
low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNRef =mean(DiffReflection(ii));
MSPNTrans =mean(DiffTranslation(ii));
MSPNRot =mean(DiffRotation(ii));

SPNcheck = [MSPNRef,MSPNTrans,MSPNRot];
save('SPNcheck','SPNcheck');

CISPNReflection = ERPerror.SPNReflection.CI;
CISPNRotation = ERPerror.SPNRotation.CI;
CISPNTranslation = ERPerror.SPNTranslation.CI;

if strcmp(smoothOn, 'on') == 1;
    CISPNReflection = smooth(CISPNReflection,smoothfactor,'moving');
    CISPNRotation = smooth(CISPNRotation,smoothfactor,'moving');
    CISPNTranslation = smooth(CISPNTranslation,smoothfactor,'moving');
end

PosCISPNReflection= DiffReflection+CISPNReflection;
NegCISPNReflection= DiffReflection-CISPNReflection;
PosCISPNRotation= DiffRotation+CISPNRotation;
NegCISPNRotation= DiffRotation-CISPNRotation;
PosCISPNTranslation= DiffTranslation+CISPNTranslation;
NegCISPNTranslation= DiffTranslation-CISPNTranslation;


figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNReflection',fliplr(PosCISPNReflection')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffReflection,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRef,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
alpha(0.4);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')


figure('color',[1,1,1])
themeCol = 'blue'
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNTranslation',fliplr(PosCISPNTranslation')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTranslation,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTrans,themeCol,'LineWidth',LineWidth);

alpha(0.4);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')



figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNRotation',fliplr(PosCISPNRotation')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRotation,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRot,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
alpha(0.4);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
