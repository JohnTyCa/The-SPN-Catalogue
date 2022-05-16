close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 35/EX2 Disc Reg/Grand Averages';
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS
conditionNames={'Full','Occluded','Overlapped','Random'};

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
Full= selectedData.Full.data;
Occluded = selectedData.Occluded.data;
Random = selectedData.Random.data;
Overlapped = selectedData.Overlapped.data;


DiffFull= Full - Random;
DiffOccluded= Occluded - Random;
DiffOverlapped= Overlapped - Random;
Zeroline = zeros(length(timeVector),1);

FullIndividuals = ERPerror.Full.amplitudes;
OccludedIndividuals = ERPerror.Occluded.amplitudes;
OverlappedIndividuals = ERPerror.Overlapped.amplitudes;
RandomIndividuals = ERPerror.Random.amplitudes;


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [Random,Full],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, FullIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% uistack(P,'top')
% legend('off')


%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [Random,Occluded],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Occluded'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, OccludedIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% uistack(P,'top')
% legend('off')



%Figure1
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [Random,Overlapped],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Overlapped'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, OverlappedIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% uistack(P,'top')
% legend('off')




%FIGURE 2
close all
low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNFull =mean(DiffFull(ii));
MSPNOccluded =mean(DiffOccluded(ii));
MSPNOverlapped =mean(DiffOverlapped(ii));

SPNcheck = [MSPNFull,MSPNOccluded,MSPNOverlapped];
save('SPNcheck','SPNcheck');

CISPNFull = ERPerror.SPNFull.CI;
CISPNOccluded = ERPerror.SPNOccluded.CI;
CISPNOverlapped = ERPerror.SPNOverlapped.CI;

if strcmp(smoothOn, 'on') == 1;
    CISPNFull = smooth(CISPNFull,smoothfactor,'moving');
    CISPNOccluded = smooth(CISPNOccluded,smoothfactor,'moving');
    CISPNOverlapped = smooth(CISPNOverlapped,smoothfactor,'moving');
end

PosCISPNFull= DiffFull+CISPNFull;
NegCISPNFull= DiffFull-CISPNFull;
PosCISPNOccluded= DiffOccluded+CISPNOccluded;
NegCISPNOccluded= DiffOccluded-CISPNOccluded;
PosCISPNOverlapped= DiffOverlapped+CISPNOverlapped;
NegCISPNOverlapped= DiffOverlapped-CISPNOverlapped;


figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNFull',fliplr(PosCISPNFull')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFull,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFull,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
alpha(0.4);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')

figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNOccluded',fliplr(PosCISPNOccluded')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffOccluded,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNOccluded,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
alpha(0.4);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')

figure('color',[1,1,1])
themeCol = 'blue'
patch([timeVector,fliplr(timeVector)],[NegCISPNOverlapped',fliplr(PosCISPNOverlapped')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffOverlapped,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNOverlapped,themeCol,'LineWidth',LineWidth);
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
alpha(0.4);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')



