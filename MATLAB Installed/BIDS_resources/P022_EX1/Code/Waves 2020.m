close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 22/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'AS20','S20','Rand20','AS40','S40','Rand40','AS80','S80','Rand80'};

%ELECTRODES
electrodes = [25 62];



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


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'--','--','--','-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[0.25 0.25 0.25],[0.5 0.5 0.5],[1 0 0],[0.6 0 0],[0.2 0 0],[0 0 1],[0 0 0.6],[0 0 0.2]}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [Rand20, Rand40, Rand80, AS20, AS40, AS80, S20, S40, S80],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand20','Rand40','Rand80','AS20','AS40','AS80','S20','S40','S80'},'FontSize',12,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0.75 0 0],[0.5 0 0],[0 0 1],[0 0 0.75],[0 0 0.5],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffAS20, DiffAS40, DiffAS80, DiffS20, DiffS40, DiffS80,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'AS20','AS40','AS80','S20','S40','S80'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')


