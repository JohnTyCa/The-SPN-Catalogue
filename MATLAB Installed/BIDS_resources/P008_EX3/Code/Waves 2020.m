clear all
close all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER);
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders/Project 8/EX3 Naxes/Grand Averages'
load timeVector;
load grandAverages;


%CONDITIONS
conditionNames = {'Rand' 'Ref1', 'Ref2', 'Ref3', 'Ref4', 'Ref5'};

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
        data = smooth(data,smoothfactor,'moving'); % take this off when doing individuals in background plot.
    end
    selectedData.(c).data = data;
end

%save('thisPlot','selectedData');


Rand= selectedData.Rand.data;
Ref1 = selectedData.Ref1.data;
Ref2 = selectedData.Ref2.data;
Ref3 = selectedData.Ref3.data;
Ref4 = selectedData.Ref4.data;
Ref5 = selectedData.Ref5.data;
DiffRef1= Ref1 - Rand;
DiffRef2= Ref2 - Rand;
DiffRef3= Ref3 - Rand;
DiffRef4= Ref4 - Rand;
DiffRef5= Ref5 - Rand;
Zeroline = zeros(length(timeVector),1);





%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[0 0.5 1],[0.3 1 0.7],[0.5 1 0.5],[0.7 0.5 0.3],[1 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [Rand,Ref1,Ref2,Ref3,Ref4,Ref5],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','1F','2F','3F','4F','5F'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')




%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0.5 1],[0.3 1 0.7],[0.5 1 0.5],[0.7 0.5 0.3],[1 0 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffRef1,DiffRef2,DiffRef3,DiffRef4,DiffRef5,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabel',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabel',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'1F','2F','3F','4F','5F'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')

