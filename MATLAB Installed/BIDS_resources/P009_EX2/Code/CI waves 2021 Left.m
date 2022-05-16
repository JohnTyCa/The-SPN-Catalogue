close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX2 One Sided/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerrorLeft;

%CONDITIONS
conditionNames={'NOTHINGREF','NOTHINGRAND'};


%ELECTRODES
electrodes = [20 21 22 23 25 26]; % Left


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

NOTHINGREF= selectedData.NOTHINGREF.data;
NOTHINGRAND = selectedData.NOTHINGRAND.data;
DiffLeftHem= NOTHINGREF - NOTHINGRAND;
Zeroline = zeros(length(timeVector),1);

NOTHINGREFIndividuals = ERPerrorLeft.NOTHINGREF.amplitudes;
NOTHINGRANDIndividuals = ERPerrorLeft.NOTHINGRAND.amplitudes;


%Figure 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [NOTHINGRAND, NOTHINGREF],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000);
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'NOTHINGRAND', 'NOTHINGREF'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on 
% plot(timeVector, RANDREFIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,REFRANDIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')




%FIGURE 2
lowEarly = 200
highEarly = 600
ii = find(timeVector >=lowEarly & timeVector <=highEarly);
MSPNearly = mean(DiffLeftHem(ii));
lowLate = 600
highLate = 1000
ii = find(timeVector >=lowLate & timeVector <=highLate);
MSPNlate = mean(DiffLeftHem(ii));
MSPN = [MSPNearly,MSPNlate]
MSPN =  mean(MSPN)
SPNcheckLeft = MSPN

save('SPNcheckLeft','SPNcheckLeft');

CISPN = ERPerrorLeft.SPNLeft.CI;


if strcmp(smoothOn, 'on') == 1;
    CISPN = smooth(CISPN,smoothfactor,'moving');
end

PosCISPN= DiffLeftHem+CISPN;
NegCISPN= DiffLeftHem-CISPN;


figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[lowEarly, -5,highEarly-lowEarly,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
rectangle('position',[lowLate, -5,highLate-lowLate,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISPN',fliplr(PosCISPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffLeftHem,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPN,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
