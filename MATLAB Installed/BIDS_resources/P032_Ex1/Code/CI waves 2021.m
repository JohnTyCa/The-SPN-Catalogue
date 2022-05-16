close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 32/EX1 ContrastStereoCombined/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'BinocularSym','BinocularAsym','ContrastSym','ContrastAsym','CombinedSym','CombinedAsym'};

%ELECTRODES
electrodes = [25 27 62 64];

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
BinocularSym = selectedData.BinocularSym.data;
BinocularAsym = selectedData.BinocularAsym.data;
ContrastSym = selectedData.ContrastSym.data;
ContrastAsym = selectedData.ContrastAsym.data;
CombinedSym = selectedData.CombinedSym.data;
CombinedAsym = selectedData.CombinedAsym.data;

Zeroline = zeros(length(timeVector),1);

BinocularSymIndividuals = ERPerror.BinocularSym.amplitudes;
BinocularAsymIndividuals = ERPerror.BinocularAsym.amplitudes;
ContrastSymIndividuals = ERPerror.ContrastSym.amplitudes;
ContrastAsymIndividuals = ERPerror.ContrastAsym.amplitudes;
CombinedSymIndividuals = ERPerror.CombinedSym.amplitudes;
CombinedAsymIndividuals = ERPerror.CombinedAsym.amplitudes;




%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [BinocularAsym, BinocularSym],'LineWidth',LineWidth);
axis([-200 1500 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:250:1500);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, BinocularSymIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,BinocularSymIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [ContrastAsym, ContrastSym],'LineWidth',LineWidth);
axis([-200 1500 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:250:1500);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, ContrastAsymIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,ContrastSymIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [CombinedAsym, CombinedSym],'LineWidth',LineWidth);
axis([-200 1500 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:250:1500);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, CombinedAsymIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,CombinedSymIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')








%FIGURE 2
close all
DiffBinocular  = BinocularSym  - BinocularAsym;
DiffContrast   = ContrastSym - ContrastAsym;
DiffCombined   = CombinedSym - CombinedAsym;

low= 400
high = 1500
ii = find(timeVector >=low & timeVector <=high);
MSPNBinocular = mean(DiffBinocular(ii));
MSPNContrast = mean(DiffContrast(ii));
MSPNCombined = mean(DiffCombined(ii));


SPNcheck = [MSPNBinocular,MSPNContrast,MSPNCombined];
save('SPNcheck','SPNcheck');

CIBinocularSPN = ERPerror.BinocularSPN.CI;
CIContrastSPN = ERPerror.ContrastSPN.CI;
CICombinedSPN = ERPerror.CombinedSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIBinocularSPN = smooth(CIBinocularSPN,smoothfactor,'moving');
    CIContrastSPN = smooth(CIContrastSPN,smoothfactor,'moving');
    CICombinedSPN = smooth(CICombinedSPN,smoothfactor,'moving');
end

PosCIBinocularSPN=DiffBinocular+CIBinocularSPN;
PosCIContrastSPN=DiffContrast+CIContrastSPN;
PosCICombinedSPN=DiffCombined+CICombinedSPN;

NegCIBinocularSPN=DiffBinocular-CIBinocularSPN;
NegCIContrastSPN=DiffContrast-CIContrastSPN;
NegCICombinedSPN=DiffCombined-CICombinedSPN;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIBinocularSPN',fliplr(PosCIBinocularSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffBinocular,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1500 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',0:250:1500,'XMinorTick','on');
yline(MSPNBinocular,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIContrastSPN',fliplr(PosCIContrastSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffContrast,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1500 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',0:250:1500,'XMinorTick','on');
yline(MSPNContrast,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCICombinedSPN',fliplr(PosCICombinedSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffCombined,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1500 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',0:250:1500,'XMinorTick','on');
yline(MSPNCombined,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
