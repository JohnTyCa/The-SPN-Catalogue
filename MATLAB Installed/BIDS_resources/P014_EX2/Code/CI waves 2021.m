close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 14/EX2 Disc Col/Grand Averages';
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'PatternSym','PatternAsym','FlowerSym','FlowerAsym','LandscapeSym','LandscapeAsym'};


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
%use this to plot ERPs
PatternSym = selectedData.PatternSym.data;
PatternAsym = selectedData.PatternAsym.data;
FlowerSym = selectedData.FlowerSym.data;
FlowerAsym = selectedData.FlowerAsym.data;
LandscapeSym = selectedData.LandscapeSym.data;
LandscapeAsym = selectedData.LandscapeAsym.data;
DiffPattern = PatternSym - PatternAsym;
DiffFlower = FlowerSym - FlowerAsym;
DiffLandscape = LandscapeSym - LandscapeAsym;
Zeroline = zeros(length(timeVector),1);



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [PatternAsym, PatternSym],'LineWidth',LineWidth);
axis([-200 1000 -5 15]);
set(gca,'YTick',-5:5:15);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'ShapeAsym','ShapeSym'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, PatternAsymIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,PatternSymIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [FlowerAsym, FlowerSym],'LineWidth',LineWidth);
axis([-200 1000 -5 15]);
set(gca,'YTick',-5:5:15);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'FlowerAsym','FlowerSym'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, FlowerAsymIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,FlowernSymIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [LandscapeAsym, LandscapeSym],'LineWidth',LineWidth);
axis([-200 1000 -5 15]);
set(gca,'YTick',-5:5:15);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'LandscapeAsym','LandscapeSym'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, LandscapeAsymIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,LandscapeSymIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')





%FIGURE 2
low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNPattern = mean(DiffPattern(ii));
MSPNFlower = mean(DiffFlower(ii));
MSPNLandscape = mean(DiffLandscape(ii));

SPNcheck = [MSPNPattern,MSPNFlower,MSPNLandscape];
save('SPNcheck','SPNcheck');

CISPNPattern = ERPerror.SPNPattern.CI;
CISPNFlower = ERPerror.SPNFlower.CI;
CISPNLandscape = ERPerror.SPNLandscape.CI;


if strcmp(smoothOn, 'on') == 1;
    CISPNPattern = smooth(CISPNPattern,smoothfactor,'moving');
    CISPNFlower = smooth(CISPNFlower,smoothfactor,'moving');
    CISPNLandscape = smooth(CISPNLandscape,smoothfactor,'moving');

end

PosCISPNPattern= DiffPattern+CISPNPattern;
PosCISPNFlower= DiffFlower+CISPNFlower;
PosCISPNLandscape= DiffLandscape+CISPNLandscape;


NegCISPNPattern= DiffPattern-CISPNPattern;
NegCISPNFlower= DiffFlower-CISPNFlower;
NegCISPNLandscape= DiffLandscape-CISPNLandscape;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNPattern',fliplr(PosCISPNPattern')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffPattern,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNPattern,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNFlower',fliplr(PosCISPNFlower')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFlower,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFlower,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNLandscape',fliplr(PosCISPNLandscape')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffLandscape,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNLandscape,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
