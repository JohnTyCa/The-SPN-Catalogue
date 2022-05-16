clear all
close all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 4/EX1 Reg or Valence (first 24)/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames = {'RandomGoodValence','RandomBadValence','ReflectionGoodValence','ReflectionBadValence','RandomGoodRegularity','RandomBadRegularity','ReflectionGoodRegularity','ReflectionBadRegularity'};

%ELECTRODES
electrodes = [22 23 24 25 59 60 61 62]; % Left and right (Scott et al., 2009)


%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 10;
smoothOn = 'off';

%GRAPHICAL PROPERTIES
FontSize = 28;
LineWidth = 4;
set(0,'DefaultAxesFontSize', FontSize);

% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = mean(data(electrodes,1:end),1)';
    if strcmp(smoothOn, 'on') == 1;
        data = smooth(data,smoothfactor,'moving'); 
    end
    selectedData.(c).data = data;
end

%save('thisPlot','selectedData');

%use this to plot ERPs
RandomGoodValence= selectedData.RandomGoodValence.data;
RandomBadValence = selectedData.RandomBadValence.data;
ReflectionGoodValence= selectedData.ReflectionGoodValence.data;
ReflectionBadValence = selectedData.ReflectionBadValence.data;
RandomGoodRegularity= selectedData.RandomGoodRegularity.data;
RandomBadRegularity = selectedData.RandomBadRegularity.data;
ReflectionGoodRegularity= selectedData.ReflectionGoodRegularity.data;
ReflectionBadRegularity = selectedData.ReflectionBadRegularity.data;

DiffGoodValence = ReflectionGoodValence - RandomGoodValence;
DiffBadValence = ReflectionBadValence - RandomBadValence;
DiffGoodRegularity = ReflectionGoodRegularity - RandomGoodRegularity;
DiffBadRegularity = ReflectionBadRegularity - RandomBadRegularity;
Zeroline = zeros(length(timeVector),1);





%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0.5 0 0],[0 1 0],[0 0.5 0],[0 0 1],[0 0 0.5],[0 1 1],[0 0.5 0.5]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandomGoodValence,RandomBadValence,ReflectionGoodValence,ReflectionBadValence,RandomGoodRegularity,RandomBadRegularity,ReflectionGoodRegularity,ReflectionBadRegularity],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandomGoodValence','RandomBadValence','ReflectionGoodValence','ReflectionBadValence','RandomGoodRegularity','RandomBadRegularity','ReflectionGoodRegularity','ReflectionBadRegularity'},'FontSize',16,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')



%Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 1 0],[0 0.5 0],[1 0 0],[0.5 0 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffGoodValence,DiffBadValence,DiffGoodRegularity,DiffBadRegularity,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'GoodValence','BadValence','GoodRegularity','BadRegularity'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')
