close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 29/Grand Averages';
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS


conditionNames={'RandomFigure','SymmetryFigure','RandomGround','SymmetryGround'};

%ELECTRODES
electrodes = [25 26 27 62 63 64];

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

SymmetryFigure = selectedData.SymmetryFigure.data;
RandomFigure = selectedData.RandomFigure.data;

SymmetryGround= selectedData.SymmetryGround.data;
RandomGround= selectedData.RandomGround.data;

Zeroline = zeros(length(timeVector),1);

SymmetryFigureIndividuals = ERPerror.SymmetryFigure.amplitudes;
RandomFigureIndividuals = ERPerror.RandomFigure.amplitudes;
SymmetryGroundIndividuals = ERPerror.SymmetryGround.amplitudes;
RandomGroundIndividuals = ERPerror.RandomGround.amplitudes;
%FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomFigure, SymmetryFigure],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% hold on
% plot(timeVector,RandomFigureIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, SymmetryFigureIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomGround, SymmetryGround],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% hold on
% plot(timeVector,RandomGroundIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, SymmetryGroundIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 2

low = 300
high = 600

DiffFigure = SymmetryFigure - RandomFigure;
DiffGround = SymmetryGround - RandomGround;

ii = find(timeVector >=low & timeVector <=high);
MSPNFigure=mean(DiffFigure(ii));
MSPNGround=mean(DiffGround(ii));

SPNcheck = [MSPNFigure,MSPNGround];
save('SPNcheck','SPNcheck');


CISPNFigure = ERPerror.SPNFigure.CI;
CISPNGround = ERPerror.SPNGround.CI;




if strcmp(smoothOn, 'on') == 1;
    CISPNFigure = smooth(CISPNFigure,smoothfactor,'moving');
    CISPNGround = smooth(CISPNGround,smoothfactor,'moving');
end

PosCISPNFigure= DiffFigure+CISPNFigure;
PosCISPNGround= DiffGround+CISPNGround;

NegCISPNFigure= DiffFigure-CISPNFigure;
NegCISPNGround= DiffGround-CISPNGround;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNFigure',fliplr(PosCISPNFigure')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffFigure,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFigure,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNGround',fliplr(PosCISPNGround')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffGround,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNGround,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
alpha(0.4)

