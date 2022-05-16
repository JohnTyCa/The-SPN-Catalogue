close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 34/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames ={'rrs','rro','rno','nrs','nro','nno'}; 

%ELECTRODES
electrodes = [25 24 61 62];

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
rrs= selectedData.rrs.data;
rro = selectedData.rro.data;
rno = selectedData.rno.data;
nrs = selectedData.nrs.data;
nro= selectedData.nro.data;
nno = selectedData.nno.data;


Zeroline = zeros(length(timeVector),1);

rrsIndividuals =  ERPerror.rrs.amplitudes;
rroIndividuals =  ERPerror.rro.amplitudes;
rnoIndividuals  = ERPerror.rno.amplitudes;
nrsIndividuals =  ERPerror.nrs.amplitudes;
nroIndividuals =  ERPerror.nro.amplitudes;
nnoIndividuals =  ERPerror.nno.amplitudes;

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [nrs, rrs],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandRefSame','RefRefSame'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector,nrsIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,rrsIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [nro, rro],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandRefOthogonal','RefRefOthogonal'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, nroIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,rroIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [nno, rno],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandRand','RefRand'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, nnoIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,rnoIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')








%FIGURE 2
close all
Diffrrs= rrs - nrs;
Diffrro= rro - nro;
Diffrno= rno - nno;

low= 300
high = 900
ii = find(timeVector >=low & timeVector <=high);
MSPNrrs = mean(Diffrrs(ii));
MSPNrro = mean(Diffrro(ii));
MSPNrno = mean(Diffrno(ii));


SPNcheck = [MSPNrrs,MSPNrro,MSPNrno];
save('SPNcheck','SPNcheck');

CIrrsSPN = ERPerror.rrsSPN.CI;
CIrroSPN = ERPerror.rroSPN.CI;
CIrnoSPN = ERPerror.rnoSPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIrrsSPN = smooth(CIrrsSPN,smoothfactor,'moving');
    CIrroSPN = smooth(CIrroSPN,smoothfactor,'moving');
    CIrnoSPN = smooth(CIrnoSPN,smoothfactor,'moving');
end

PosCIrrsSPN=Diffrrs+CIrrsSPN;
PosCIrroSPN=Diffrro+CIrroSPN;
PosCIrnoSPN=Diffrno+CIrnoSPN;

NegCIrrsSPN=Diffrrs-CIrrsSPN;
NegCIrroSPN=Diffrro-CIrroSPN;
NegCIrnoSPN=Diffrno-CIrnoSPN;


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIrrsSPN',fliplr(PosCIrrsSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,Diffrrs,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNrrs,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIrroSPN',fliplr(PosCIrroSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,Diffrro,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNrro,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIrnoSPN',fliplr(PosCIrnoSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,Diffrno,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNrno,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
