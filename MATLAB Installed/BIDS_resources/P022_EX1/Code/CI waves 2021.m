close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 22/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'AS20','S20','Rand20','AS40','S40','Rand40','AS80','S80','Rand80'};

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

AS20=selectedData.AS20.data;
S20=selectedData.S20.data;
Rand20= selectedData.Rand20.data;
AS40=selectedData.AS40.data;
S40=selectedData.S40.data;
Rand40= selectedData.Rand40.data;
AS80=selectedData.AS80.data;
S80=selectedData.S80.data;
Rand80= selectedData.Rand80.data;
DiffAS20 = AS20-Rand20;
DiffS20 = S20-Rand20;
DiffAS40 = AS40-Rand40;
DiffS40 = S40-Rand40;
DiffAS80 = AS80-Rand80;
DiffS80 = S80-Rand80;
Zeroline = zeros(length(timeVector),1);



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand20, AS20],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand20','AS20'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, Rand20Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,AS20Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand20, S20],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand20','S20'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, Rand20Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,S20Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand40, AS40],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand40','AS40'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, Rand40Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,AS40Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand40, S40],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand40','S40'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, Rand40Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,S40Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')




%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand80, AS80],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand80','AS80'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, Rand80Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,AS80Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand80, S80],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand80','S80'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, Rand80Individuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,S80Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

















%FIGURE 2
low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNAS20 = mean(DiffAS20(ii));
MSPNS20 = mean(DiffS20(ii));
MSPNAS40 = mean(DiffAS40(ii));
MSPNS40 = mean(DiffS40(ii));
MSPNAS80 = mean(DiffAS80(ii));
MSPNS80 = mean(DiffS80(ii));

SPNcheck = [MSPNAS20,MSPNS20,MSPNAS40,MSPNS40,MSPNAS80,MSPNS80];
save('SPNcheck','SPNcheck');

CIAS20SPN = ERPerror.AS20SPN.CI;
CIS20SPN = ERPerror.S20SPN.CI;
CIAS40SPN = ERPerror.AS40SPN.CI;
CIS40SPN = ERPerror.S40SPN.CI;
CIAS80SPN = ERPerror.AS80SPN.CI;
CIS80SPN = ERPerror.S80SPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIAS20SPN = smooth(CIAS20SPN,smoothfactor,'moving');
    CIS20SPN = smooth(CIS20SPN,smoothfactor,'moving');
    CIAS40SPN = smooth(CIAS40SPN,smoothfactor,'moving');
    CIS40SPN = smooth(CIS40SPN,smoothfactor,'moving');
    CIAS80SPN = smooth(CIAS80SPN,smoothfactor,'moving');
    CIS80SPN = smooth(CIS80SPN,smoothfactor,'moving');
end

PosCIAS20SPN= DiffAS20+CIAS20SPN;
PosCIS20SPN= DiffS20+CIS20SPN;
PosCIAS40SPN= DiffAS40+CIAS40SPN;
PosCIS40SPN= DiffS40+CIS40SPN;
PosCIAS80SPN= DiffAS80+CIAS80SPN;
PosCIS80SPN= DiffS80+CIS80SPN;

NegCIAS20SPN= DiffAS20-CIAS20SPN;
NegCIS20SPN= DiffS20-CIS20SPN;
NegCIAS40SPN= DiffAS40-CIAS40SPN;
NegCIS40SPN= DiffS40-CIS40SPN;
NegCIAS80SPN= DiffAS80-CIAS80SPN;
NegCIS80SPN= DiffS80-CIS80SPN;



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIAS20SPN',fliplr(PosCIAS20SPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffAS20,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNAS20,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIS20SPN',fliplr(PosCIS20SPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffS20,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNS20,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)




figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIAS40SPN',fliplr(PosCIAS40SPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffAS40,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNAS40,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIS40SPN',fliplr(PosCIS40SPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffS40,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNS40,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)




figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIAS80SPN',fliplr(PosCIAS80SPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffAS80,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNAS80,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIS80SPN',fliplr(PosCIS80SPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffS80,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNS80,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)