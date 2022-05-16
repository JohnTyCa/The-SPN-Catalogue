close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX1 Ref and Ident/Grand Averages';
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS

conditionNames={'RandRandRand', 'RefRefRef','RandRandRef','RandIdent','RefIdent'};

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
RandIdent = selectedData.RandIdent.data;
RefIdent = selectedData.RefIdent.data;
RandRandRef = selectedData.RandRandRef.data;
DiffRefRefRef = RefRefRef - RandRandRand;
DiffRefIdent = RefIdent - RandIdent;
DiffRandRandRef = RandRandRef - RandRandRand;
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
P = plot(timeVector, [RandIdent RefIdent],'LineWidth',LineWidth);
axis([-200 2100 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-0:500:2000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
rectangle('position',[0,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[700,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
rectangle('position',[1400,-10,500,20],'FaceColor',[1 1 0 0],'EdgeColor','black'); % this was introduced in Matlab 2018
legend({'RandIdent','RefIdent'},'FontSize',FontSize,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
hold on 
% plot(timeVector, RandIdentIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RefIdentIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
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





%FIGURE 2
low = 250
high = 600
ii = find(timeVector >=low & timeVector <=high);
MSPNRefRefRef = mean(DiffRefRefRef(ii));
MSPNRefIdent = mean(DiffRefIdent(ii));





CIRefRefRefSPN = ERPerror.RefRefRefSPN.CI;
CIRefIdentSPN = ERPerror.RefIdentSPN.CI;
CIRandRandRefSPN = ERPerror.RandRandRefSPN.CI;


if strcmp(smoothOn, 'on') == 1;
    CIRefRefRefSPN = smooth(CIRefRefRefSPN,smoothfactor,'moving');
    CIRefIdentSPN = smooth(CIRefIdentSPN,smoothfactor,'moving');
    CIRandRandRefSPN = smooth(RandRandRefSPN,smoothfactor,'moving');
end

PosCIRefRefRefSPN= DiffRefRefRef+CIRefRefRefSPN;
PosCIRefIdentSPN= DiffRefIdent+CIRefIdentSPN;
PosCIRandRandRefSPN= DiffRandRandRef+CIRandRandRefSPN;


NegCIRefRefRefSPN= DiffRefRefRef-CIRefRefRefSPN;
NegCIRefIdentSPN= DiffRefIdent-CIRefIdentSPN;
NegCIRandRandRefSPN= DiffRandRandRef-CIRandRandRefSPN;


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
patch([timeVector,fliplr(timeVector)],[NegCIRefIdentSPN',fliplr(PosCIRefIdentSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRefIdent,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 2100 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-0:500:2000,'XMinorTick','on');
yline(MSPNRefIdent,themeCol,'LineWidth',LineWidth);
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
SPNcheck = [MSPNRefRefRef,MSPNRefIdent,MSPNRandRandRef];
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



