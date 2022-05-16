close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 27/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames = {'Random','Glass', 'Reflection','Translation'};

%ELECTRODES
electrodes = [25 62]; % PO7 O1 O2 PO8

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
Glass = selectedData.Glass.data;
Reflection = selectedData.Reflection.data;
Translation = selectedData.Translation.data;



Zeroline = zeros(length(timeVector),1);

RandomIndividuals =  ERPerror.Random.amplitudes;
GlassIndividuals =  ERPerror.Glass.amplitudes;
ReflectionIndividuals  = ERPerror.Reflection.amplitudes;
TranslationIndividuals =  ERPerror.Translation.amplitudes;

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Glass],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Glass'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,GlassIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Reflection],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ReflectionIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Translation],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Translation'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,TranslationIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')








%FIGURE 2
close all
DiffGlass= Glass - Random;
DiffReflection= Reflection - Random;
DiffTranslation= Translation - Random;

low= 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNGlass = mean(DiffGlass(ii));
MSPNReflection = mean(DiffReflection(ii));
MSPNTranslation = mean(DiffTranslation(ii));


SPNcheck = [MSPNGlass,MSPNReflection,MSPNTranslation];
save('SPNcheck','SPNcheck');

CIGlassSPN = ERPerror.GlassSPN.CI;
CIReflectionSPN = ERPerror.ReflectionSPN.CI;
CITranslationSPN = ERPerror.TranslationSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIGlassSPN = smooth(CIGlassSPN,smoothfactor,'moving');
    CIReflectionSPN = smooth(CIReflectionSPN,smoothfactor,'moving');
    CITranslationSPN = smooth(CITranslationSPN,smoothfactor,'moving');
end

PosCIGlassSPN=DiffGlass+CIGlassSPN;
PosCIReflectionSPN=DiffReflection+CIReflectionSPN;
PosCITranslationSPN=DiffTranslation+CITranslationSPN;

NegCIGlassSPN=DiffGlass-CIGlassSPN;
NegCIReflectionSPN=DiffReflection-CIReflectionSPN;
NegCITranslationSPN=DiffTranslation-CITranslationSPN;


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIGlassSPN',fliplr(PosCIGlassSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffGlass,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNGlass,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIReflectionSPN',fliplr(PosCIReflectionSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffReflection,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNReflection,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCITranslationSPN',fliplr(PosCITranslationSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTranslation,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTranslation,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
