close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 33/EX1 Regularity/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerror;
%CONDITIONS
conditionNames={'RandFlatGabors','SymFlatGabors','RandSlantGabors','SymSlantGabors','RandFlatSolidPoly','SymFlatSolidPoly','RandSlantSolidPoly','SymSlantSolidPoly'};

%ELECTRODES
electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64];

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
RandFlatGabors= selectedData.RandFlatGabors.data;
SymFlatGabors = selectedData.SymFlatGabors.data;
RandSlantGabors = selectedData.RandSlantGabors.data;
SymSlantGabors = selectedData.SymSlantGabors.data;
RandFlatSolidPoly= selectedData.RandFlatSolidPoly.data;
SymFlatSolidPoly = selectedData.SymFlatSolidPoly.data;
RandSlantSolidPoly = selectedData.RandSlantSolidPoly.data;
SymSlantSolidPoly = selectedData.SymSlantSolidPoly.data;

Zeroline = zeros(length(timeVector),1);

RandFlatGaborsIndividuals = ERPerror.RandFlatGabors.amplitudes;
SymFlatGaborsIndividuals = ERPerror.SymFlatGabors.amplitudes;
RandSlantGaborsIndividuals = ERPerror.RandSlantGabors.amplitudes;
SymSlantGaborsIndividuals = ERPerror.SymSlantGabors.amplitudes;
RandFlatSolidPolyIndividuals = ERPerror.RandFlatSolidPoly.amplitudes; 
SymFlatSolidPolyIndividuals = ERPerror.SymFlatSolidPoly.amplitudes; 
RandSlantSolidPolyIndividuals = ERPerror.RandSlantSolidPoly.amplitudes; 
SymSlantSolidPolyIndividuals = ERPerror.SymSlantSolidPoly.amplitudes;

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandFlatGabors, SymFlatGabors],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandFlatGaborsIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlatGaborsIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandSlantGabors, SymSlantGabors],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandSlantGaborsIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymSlantGaborsIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandFlatSolidPoly, SymFlatSolidPoly],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandFlatSolidPolyIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlatSolidPolyIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')



%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandFlatSolidPoly, SymFlatSolidPoly],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Asymmetry','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RandFlatSolidPolyIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlatSolidPolyIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')




%FIGURE 2
close all
DiffFlatGabors  = SymFlatGabors  - RandFlatGabors;
DiffSlantGabors   = SymSlantGabors - RandSlantGabors;
DiffFlatSolidPoly  = SymFlatSolidPoly  - RandFlatSolidPoly;
DiffSlantSolidPoly   = SymSlantSolidPoly - RandSlantSolidPoly;

low= 300
high = 1000
ii = find(timeVector >=low & timeVector <=high);
MSPNFlatGabors = mean(DiffFlatGabors(ii));
MSPNSlantGabors = mean(DiffSlantGabors(ii));
MSPNFlatSolidPoly = mean(DiffFlatSolidPoly(ii));
MSPNSlantSolidPoly = mean(DiffSlantSolidPoly(ii));

SPNcheck = [MSPNFlatGabors,MSPNSlantGabors,MSPNFlatSolidPoly,MSPNSlantSolidPoly];
save('SPNcheck','SPNcheck');

CIFlatGaborsSPN = ERPerror.FlatGaborsSPN.CI;
CISlantGaborsSPN = ERPerror.SlantGaborsSPN.CI;
CIFlatSolidPolySPN = ERPerror.FlatSolidPolySPN.CI;
CISlantSolidPolySPN = ERPerror.SlantSolidPolySPN.CI;

if strcmp(smoothOn, 'on') == 1;
    CIFlatGaborsSPN = smooth(CIFlatGaborsSPN,smoothfactor,'moving');
    CISlantGaborsSPN = smooth(CISlantGaborsSPN,smoothfactor,'moving');
    CIFlatSolidPolySPN = smooth(CIFlatSolidPolySPN,smoothfactor,'moving');
    CISlantSolidPolySPN = smooth(CISlantSolidPolySPN,smoothfactor,'moving');
end

PosCIFlatGaborsSPN=DiffFlatGabors+CIFlatGaborsSPN;
PosCISlantGaborsSPN=DiffSlantGabors+CISlantGaborsSPN;
PosCIFlatSolidPolySPN=DiffFlatSolidPoly+CIFlatSolidPolySPN;
PosCISlantSolidPolySPN=DiffSlantSolidPoly+CISlantSolidPolySPN;

NegCIFlatGaborsSPN=DiffFlatGabors-CIFlatGaborsSPN;
NegCISlantGaborsSPN=DiffSlantGabors-CISlantGaborsSPN;
NegCIFlatSolidPolySPN=DiffFlatSolidPoly-CIFlatSolidPolySPN;
NegCISlantSolidPolySPN=DiffSlantSolidPoly-CISlantSolidPolySPN;

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIFlatGaborsSPN',fliplr(PosCIFlatGaborsSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFlatGabors,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFlatGabors,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCISlantGaborsSPN',fliplr(PosCISlantGaborsSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSlantGabors,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSlantGabors,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCIFlatSolidPolySPN',fliplr(PosCIFlatSolidPolySPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffFlatSolidPoly,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNFlatSolidPoly,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black');
patch([timeVector,fliplr(timeVector)],[NegCISlantSolidPolySPN',fliplr(PosCISlantSolidPolySPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSlantSolidPoly,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSlantSolidPoly,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
