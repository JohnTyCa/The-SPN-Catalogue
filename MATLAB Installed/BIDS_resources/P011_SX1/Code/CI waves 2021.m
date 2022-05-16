close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 11/Sup Ex1/Grand Averages'
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS

conditionNames={'SymmetryShort','RandomShort','SymmetryMedium','RandomMedium','SymmetryLong','RandomLong'};


%ELECTRODES
electrodes = [25 62]; % These will be used if no dogma selected

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


SymmetryShort = selectedData.SymmetryShort.data;
RandomShort = selectedData.RandomShort.data;
SymmetryMedium = selectedData.SymmetryMedium.data;
RandomMedium = selectedData.RandomMedium.data;
SymmetryLong = selectedData.SymmetryLong.data;
RandomLong = selectedData.RandomLong.data;
DiffShort = SymmetryShort-RandomShort;
DiffMedium = SymmetryMedium-RandomMedium;
DiffLong = SymmetryLong-RandomLong;
Zeroline = zeros(length(timeVector),1);

SymmetryShortIndividuals = ERPerror.SymmetryShort.amplitudes;
RandomShortIndividuals = ERPerror.RandomShort.amplitudes;
SymmetryMediumIndividuals = ERPerror.SymmetryMedium.amplitudes;
RandomMediumIndividuals = ERPerror.RandomMedium.amplitudes;
SymmetryLongIndividuals = ERPerror.SymmetryLong.amplitudes;
RandomLongIndividuals = ERPerror.RandomLong.amplitudes;
%FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomShort, SymmetryShort],'LineWidth',LineWidth);
axis([-200 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,150,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandomShort','SymmetryShort'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandomShortIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, SymmetryShortIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')
% legend('off')


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomMedium, SymmetryMedium],'LineWidth',LineWidth);
axis([-200 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandomMedium','SymmetryMedium'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandomMediumIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, SymmetryMediumIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')
% legend('off')

%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomLong, SymmetryLong],'LineWidth',LineWidth);
axis([-200 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,1000,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandomLong','SymmetryLong'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% hold on
% plot(timeVector,RandomLongIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, SymmetryLongIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')
% legend('off')

%FIGURE 2
low = 200;
high = 350;
ii = find(timeVector >=low & timeVector <=high);
MSPN=mean(DiffShort(ii));
ShortSPNcheck = MSPN;
save('ShortSPNcheck','ShortSPNcheck');
themeCol = 'blue';
CIShortSPN = ERPerror.ShortSPN.CI;
if strcmp(smoothOn, 'on') == 1;
    CIShortSPN = smooth(CIShortSPN,smoothfactor,'moving');
end
PosCIShortSPN= DiffShort+CIShortSPN;
NegCIShortSPN= DiffShort-CIShortSPN;
figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCIShortSPN',fliplr(PosCIShortSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffShort,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth);
axis([-200 2000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPN,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

%FIGURE 2
low = 200;
high = 550;
ii = find(timeVector >=low & timeVector <=high);
MSPN=mean(DiffMedium(ii));
MediumSPNcheck = MSPN
save('MediumSPNcheck','MediumSPNcheck');
themeCol = 'blue';
CIMediumSPN = ERPerror.MediumSPN.CI;
if strcmp(smoothOn, 'on') == 1;
    CIMediumSPN = smooth(CIMediumSPN,smoothfactor,'moving');
end
PosCIMediumSPN= DiffMedium+CIMediumSPN;
NegCIMediumSPN= DiffMedium-CIMediumSPN;
figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCIMediumSPN',fliplr(PosCIMediumSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffMedium,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth);
axis([-200 2000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPN,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



%FIGURE 2
low = 200;
high = 1050; 
ii = find(timeVector >=low & timeVector <=high);
MSPN=mean(DiffLong(ii));
LongSPNcheck = MSPN;
save('LongSPNcheck','LongSPNcheck');
themeCol = 'blue';
CILongSPN = ERPerror.LongSPN.CI;
if strcmp(smoothOn, 'on') == 1;
    CILongSPN = smooth(CILongSPN,smoothfactor,'moving');
end
PosCILongSPN= DiffLong+CILongSPN;
NegCILongSPN= DiffLong-CILongSPN;
figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCILongSPN',fliplr(PosCILongSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffLong,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth);
axis([-200 2000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPN,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
