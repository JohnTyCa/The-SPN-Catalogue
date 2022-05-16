close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 19/Grand Averages';
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS

conditionNames={'RandRandRand', 'RefRefRef','RotRotRot','RandRandRef','RandRandRot','RefRefRot','RotRotRef'};
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

RandRandRand = selectedData.RandRandRand.data;
RefRefRef = selectedData.RefRefRef.data;
RotRotRot = selectedData.RotRotRot.data;
RandRandRef = selectedData.RandRandRef.data;
RandRandRot = selectedData.RandRandRot.data;
RefRefRot = selectedData.RefRefRot.data;
RotRotRef = selectedData.RotRotRef.data;
DiffRefRefRef = RefRefRef - RandRandRand;
DiffRotRotRot = RotRotRot - RandRandRand;
DiffRandRandRef = RandRandRef -RandRandRand;
DiffRandRandRot = RandRandRot - RandRandRand;
DiffRefRefRot = RefRefRot-RandRandRand;
DiffRotRotRef = RotRotRef-RandRandRand;
Zeroline = zeros(length(timeVector),1);



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RefRefRef],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','RefRefRef'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RefRefRefIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')







%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RotRotRot],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','RotRotRot'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RotRotRotIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RefRefRot],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','RefRefRot'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RefRefRotIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')







%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RotRotRef],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','RotRotRef'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RotRotRefIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RandRandRef],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','RandRandRef'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RandRandRefIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RandRandRot],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','RandRandRot'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RandRandRotIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%FIGURE 2
low = 250
high = 600
ii = find(timeVector >=low & timeVector <=high);
MSPNRefRefRef = mean(DiffRefRefRef(ii));
MSPNRotRotRot = mean(DiffRotRotRot(ii));
MSPNRefRefRot = mean(DiffRefRefRot(ii));
MSPNRotRotRef = mean(DiffRotRotRef(ii));



CIRefRefRefSPN = ERPerror.RefRefRefSPN.CI;
CIRotRotRotSPN = ERPerror.RotRotRotSPN.CI;
CIRefRefRotSPN = ERPerror.RefRefRotSPN.CI;
CIRotRotRefSPN = ERPerror.RotRotRefSPN.CI;
CIRandRandRefSPN = ERPerror.RandRandRefSPN.CI;
CIRandRandRotSPN = ERPerror.RandRandRotSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIRefRefRefSPN = smooth(CIRefRefRefSPN,smoothfactor,'moving');
    CIRotRotRotSPN = smooth(CIRotRotRotSPN,smoothfactor,'moving');
    CIRefRefRotSPN = smooth(CIRefRefRotSPN,smoothfactor,'moving');
    CIRotRotRefSPN = smooth(CIRotRotRefSPN,smoothfactor,'moving');
    CIRandRandRefSPN = smooth(CIRandRandRefSPN,smoothfactor,'moving');
    CIRandRandRotSPN = smooth(CIRandRandRotSPN,smoothfactor,'moving');
end

PosCIRefRefRefSPN= DiffRefRefRef+CIRefRefRefSPN;
PosCIRotRotRotSPN= DiffRotRotRot+CIRotRotRotSPN;
PosCIRefRefRotSPN= DiffRefRefRot+CIRefRefRotSPN;
PosCIRotRotRefSPN= DiffRotRotRef+CIRotRotRefSPN;
PosCIRandRandRefSPN= DiffRandRandRef+CIRandRandRefSPN;
PosCIRandRandRotSPN= DiffRandRandRot+CIRandRandRotSPN;

NegCIRefRefRefSPN= DiffRefRefRef-CIRefRefRefSPN;
NegCIRotRotRotSPN= DiffRotRotRot-CIRotRotRotSPN;
NegCIRefRefRotSPN= DiffRefRefRot-CIRefRefRotSPN;
NegCIRotRotRefSPN= DiffRotRotRef-CIRotRotRefSPN;
NegCIRandRandRefSPN= DiffRandRandRef-CIRandRandRefSPN;
NegCIRandRandRotSPN= DiffRandRandRot-CIRandRandRotSPN;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRefRefRefSPN',fliplr(PosCIRefRefRefSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRefRefRef,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNRefRefRef,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRotRotRotSPN',fliplr(PosCIRotRotRotSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRotRotRot,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNRotRotRot,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRefRefRotSPN',fliplr(PosCIRefRefRotSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRefRefRot,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNRefRefRot,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRotRotRefSPN',fliplr(PosCIRotRotRefSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRotRotRef,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNRotRotRef,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

low = 1650
high = 2000
ii = find(timeVector >=low & timeVector <=high);
MSPNRandRandRef = mean(DiffRandRandRef(ii));
MSPNRandRandRot = mean(DiffRandRandRot(ii));

SPNcheck = [MSPNRefRefRef,MSPNRotRotRot,MSPNRefRefRot,MSPNRotRotRef,MSPNRandRandRef,MSPNRandRandRot];
save('SPNcheck','SPNcheck');

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRandRandRefSPN',fliplr(PosCIRandRandRefSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRandRandRef,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNRandRandRef,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRandRandRotSPN',fliplr(PosCIRandRandRotSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRandRandRot,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNRandRandRot,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

