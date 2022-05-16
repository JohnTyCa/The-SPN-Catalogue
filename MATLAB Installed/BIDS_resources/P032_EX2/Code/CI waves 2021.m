close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 32/EX2 FigureGround/Grand Averages';
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'FigureSym', 'GroundSym','FigureAsym','GroundAsym'};

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
FigureSym= selectedData.FigureSym.data;
GroundSym = selectedData.GroundSym.data;
FigureAsym = selectedData.FigureAsym.data;
GroundAsym = selectedData.GroundAsym.data;

Zeroline = zeros(length(timeVector),1);

FigureSymIndividuals = ERPerror.FigureSym.amplitudes;
FigureAsymIndividuals = ERPerror.FigureAsym.amplitudes;
GroundSymIndividuals = ERPerror.GroundSym.amplitudes;
GroundAsymIndividuals = ERPerror.GroundAsym.amplitudes;




%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [FigureAsym, FigureSym],'LineWidth',LineWidth);
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
% plot(timeVector, FigureIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,GroundIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [GroundAsym, GroundSym],'LineWidth',LineWidth);
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
% plot(timeVector, GroundAsymIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,GroundSymIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')











%FIGURE 2
close all
DiffFigure  = FigureSym  - FigureAsym;
DiffGround = GroundSym - GroundAsym;

low= 400
high = 1500
ii = find(timeVector >=low & timeVector <=high);
MSPNFigure = mean(DiffFigure(ii));
MSPNGround = mean(DiffGround(ii));



SPNcheck = [MSPNFigure,MSPNGround];
save('SPNcheck','SPNcheck');

CIFigureSPN = ERPerror.FigureSPN.CI;
CIGroundSPN = ERPerror.GroundSPN.CI;


if strcmp(smoothOn, 'on') == 1;
    CIFigureSPN = smooth(CIFigureSPN,smoothfactor,'moving');
    CIGroundSPN = smooth(CIGroundSPN,smoothfactor,'moving');
    
end

PosCIFigureSPN=DiffFigure+CIFigureSPN;
PosCIGroundSPN=DiffGround+CIGroundSPN;


NegCIFigureSPN=DiffFigure-CIFigureSPN;
NegCIGroundSPN=DiffGround-CIGroundSPN;


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIFigureSPN',fliplr(PosCIFigureSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFigure,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1500 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',0:250:1500,'XMinorTick','on');
yline(MSPNFigure,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIGroundSPN',fliplr(PosCIGroundSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffGround,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1500 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',0:250:1500,'XMinorTick','on');
yline(MSPNGround,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


