close all
clear all

% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders/Project 38/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames={'REFdownRANDup','RANDdownREFup','REFdownREFupREFdown','REFupREFdownREFup','RandRandRand','Oddball'};

%ELECTRODES
electrodes = [25 27 62 64]; % Which electrodes do you want? 

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

%save('thisPlot','selectedData');

%use this to plot ERPs
RandRandRand = selectedData.RandRandRand.data;
REFdownRANDup = selectedData.REFdownRANDup.data;
RANDdownREFup = selectedData.RANDdownREFup.data;
REFdownREFupREFdown = selectedData.REFdownREFupREFdown.data;
REFupREFdownREFup= selectedData.REFupREFdownREFup.data;
DiffREFdownRANDup = REFdownRANDup - RandRandRand;
DiffRANDdownREFup  = RANDdownREFup  - RandRandRand;
DiffREFdownREFupREFdown = REFdownREFupREFdown - RandRandRand;
DiffREFupREFdownREFup = REFupREFdownREFup - RandRandRand;
Zeroline = zeros(length(timeVector),1);


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[1 0 0],[0 1 0],[0 0 1],[0 1 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [RandRandRand, REFdownRANDup, RANDdownREFup,REFdownREFupREFdown,REFupREFdownREFup],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'RandRandRand','REFdownRANDup','RANDdownREFup','REFdownREFupREFdown','REFupREFdownREFup'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0 0 1],[0 1 1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffREFdownRANDup DiffRANDdownREFup DiffREFdownREFupREFdown,DiffREFupREFdownREFup,Zeroline],'LineWidth',LineWidth);
axis([-200 2100 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',0:500:2000,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'REFdownRANDup','RANDdownREFup','REFdownREFupREFdown','REFupREFdownREFup'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')
clear all