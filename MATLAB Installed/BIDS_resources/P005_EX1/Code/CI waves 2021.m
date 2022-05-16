close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 5/Grand Averages'
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS
conditionNames={'Random','Reflection100','Reflection80','Reflection60','Reflection40','Reflection20'};
%ELECTRODES
electrodes = [25 62]; % Which electrodes do you want? 
%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 10;
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

%save('thisPlot','data');

%use this to plot ERPs
Random = selectedData.Random.data;
Reflection20 = selectedData.Reflection20.data;
Reflection40 = selectedData.Reflection40.data;
Reflection60 = selectedData.Reflection60.data;
Reflection80 = selectedData.Reflection80.data;
Reflection100 = selectedData.Reflection100.data;
Diff20 = Reflection20 - Random;
Diff40 = Reflection40 - Random;
Diff60 = Reflection60 - Random;
Diff80 = Reflection80 - Random;
Diff100 =Reflection100 - Random;
Zeroline = zeros(length(timeVector),1);
Zeroline = zeros(length(timeVector),1);

RandomIndividuals = ERPerror.Random.amplitudes;
Reflection20Individuals = ERPerror.Reflection20.amplitudes;
Reflection40Individuals = ERPerror.Reflection40.amplitudes;
Reflection60Individuals = ERPerror.Reflection60.amplitudes;
Reflection80Individuals = ERPerror.Reflection80.amplitudes;
Reflection100Individuals =ERPerror.Reflection100.amplitudes;

%FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Reflection20],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection20'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, Reflection20Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')




StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Reflection40],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection40'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, Reflection40Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Reflection60],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection60'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, Reflection60Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Reflection80],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection80'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, Reflection80Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')


StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Reflection100],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Reflection100'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector,RandomIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on 
% plot(timeVector, Reflection100Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on
% uistack(P,'top')

%FIGURE 2

low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPN20=mean(Diff20(ii));
MSPN40=mean(Diff40(ii));
MSPN60=mean(Diff60(ii));
MSPN80=mean(Diff80(ii));
MSPN100=mean(Diff100(ii));
SPNcheck = [MSPN100,MSPN80,MSPN60,MSPN40,MSPN20];
save('SPNcheck','SPNcheck');



themeCol = 'blue'
CISPN20 = ERPerror.SPN20.CI;
CISPN40 = ERPerror.SPN40.CI;
CISPN60 = ERPerror.SPN60.CI;
CISPN80 = ERPerror.SPN80.CI;
CISPN100 = ERPerror.SPN100.CI;

if strcmp(smoothOn, 'on') == 1;
    CISPN20 = smooth(CISPN20,smoothfactor,'moving');
    CISPN40 = smooth(CISPN40,smoothfactor,'moving');    
    CISPN60 = smooth(CISPN60,smoothfactor,'moving');    
    CISPN80 = smooth(CISPN80,smoothfactor,'moving');    
    CISPN100 = smooth(CISPN100,smoothfactor,'moving');
    
end

PosCISPN20= Diff20+CISPN20;
NegCISPN20= Diff20-CISPN20;
PosCISPN40= Diff40+CISPN40;
NegCISPN40= Diff40-CISPN40;
PosCISPN60= Diff60+CISPN60;
NegCISPN60= Diff60-CISPN60;
PosCISPN80= Diff80+CISPN80;
NegCISPN80= Diff80-CISPN80;
PosCISPN100= Diff100+CISPN100;
NegCISPN100= Diff100-CISPN100;


figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPN20',fliplr(PosCISPN20')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, Diff20,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPN20,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPN40',fliplr(PosCISPN40')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, Diff40,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPN40,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPN60',fliplr(PosCISPN60')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, Diff60,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPN60,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPN80',fliplr(PosCISPN80')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, Diff80,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPN80,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); % this was introduced in Matlab 2018
patch([timeVector,fliplr(timeVector)],[NegCISPN100',fliplr(PosCISPN100')],themeCol,'EdgeColor','none');
hold on
plot(timeVector, Diff100,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth);
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPN100,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


