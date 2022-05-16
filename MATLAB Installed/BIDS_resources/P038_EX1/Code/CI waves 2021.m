close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 38/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS

conditionNames={'REFdownRANDup','RANDdownREFup','REFdownREFupREFdown','REFupREFdownREFup','RandRandRand'};

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
REFdownRANDup = selectedData.REFdownRANDup.data;
RANDdownREFup = selectedData.RANDdownREFup.data;
REFdownREFupREFdown = selectedData.REFdownREFupREFdown.data;
REFupREFdownREFup= selectedData.REFupREFdownREFup.data;

Zeroline = zeros(length(timeVector),1);


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, REFdownRANDup],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','REFdownRANDup'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,REFdownRANDupIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')







%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, RANDdownREFup],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','RANDdownREFup'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RANDdownREFupIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, REFdownREFupREFdown],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','REFdownREFupREFdown'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,REFdownREFupREFdownIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')







%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, REFupREFdownREFup],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','REFupREFdownREFup'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,REFupREFdownREFupdownIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%FIGURE 2

DiffREFdownRANDup = REFdownRANDup - RandRandRand;
DiffRANDdownREFup  = RANDdownREFup  - RandRandRand;
DiffREFdownREFupREFdown = REFdownREFupREFdown - RandRandRand;
DiffREFupREFdownREFup = REFupREFdownREFup - RandRandRand;

low = 250
high = 600
ii = find(timeVector >=low & timeVector <=high);
MSPNREFdownRANDup = mean(DiffREFdownRANDup(ii));
MSPNRANDdownREFup = mean(DiffRANDdownREFup(ii));
MSPNREFdownREFupREFdown = mean(DiffREFdownREFupREFdown(ii));
MSPNREFupREFdownREFup = mean(DiffREFupREFdownREFup(ii));

SPNcheck = [MSPNREFdownRANDup,MSPNRANDdownREFup,MSPNREFdownREFupREFdown,MSPNREFupREFdownREFup];
save('SPNcheck','SPNcheck');

CIREFdownRANDupSPN = ERPerror.REFdownRANDupSPN.CI;
CIRANDdownREFupSPN = ERPerror.RANDdownREFupSPN.CI;
CIREFdownREFupREFdownSPN = ERPerror.REFdownREFupREFdownSPN.CI;
CIREFupREFdownREFupSPN = ERPerror.REFupREFdownREFupSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIREFdownRANDupSPN = smooth(CIREFdownRANDupSPN,smoothfactor,'moving');
    CIRANDdownREFupSPN = smooth(CIRANDdownREFupSPN,smoothfactor,'moving');
    CIREFdownREFupREFdownSPN = smooth(CIREFdownREFupREFdownSPN,smoothfactor,'moving');
    CIREFupREFdownREFupSPN = smooth(CIREFupREFdownREFupSPN,smoothfactor,'moving');
end

PosCIREFdownRANDupSPN= DiffREFdownRANDup+CIREFdownRANDupSPN;
PosCIRANDdownREFupSPN= DiffRANDdownREFup+CIRANDdownREFupSPN;
PosCIREFdownREFupREFdownSPN= DiffREFdownREFupREFdown+CIREFdownREFupREFdownSPN;
PosCIREFupREFdownREFupSPN= DiffREFupREFdownREFup+CIREFupREFdownREFupSPN;

NegCIREFdownRANDupSPN= DiffREFdownRANDup-CIREFdownRANDupSPN;
NegCIRANDdownREFupSPN= DiffRANDdownREFup-CIRANDdownREFupSPN;
NegCIREFdownREFupREFdownSPN= DiffREFdownREFupREFdown-CIREFdownREFupREFdownSPN;
NegCIREFupREFdownREFupSPN= DiffREFupREFdownREFup-CIREFupREFdownREFupSPN;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIREFdownRANDupSPN',fliplr(PosCIREFdownRANDupSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffREFdownRANDup,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNREFdownRANDup,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRANDdownREFupSPN',fliplr(PosCIRANDdownREFupSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRANDdownREFup,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNRANDdownREFup,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIREFdownREFupREFdownSPN',fliplr(PosCIREFdownREFupREFdownSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffREFdownREFupREFdown,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNREFdownREFupREFdown,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIREFupREFdownREFupSPN',fliplr(PosCIREFupREFdownREFupSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffREFupREFdownREFup,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNREFupREFdownREFup,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


