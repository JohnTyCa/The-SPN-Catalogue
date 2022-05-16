close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 21/Grand Averages';
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'RandRandRand','GlassGlassGlass','RefRefRef','RefGlassRef','GlassRefGlass','Consistent','Changing'};

%ELECTRODES
electrodes = [25 27 62 64];


%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 10;
smoothOn = 'on';

%GRAPHICAL PROPERTIES
FontSize = 28;
LineWidth = 4;
set(0,'DefaultAxesFontSize', FontSize);
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

RandRandRand = selectedData.RandRandRand.data;
Consistent = selectedData.Consistent.data;
Changing = selectedData.Changing.data;
GlassGlassGlass = selectedData.GlassGlassGlass.data;
RefRefRef = selectedData.RefRefRef.data;
RefGlassRef = selectedData.RefGlassRef.data;
GlassRefGlass = selectedData.GlassRefGlass.data;
DiffConsistent = Consistent-RandRandRand;
DiffChanging = Changing-RandRandRand;
DiffRefRefRef = RefRefRef - RandRandRand;
DiffGlassGlassGlass = GlassGlassGlass - RandRandRand;
DiffRefGlassRef = RefGlassRef - RandRandRand;
DiffGlassRefGlass = GlassRefGlass - RandRandRand;
Zeroline = zeros(length(timeVector),1);

%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0.8 0.8 0],[0 1 0],[0 0.8 0.8]}';
close all
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand,RefRefRef,GlassGlassGlass,RefGlassRef,GlassRefGlass],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Randoms','RefRefRef','GlassGlassGlass','RefGlassRef','GlassRefGlass'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')



%Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0.8 0.8 0],[0 1 0],[0 0.8 0.8],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffRefRefRef,DiffGlassGlassGlass,DiffRefGlassRef,DiffGlassRefGlass,Zeroline],'LineWidth',LineWidth);
axis([-200 2100 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',0:500:2000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RefRefRef','GlassGlassGlass','RefGlassRef','GlassRefGlass'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')




