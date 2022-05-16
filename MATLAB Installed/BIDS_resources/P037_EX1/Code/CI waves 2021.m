close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 37/Grand Averages';
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS
conditionNames={'RandRand','SymSym'};


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


SymSym = selectedData.SymSym.data;
RandRand = selectedData.RandRand.data;
Diff = SymSym-RandRand;
Zeroline = zeros(length(timeVector),1);

SymSymIndividuals = ERPerror.SymSym.amplitudes;
RandRandIndividuals = ERPerror.RandRand.amplitudes;

%FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRand, SymSym],'LineWidth',LineWidth);
axis([-200 2250 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',0:500:2250,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,150,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1750,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRand','SymSym'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% hold on
% plot(timeVector,RandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, SymSymIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')
% legend('off')

%FIGURE 2

low = 200;
high = 350; 
ii = find(timeVector >=low & timeVector <=high);
MSPN=mean(Diff(ii))
SPNcheck = MSPN;
save('SPNcheck','SPNcheck');
themeCol = 'blue'
CISPN = ERPerror.SPN.CI;
if strcmp(smoothOn, 'on') == 1;
    CISPN = smooth(CISPN,smoothfactor,'moving');
end
PosCISPN= Diff+CISPN;
NegCISPN= Diff-CISPN;
figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPN',fliplr(PosCISPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, Diff,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth);
axis([-200 2250 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2250,'XMinorTick','on');
yline(MSPN,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
box('on')
legend('off')
alpha(0.4)

