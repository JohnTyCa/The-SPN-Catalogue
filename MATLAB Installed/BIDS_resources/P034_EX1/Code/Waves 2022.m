close all
clear all
% you will need to set this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 34/Grand Averages'
load timeVector;
load grandAverages;

%CONDITIONS
conditionNames ={'rrs','rro','rno','nrs','nro','nno'}; 

%ELECTRODES
electrodes = [25 27 62 64];

%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'on';

%GRAPHICAL PROPERTIES
FontSize = 24;
LineWidth = 3;
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


rrs= selectedData.rrs.data;
rro = selectedData.rro.data;
rno = selectedData.rno.data;
nrs = selectedData.nrs.data;
nro= selectedData.nro.data;
nno = selectedData.nno.data;

Diffrrs= rrs - nno;
Diffrro= rro - nno;
Diffrno= rno - nno;
Diffnrs= nrs - nno;
Diffnro= nro - nno;


Zeroline = zeros(length(timeVector),1);




%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'--','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[0 0 0],[0.5 0.5 0.5],[0 1 0],[0 0.8 0.8],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [nno nro nrs rno rro rrs],'LineWidth',LineWidth);
axis([-200 1000 -3 3]);
set(gca,'YTick',-3:1:3);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand (Rand)', 'Rand (RefH)', 'Rand (RefV)','RefV (Rand)','RefV (RefH)','RefV (RefV)'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')

%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 0],[0.5 0.5 0.5],[0 1 0],[0 0.8 0.8],[0 0 1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [Diffnro Diffnrs Diffrno Diffrro Diffrrs, Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -3 1]);
set(gca,'YTick',-3:1:1);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand (RefH)', 'Rand (RefV)','RefV (Rand)','RefV (RefH)','RefV (RefV)'},'FontSize',FontSize,'Location','southwest');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')

