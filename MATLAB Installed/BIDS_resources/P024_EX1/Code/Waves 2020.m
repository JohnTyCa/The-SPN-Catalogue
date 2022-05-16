close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V7/Project 24/Grand Averages'
load timeVector;
load grandAverages;


%CONDITIONS
conditionNames={'LCRandRand','RCRandRand','LCRandSymm','RCRandSymm','LCSymmRand','RCSymmRand'};


%ELECTRODES
%electrodes = [23 25 26 27]; %P7 PO3 PO7 O1 left electrodes
electrodes = [60 62 63 64]; %P8 PO4 PO8 O2 right electrodes


%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 10;
smoothOn = 'on';

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

%save('thisPlot','data');
LCRandRand=selectedData.LCRandRand.data;
RCRandRand=selectedData.RCRandRand.data;
LCRandSymm= selectedData.LCRandSymm.data;
RCRandSymm=selectedData.RCRandSymm.data;
LCSymmRand= selectedData.LCSymmRand.data;
RCSymmRand=selectedData.RCSymmRand.data;
DiffLCRandSymm = LCRandSymm-LCRandRand;
DiffRCRandSymm = RCRandSymm-RCRandRand;
DiffLCSymmRand = LCSymmRand-LCRandRand;
DiffRCSymmRand = RCSymmRand-RCRandRand;
Zeroline = zeros(length(timeVector),1);


%Both sides
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1], [0 0 0.7], [1 0 0], [0.6 0 0],[0 1 0],[0 0.6 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [LCRandRand,RCRandRand,LCRandSymm,RCRandSymm,LCSymmRand,RCSymmRand],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand < Rand', 'Rand > Rand', 'Rand < Symm','Rand > Symm', 'Symm < Rand','Symm > Rand'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%left electrodes for this
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1], [0 0 0.7], [1 0 0], [0.6 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [LCRandRand,RCRandRand,LCRandSymm,RCRandSymm],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand < Rand', 'Rand > Rand', 'Rand < Symm','Rand > Symm'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffLCRandSymm,DiffRCRandSymm,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand < Symm','Rand > Symm'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')




%right electrodes for this
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1], [0 0 0.7], [0 1 0],[0.59 0.29 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [LCRandRand,RCRandRand,LCSymmRand,RCSymmRand],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand < Rand', 'Rand > Rand', 'Symm < Rand','Symm > Rand'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 1 0],[0.59 0.29 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffRCSymmRand,DiffLCSymmRand,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Symm > Rand','Symm < Rand'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')
clear all