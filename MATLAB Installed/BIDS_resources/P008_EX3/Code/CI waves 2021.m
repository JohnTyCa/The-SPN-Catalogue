close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 8/EX3 Naxes/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames = {'Rand' 'Ref1', 'Ref2', 'Ref3', 'Ref4', 'Ref5'};


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
Rand= selectedData.Rand.data;
Ref1 = selectedData.Ref1.data;
Ref2 = selectedData.Ref2.data;
Ref3 = selectedData.Ref3.data;
Ref4 = selectedData.Ref4.data;
Ref5 = selectedData.Ref5.data;
DiffRef1= Ref1 - Rand;
DiffRef2= Ref2 - Rand;
DiffRef3= Ref3 - Rand;
DiffRef4= Ref4 - Rand;
DiffRef5= Ref5 - Rand;
Zeroline = zeros(length(timeVector),1);

RandIndividuals = ERPerror.Rand.amplitudes;
Ref1Individuals = ERPerror.Ref1.amplitudes;
Ref2Individuals = ERPerror.Ref2.amplitudes;
Ref3Individuals = ERPerror.Ref3.amplitudes;
Ref4Individuals = ERPerror.Ref4.amplitudes;
Ref5Individuals = ERPerror.Ref5.amplitudes;


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand, Ref1],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Ref1'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Ref1Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand, Ref2],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Ref2'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% plot(timeVector, RandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Ref1Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand, Ref3],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Ref3'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% plot(timeVector, RandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Ref3Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand, Ref4],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Ref4'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% plot(timeVector, RandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Ref4Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')





StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand, Ref5],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Ref5'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% plot(timeVector, RandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,Ref5Individuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')












%FIGURE 2
low = 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNRef1 = mean(DiffRef1(ii));
MSPNRef2 = mean(DiffRef2(ii));
MSPNRef3 = mean(DiffRef3(ii));
MSPNRef4 = mean(DiffRef4(ii));
MSPNRef5 = mean(DiffRef5(ii));

SPNcheck = [MSPNRef1,MSPNRef2,MSPNRef3,MSPNRef4,MSPNRef5];
save('SPNcheck','SPNcheck');

CISPNRef1 = ERPerror.SPNRef1.CI;
CISPNRef2 = ERPerror.SPNRef2.CI;
CISPNRef3 = ERPerror.SPNRef3.CI;
CISPNRef4 = ERPerror.SPNRef4.CI;
CISPNRef5 = ERPerror.SPNRef5.CI;
if strcmp(smoothOn, 'on') == 1;
    CISPN1 = smooth(CISPN1,smoothfactor,'moving');
    CISPN2 = smooth(CISPN2,smoothfactor,'moving');
    CISPN3 = smooth(CISPN3,smoothfactor,'moving');
    CISPN4 = smooth(CISPN4,smoothfactor,'moving');
    CISPN5 = smooth(CISPN5,smoothfactor,'moving');

    
end

PosCISPNRef1= DiffRef1+CISPNRef1;
PosCISPNRef2= DiffRef2+CISPNRef2;
PosCISPNRef3= DiffRef3+CISPNRef3;
PosCISPNRef4= DiffRef4+CISPNRef4;
PosCISPNRef5= DiffRef5+CISPNRef5;

NegCISPNRef1= DiffRef1-CISPNRef1;
NegCISPNRef2= DiffRef2-CISPNRef2;
NegCISPNRef3= DiffRef3-CISPNRef3;
NegCISPNRef4= DiffRef4-CISPNRef4;
NegCISPNRef5= DiffRef5-CISPNRef5;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNRef1',fliplr(PosCISPNRef1')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRef1,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRef1,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNRef2',fliplr(PosCISPNRef2')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRef2,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRef2,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)




figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNRef3',fliplr(PosCISPNRef3')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRef3,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRef3,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNRef4',fliplr(PosCISPNRef4')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRef4,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRef4,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPNRef5',fliplr(PosCISPNRef5')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRef5,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color','red','LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRef5,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


