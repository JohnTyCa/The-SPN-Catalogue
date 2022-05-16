close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 30/EX2 Gerbino Black Disc Col/Grand Averages';
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS


conditionNames = {'RandomConvex','RandomConcave','RefConvex','RefConcave'}; 

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

RandomConvex = selectedData.RandomConvex.data;
RandomConcave = selectedData.RandomConcave.data;
RefConvex = selectedData.RefConvex.data;
RefConcave = selectedData.RefConcave.data;

Zeroline = zeros(length(timeVector),1);


Zeroline = zeros(length(timeVector),1);

RandomConvexIndividuals = ERPerror.RandomConvex.amplitudes;
RandomConcaveIndividuals = ERPerror.RandomConcave.amplitudes;
RefConvexIndividuals = ERPerror.RefConvex.amplitudes;
RefConcaveIndividuals = ERPerror.RefConcave.amplitudes;


%FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomConvex, RefConvex],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% hold on
% plot(timeVector,RandomConvexIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RefConvexIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomConcave, RefConcave],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')



% hold on
% plot(timeVector,RandomConcaveIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, RefConcaveIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 2

low = 300
high = 1000

DiffConvex  = RefConvex - RandomConvex;
DiffConcave = RefConcave - RandomConcave;

ii = find(timeVector >=low & timeVector <=high);
MSPNConvex=mean(DiffConvex(ii));
MSPNConcave=mean(DiffConcave(ii));

SPNcheck = [MSPNConvex,MSPNConcave];
save('SPNcheck','SPNcheck');


CISPNConvex = ERPerror.ConvexSPN.CI;
CISPNConcave = ERPerror.ConcaveSPN.CI;




if strcmp(smoothOn, 'on') == 1;
    CISPNConvex = smooth(CISPNConvex,smoothfactor,'moving');
    CISPNConcave = smooth(CISPNConcave,smoothfactor,'moving');
end

PosCISPNConvex= DiffConvex+CISPNConvex;
PosCISPNConcave= DiffConcave+CISPNConcave;

NegCISPNConvex= DiffConvex-CISPNConvex;
NegCISPNConcave= DiffConcave-CISPNConcave;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNConvex',fliplr(PosCISPNConvex')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffConvex,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNConvex,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNConcave',fliplr(PosCISPNConcave')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffConcave,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNConcave,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
alpha(0.4)

