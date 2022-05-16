close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 31/EX1 Shape/Grand Averages';
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS



conditionNames ={'SymmetrySame','SymmetryNovel','AsymmetrySame','AsymmetryNovel'}; 

%ELECTRODES
electrodes = [24 25 61 62]; % Left and right

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


SymmetrySame = selectedData.SymmetrySame.data;
SymmetryNovel = selectedData.SymmetryNovel.data;
AsymmetrySame = selectedData.AsymmetrySame.data;
AsymmetryNovel = selectedData.AsymmetryNovel.data;

Zeroline = zeros(length(timeVector),1);

SymmetrySameIndividuals = ERPerror.SymmetrySame.amplitudes;
SymmetryNovelIndividuals = ERPerror.SymmetryNovel.amplitudes;
AsymmetrySameIndividuals = ERPerror.AsymmetrySame.amplitudes;
AsymmetryNovelIndividuals = ERPerror.AsymmetryNovel.amplitudes;

%FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [AsymmetrySame, SymmetrySame],'LineWidth',LineWidth);
axis([0 1500 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:250:1500,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,250,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[250,-10,250,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[500,-10,1000,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% hold on
% plot(timeVector,SymmetrySameIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, AsymmetrySameIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [AsymmetryNovel, SymmetryNovel],'LineWidth',LineWidth);
axis([0 1500 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:250:1500,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,250,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[250,-10,250,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[500,-10,1000,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% hold on
% plot(timeVector,SymmetrySameIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, AsymmetrySameIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')




%FIGURE 2
close all
low = 250
high = 350

DiffSame  = SymmetrySame  - AsymmetrySame;
DiffNovel  = SymmetryNovel - AsymmetryNovel;

ii = find(timeVector >=low & timeVector <=high);
MSPNSame=mean(DiffSame(ii));
MSPNNovel=mean(DiffNovel(ii));

SPNcheck = [MSPNSame,MSPNNovel];
save('SPNcheck','SPNcheck');


CISPNSame = ERPerror.SameSPN.CI;
CISPNNovel = ERPerror.NovelSPN.CI;




if strcmp(smoothOn, 'on') == 1;
    CISPNSame = smooth(CISPNSame,smoothfactor,'moving');
    CISPNNovel = smooth(CISPNNovel,smoothfactor,'moving');
end

PosCISPNSame= DiffSame+CISPNSame;
PosCISPNNovel= DiffNovel+CISPNNovel;

NegCISPNSame= DiffSame-CISPNSame;
NegCISPNNovel= DiffNovel-CISPNNovel;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNSame',fliplr(PosCISPNSame')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffSame,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([0 1500 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:250:1500,'XMinorTick','on');
yline(MSPNSame,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPNNovel',fliplr(PosCISPNNovel')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, DiffNovel,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([0 1500 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:250:1500,'XMinorTick','on');
yline(MSPNNovel,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

