close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 12/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'AntiSymmetryDiscReg','SymmetryDiscReg','RandomDiscReg','AntiSymmetryDiscColor','SymmetryDiscColor','RandomDiscColor'};


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
SymmetryDiscReg = selectedData.SymmetryDiscReg.data;
AntiSymmetryDiscReg = selectedData.AntiSymmetryDiscReg.data;
RandomDiscReg = selectedData.RandomDiscReg.data;
SymmetryDiscColor = selectedData.SymmetryDiscColor.data;
AntiSymmetryDiscColor = selectedData.AntiSymmetryDiscColor.data;
RandomDiscColor = selectedData.RandomDiscColor.data;
DiffSymmetryDiscReg = SymmetryDiscReg-RandomDiscReg;
DiffAntiSymmetryDiscReg = AntiSymmetryDiscReg-RandomDiscReg;
DiffSymmetryDiscColor = SymmetryDiscColor-RandomDiscColor;
DiffAntiSymmetryDiscColor = AntiSymmetryDiscColor-RandomDiscColor;
Zeroline = zeros(length(timeVector),1);


RandomDiscRegIndividuals = ERPerror.RandomDiscReg.amplitudes;
AntiSymmetryDiscRegIndivduals = ERPerror.AntiSymmetryDiscReg.amplitudes;
SymmetryDiscRegIndivduals = ERPerror.SymmetryDiscReg.amplitudes;

RandomDiscColorIndividuals = ERPerror.RandomDiscColor.amplitudes;
AntiSymmetryDiscColorIndivduals = ERPerror.AntiSymmetryDiscColor.amplitudes;
SymmetryDiscColorIndivduals = ERPerror.SymmetryDiscColor.amplitudes;


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomDiscReg, AntiSymmetryDiscReg],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','AntiSymmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandomDiscRegIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,AntiSymmetryDiscRegIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomDiscReg, SymmetryDiscReg],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandomDiscRegIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,AntiSymmetryDiscRegIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomDiscColor, AntiSymmetryDiscColor],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','AntiSymmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandomDiscColorIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,AntiSymmetryDiscColorIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomDiscColor, SymmetryDiscColor],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandomDiscColorIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,AntiSymmetryDiscColorIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')




















%FIGURE 2
low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNAntiSymmetryDiscReg = mean(DiffAntiSymmetryDiscReg(ii));
MSPNSymmetryDiscReg = mean(DiffSymmetryDiscReg(ii));
MSPNAntiSymmetryDiscColor = mean(DiffAntiSymmetryDiscColor(ii));
MSPNSymmetryDiscColor = mean(DiffSymmetryDiscColor(ii));

SPNcheck = [MSPNAntiSymmetryDiscReg,MSPNSymmetryDiscReg,MSPNAntiSymmetryDiscColor,MSPNSymmetryDiscColor];
save('SPNcheck','SPNcheck');

CISPNAntiSymmetryDiscReg = ERPerror.SPNAntiSymmetryDiscReg.CI;
CISPNSymmetryDiscReg = ERPerror.SPNSymmetryDiscReg.CI;
CISPNAntiSymmetryDiscColor = ERPerror.SPNAntiSymmetryDiscColor.CI;
CISPNSymmetryDiscColor = ERPerror.SPNSymmetryDiscColor.CI;

if strcmp(smoothOn, 'on') == 1;
    CISPNAntiSymmetryDiscReg = smooth(CISPNAntiSymmetryDiscReg,smoothfactor,'moving');
    CISPNSymmetryDiscReg = smooth(CISPNSymmetryDiscReg,smoothfactor,'moving');
    CISPNAntiSymmetryDiscColor = smooth(CISPNAntiSymmetryDiscColor,smoothfactor,'moving');
    CISPNSymmetryDiscColor = smooth(CISPNSymmetryDiscColor,smoothfactor,'moving');
end

PosCISPNAntiSymmetryDiscReg= DiffAntiSymmetryDiscReg+CISPNAntiSymmetryDiscReg;
PosCISPNSymmetryDiscReg= DiffSymmetryDiscReg+CISPNSymmetryDiscReg;

NegCISPNAntiSymmetryDiscReg= DiffAntiSymmetryDiscReg-CISPNAntiSymmetryDiscReg;
NegCISPNSymmetryDiscReg= DiffSymmetryDiscReg-CISPNSymmetryDiscReg;

PosCISPNAntiSymmetryDiscColor= DiffAntiSymmetryDiscColor+CISPNAntiSymmetryDiscColor;
PosCISPNSymmetryDiscColor= DiffSymmetryDiscColor+CISPNSymmetryDiscColor;

NegCISPNAntiSymmetryDiscColor= DiffAntiSymmetryDiscColor-CISPNAntiSymmetryDiscColor;
NegCISPNSymmetryDiscColor= DiffSymmetryDiscColor-CISPNSymmetryDiscColor;


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNAntiSymmetryDiscReg',fliplr(PosCISPNAntiSymmetryDiscReg')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffAntiSymmetryDiscReg,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNAntiSymmetryDiscReg,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNSymmetryDiscReg',fliplr(PosCISPNSymmetryDiscReg')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSymmetryDiscReg,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSymmetryDiscReg,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNAntiSymmetryDiscColor',fliplr(PosCISPNAntiSymmetryDiscColor')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffAntiSymmetryDiscColor,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNAntiSymmetryDiscColor,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNSymmetryDiscColor',fliplr(PosCISPNSymmetryDiscColor')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSymmetryDiscColor,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSymmetryDiscColor,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


