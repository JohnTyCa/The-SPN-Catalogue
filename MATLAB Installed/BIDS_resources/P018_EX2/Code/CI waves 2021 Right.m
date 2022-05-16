close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX2 Left and Right With Eye Tracking/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerrorRight;
%CONDITIONS

conditionNames={'REFRANDs','RANDREFs','REFlREFrREFl','REFrREFlREFr','RandRandRand','Consistent','Changing'};

%ELECTRODES
electrodes = [58 59 62 63]; % right electrodes 

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
Consistent = selectedData.Consistent.data;
Changing = selectedData.Changing.data;
REFRANDs = selectedData.REFRANDs.data;
RANDREFs = selectedData.RANDREFs.data;
REFlREFrREFl =  selectedData.REFlREFrREFl.data;
REFrREFlREFr =  selectedData.REFrREFlREFr.data;


DiffConsistent = Consistent - RandRandRand;
DiffChanging = Changing - RandRandRand;
DiffREFRANDs = REFRANDs - RandRandRand;
DiffRANDREFs = RANDREFs - RandRandRand;
DiffREFlREFrREFl = REFlREFrREFl - RandRandRand;
DiffREFrREFlREFr = REFrREFlREFr - RandRandRand;
Zeroline = zeros(length(timeVector),1);



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, REFRANDs],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','REFRANDs'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,REFRANDsIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')




%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, REFlREFrREFl],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandRandRand','REFlREFrREFl'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

 
% plot(timeVector, RandRandRandIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,REFlREFrREFlIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')





%FIGURE 2
low = 250
high = 600
ii = find(timeVector >=low & timeVector <=high);
MSPNREFRANDs = mean(DiffREFRANDs(ii));
MSPNREFlREFrREFl = mean(DiffREFlREFrREFl(ii));

SPNcheckRight = [MSPNREFRANDs,MSPNREFlREFrREFl]
save('SPNcheckRight','SPNcheckRight');


CIREFRANDsSPN = ERPerror.REFRANDsSPN.CI;
CIREFlREFrREFlSPN = ERPerror.REFlREFrREFlSPN.CI;


if strcmp(smoothOn, 'on') == 1;
    CIREFRANDsSPN = smooth(CIREFRANDsSPN,smoothfactor,'moving');
    CIREFREFlREFrREFlSPN = smooth(REFlREFrREFlSPN,smoothfactor,'moving');
    
end

PosCIREFRANDsSPN= DiffREFRANDs+CIREFRANDsSPN;
PosCIREFlREFrREFlSPN= DiffREFlREFrREFl+CIREFlREFrREFlSPN;

NegCIREFRANDsSPN= DiffREFRANDs-CIREFRANDsSPN;
NegCIREFlREFrREFlSPN= DiffREFlREFrREFl-CIREFlREFrREFlSPN;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIREFRANDsSPN',fliplr(PosCIREFRANDsSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffREFRANDs,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNREFRANDs,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIREFlREFrREFlSPN',fliplr(PosCIREFlREFrREFlSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffREFlREFrREFl,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNREFlREFrREFl,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

