close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders/Project 27/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames = {'Random','Glass', 'Reflection','Translation'};

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


Random= selectedData.Random.data;
Reflection = selectedData.Reflection.data;
Glass = selectedData.Glass.data;
Translation = selectedData.Translation.data;
DiffGlass= Glass - Random;
DiffReflection= Reflection - Random;
DiffTranslation= Translation - Random;
Zeroline = zeros(length(timeVector),1);


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0.5 0.5 0.5],[0 0 1],[0 1 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [Random, Glass, Reflection, Translation],'LineWidth',LineWidth);
axis([-1000 2000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-1000:500:2000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Glass','Reflection','Translation'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


%Figure 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0 1 0],[0 0 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffGlass,DiffReflection,DiffTranslation,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -4 1]);
set(gca,'YTick',-4:1:1,'YTickLabels',[]);
set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Glass','Reflection','Translation'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)','color','w');
ylabel('SPN amplitude (microvolts)','color','w');
grid('on')
legend('boxoff')

