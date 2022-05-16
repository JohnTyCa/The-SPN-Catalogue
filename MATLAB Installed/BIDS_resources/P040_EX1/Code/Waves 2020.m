% clear all
% close all
% 
% % DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
% cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 40/EX1 Crowding HV/Grand Averages'
% load timeVector;
% load grandAverages;
% 
% % CONDITIONS
% conditionNames={'TargetSym','TargetRand','SymFlankerV','RandFlankerV','SymFlankerH','RandFlankerH','TargetSymL','TargetRandL','SymFlankerVL','RandFlankerVL','SymFlankerHL','RandFlankerHL','TargetSymR','TargetRandR','SymFlankerVR','RandFlankerVR','SymFlankerHR','RandFlankerHR'};
% 
% %ELECTRODES
% %electrodes = [20 21 22 23 25 26 57 58 59 60 62 63]; 
% 
% %electrodes = [20 21 22 23 25 26];
% %electrodes = [57 58 59 60 62 63]; 
% 
% %electrodes = [25 62]
% %DO YOU WANT TO SMOOTH THE ERP WAVES? . 
% smoothfactor = 5;
% smoothOn = 'on';
% 
% %GRAPHICAL PROPERTIES
% FontSize = 28;
% LineWidth = 4;
% set(0,'DefaultAxesFontSize', FontSize);
% 
% % SELECT DATA LOOP
% for x = 1:length(conditionNames)
%     c = conditionNames{x};
%     data = getfield(grandAverages, c);
%     data = mean(data(electrodes,1:end),1)';
%     if strcmp(smoothOn, 'on') == 1;
%         data = smooth(data,smoothfactor,'moving'); % take this off when doing individuals in background plot.
%     end
%     selectedData.(c).data = data;
% end

%save('thisPlot','selectedData');
% 
% TargetSym= selectedData.TargetSym.data;
% TargetRand = selectedData.TargetRand.data;
% SymFlankerH= selectedData.SymFlankerH.data;
% SymFlankerV = selectedData.SymFlankerV.data;
% RandFlankerH= selectedData.RandFlankerH.data;
% RandFlankerV = selectedData.RandFlankerV.data;
% DiffTargetSym= TargetSym - TargetRand;
% DiffSymFlankerH= SymFlankerH - RandFlankerH;
% DiffSymFlankerV= SymFlankerV - RandFlankerV;
% 
% TargetSymL= selectedData.TargetSymL.data;
% TargetRandL = selectedData.TargetRandL.data;
% SymFlankerHL= selectedData.SymFlankerHL.data;
% SymFlankerVL = selectedData.SymFlankerVL.data;
% RandFlankerHL= selectedData.RandFlankerHL.data;
% RandFlankerVL = selectedData.RandFlankerVL.data;
% DiffTargetSymL= TargetSymL - TargetRandL;
% DiffSymFlankerHL= SymFlankerHL - RandFlankerHL;
% DiffSymFlankerVL= SymFlankerVL - RandFlankerVL;
% 
% TargetSymR= selectedData.TargetSymR.data;
% TargetRandR = selectedData.TargetRandR.data;
% SymFlankerHR= selectedData.SymFlankerHR.data;
% SymFlankerVR = selectedData.SymFlankerVR.data;
% RandFlankerHR= selectedData.RandFlankerHR.data;
% RandFlankerVR = selectedData.RandFlankerVR.data;
% DiffTargetSymR= TargetSymR - TargetRandR;
% DiffSymFlankerHR= SymFlankerHR - RandFlankerHR;
% DiffSymFlankerVR= SymFlankerVR - RandFlankerVR;
% 
% Zeroline = zeros(length(timeVector),1);
% 
% 
% % For bilateral
% 
% % FIGURE 1
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','-','-'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],[0.5 0.5 0.5],[0.25 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [TargetSym,TargetRand,SymFlankerV,RandFlankerV,SymFlankerH,RandFlankerH],'LineWidth',LineWidth);
% axis([-200 1000 -1 6]);
% set(gca,'YTick',-1:1:6);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on');
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Rand Solo','Ref Vertical Flankers','Rand Vertical Flankers','Ref Horizontal Flankers','Rand Horizontal Flankers'},'FontSize',FontSize,'Location','south');
% xlabel('Time from stimulus onset (ms)');
% ylabel('Amplitude (microvolts)');
% grid('on')
% legend('boxoff')
% 
% 
% 
% 
% % FIGURE 2
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','--'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 1 0],[0 0 0],[0 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [DiffTargetSym,DiffSymFlankerV,DiffSymFlankerH,Zeroline],'LineWidth',LineWidth);
% axis([-200 1000 -2 2]);
% set(gca,'YTick',-2:1:2,'YTickLabels',[]);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Ref Vertical Flankers','Ref Horizontal Flankers'},'FontSize',FontSize,'Location','southeast');
% xlabel('Time from stimulus onset (ms)','color','w');
% ylabel('SPN amplitude (microvolts)','color','w');
% grid('on')
% legend('boxoff')
% 
% 
% 
% 
% 
% 
% % For Left brain SPNS
% close all
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','-','-'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],[0.5 0.5 0.5],[0.25 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [TargetSymR,TargetRandR,SymFlankerVR,RandFlankerVR,SymFlankerHR,RandFlankerHR],'LineWidth',LineWidth);
% axis([-200 1000 -1 6]);
% set(gca,'YTick',-1:1:6);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on');
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Rand Solo','Ref Vertical Flankers','Rand Vertical Flankers','Ref Horizontal Flankers','Rand Horizontal Flankers'},'FontSize',FontSize,'Location','south');
% xlabel('Time from stimulus onset (ms)');
% ylabel('Amplitude (microvolts)');
% grid('on')
% legend('boxoff')
% 
% % FIGURE 2
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','--'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 1 0],[0 0 0],[0 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [DiffTargetSymR,DiffSymFlankerVR,DiffSymFlankerHR,Zeroline],'LineWidth',LineWidth);
% axis([-200 1000 -2 2]);
% set(gca,'YTick',-2:1:2,'YTickLabels',[]);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Ref Vertical Flankers','Ref Horizontal Flankers'},'FontSize',FontSize,'Location','southeast');
% xlabel('Time from stimulus onset (ms)','color','w');
% ylabel('SPN amplitude (microvolts)','color','w');
% grid('on')
% legend('boxoff')
% 
% 
% % For Right brain SPNS
% %close all
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','-','-'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],[0.5 0.5 0.5],[0.25 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [TargetSymL,TargetRandL,SymFlankerVL,RandFlankerVL,SymFlankerHL,RandFlankerHL],'LineWidth',LineWidth);
% axis([-200 1000 -1 6]);
% set(gca,'YTick',-1:1:6);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on');
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Rand Solo','Ref Vertical Flankers','Rand Vertical Flankers','Ref Horizontal Flankers','Rand Horizontal Flankers'},'FontSize',FontSize,'Location','south');
% xlabel('Time from stimulus onset (ms)');
% ylabel('Amplitude (microvolts)');
% grid('on')
% legend('boxoff')
% 
% % FIGURE 2
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','--'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 1 0],[0 0 0],[0 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [DiffTargetSymL,DiffSymFlankerVL,DiffSymFlankerHL,Zeroline],'LineWidth',LineWidth);
% axis([-200 1000 -2 2]);
% set(gca,'YTick',-2:1:2,'YTickLabels',[]);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Ref Vertical Flankers','Ref Horizontal Flankers'},'FontSize',FontSize,'Location','southeast');
% xlabel('Time from stimulus onset (ms)','color','w');
% ylabel('SPN amplitude (microvolts)','color','w');
% grid('on')
% legend('boxoff')
% 
% 
% 
% 
% 
% 
% 
% 
% 



% For contralateral responses
clear all
close all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 40/EX1 Crowding HV/Grand Averages'
load timeVector;
load grandAverages;

% CONDITIONS
conditionNames={'TargetSym','TargetRand','SymFlankerV','RandFlankerV','SymFlankerH','RandFlankerH','TargetSymL','TargetRandL','SymFlankerVL','RandFlankerVL','SymFlankerHL','RandFlankerHL','TargetSymR','TargetRandR','SymFlankerVR','RandFlankerVR','SymFlankerHR','RandFlankerHR'};

electrodes = [23 24 25 27];

%electrodes = [25 62]
%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'on';

%GRAPHICAL PROPERTIES
FontSize = 28;
LineWidth = 3;
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

TargetSymR= selectedData.TargetSymR.data;
TargetRandR = selectedData.TargetRandR.data;
SymFlankerHR= selectedData.SymFlankerHR.data;
SymFlankerVR = selectedData.SymFlankerVR.data;
RandFlankerHR= selectedData.RandFlankerHR.data;
RandFlankerVR = selectedData.RandFlankerVR.data;


electrodes = [60 61 62 64]; 

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

TargetSymL= selectedData.TargetSymL.data;
TargetRandL = selectedData.TargetRandL.data;
SymFlankerHL= selectedData.SymFlankerHL.data;
SymFlankerVL = selectedData.SymFlankerVL.data;
RandFlankerHL= selectedData.RandFlankerHL.data;
RandFlankerVL = selectedData.RandFlankerVL.data;


TargetSymCont = (TargetSymL+TargetSymR)/2;
TargetRandCont = (TargetRandL+TargetRandR)/2;
SymFlankerHCont = (SymFlankerHL+SymFlankerHR)/2;
SymFlankerVCont = (SymFlankerVL+SymFlankerVR)/2;
RandFlankerHCont = (RandFlankerHL+RandFlankerHR)/2;
RandFlankerVCont = (RandFlankerVL+RandFlankerVR)/2;

DiffTargetCont = TargetSymCont-TargetRandCont;
DiffFlankerHCont = SymFlankerHCont - RandFlankerHCont;
DiffFlankerVCont = SymFlankerVCont - RandFlankerVCont;

Zeroline = zeros(length(timeVector),1);
% % FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0.5 0 0],[0 1 0],[0 0.5 0],[0 0 1],[0 0 0.5]}';
figure('color',[1,1,1])
P = plot(timeVector, [TargetSymCont,TargetRandCont,SymFlankerVCont,RandFlankerVCont,SymFlankerHCont,RandFlankerHCont],'LineWidth',LineWidth);
axis([-200 1000 -2 8]);
set(gca,'YTick',-2:2:8);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Ref None','Rand None','Ref Vertical','Rand Vertical','Ref Horizontal','Rand Horizontal'},'FontSize',16,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0 0 1],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffTargetCont,DiffFlankerVCont,DiffFlankerHCont,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -3 1]);
set(gca,'YTick',-3:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'None','Vertical','Horizontal'},'FontSize',FontSize,'Location','southwest');
%xlabel('Time from stimulus onset (ms)','color','w');
xlabel('Time from stimulus onset (ms)');
%ylabel('SPN amplitude (microvolts)','color','w');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')




% 
% 
% 
% % For ipsilateral responses
% clear all
% 
% 
% % DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
% cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 40/EX1 Crowding HV/Grand Averages'
% load timeVector;
% load grandAverages;
% 
% % CONDITIONS
% conditionNames={'TargetSym','TargetRand','SymFlankerV','RandFlankerV','SymFlankerH','RandFlankerH','TargetSymL','TargetRandL','SymFlankerVL','RandFlankerVL','SymFlankerHL','RandFlankerHL','TargetSymR','TargetRandR','SymFlankerVR','RandFlankerVR','SymFlankerHR','RandFlankerHR'};
% 
% 
% electrodes = [57 58 59 60 62 63]; 
% %electrodes = [25 62]
% %DO YOU WANT TO SMOOTH THE ERP WAVES? . 
% smoothfactor = 5;
% smoothOn = 'on';
% 
% %GRAPHICAL PROPERTIES
% FontSize = 28;
% LineWidth = 4;
% set(0,'DefaultAxesFontSize', FontSize);
% 
% % SELECT DATA LOOP
% for x = 1:length(conditionNames)
%     c = conditionNames{x};
%     data = getfield(grandAverages, c);
%     data = mean(data(electrodes,1:end),1)';
%     if strcmp(smoothOn, 'on') == 1;
%         data = smooth(data,smoothfactor,'moving'); % take this off when doing individuals in background plot.
%     end
%     selectedData.(c).data = data;
% end
% 
% %save('thisPlot','selectedData');
% 
% TargetSymR= selectedData.TargetSymR.data;
% TargetRandR = selectedData.TargetRandR.data;
% SymFlankerHR= selectedData.SymFlankerHR.data;
% SymFlankerVR = selectedData.SymFlankerVR.data;
% RandFlankerHR= selectedData.RandFlankerHR.data;
% RandFlankerVR = selectedData.RandFlankerVR.data;
% 
% 
% electrodes = [20 21 22 23 25 26];
% 
% %electrodes = [25 62]
% %DO YOU WANT TO SMOOTH THE ERP WAVES? . 
% smoothfactor = 10;
% smoothOn = 'on'
% 
% %GRAPHICAL PROPERTIES
% FontSize = 28;
% LineWidth = 4;
% set(0,'DefaultAxesFontSize', FontSize);
% 
% % SELECT DATA LOOP
% for x = 1:length(conditionNames)
%     c = conditionNames{x};
%     data = getfield(grandAverages, c);
%     data = mean(data(electrodes,1:end),1)';
%     if strcmp(smoothOn, 'on') == 1;
%         data = smooth(data,smoothfactor,'moving'); % take this off when doing individuals in background plot.
%     end
%     selectedData.(c).data = data;
% end
% 
% TargetSymL= selectedData.TargetSymL.data;
% TargetRandL = selectedData.TargetRandL.data;
% SymFlankerHL= selectedData.SymFlankerHL.data;
% SymFlankerVL = selectedData.SymFlankerVL.data;
% RandFlankerHL= selectedData.RandFlankerHL.data;
% RandFlankerVL = selectedData.RandFlankerVL.data;
% 
% 
% TargetSymCont = (TargetSymL+TargetSymR)/2;
% TargetRandCont = (TargetRandL+TargetRandR)/2;
% SymFlankerHCont = (SymFlankerHL+SymFlankerHR)/2;
% SymFlankerVCont = (SymFlankerVL+SymFlankerVR)/2;
% RandFlankerHCont = (RandFlankerHL+RandFlankerHR)/2;
% RandFlankerVCont = (RandFlankerVL+RandFlankerVR)/2;
% 
% DiffTargetCont = TargetSymCont-TargetRandCont;
% DiffFlankerHCont = SymFlankerHCont - RandFlankerHCont;
% DiffFlankerVCont = SymFlankerVCont - RandFlankerVCont;
% 
% Zeroline = zeros(length(timeVector),1);
% % % FIGURE 1
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','-','-'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],[0.5 0.5 0.5],[0.25 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [TargetSymCont,TargetRandCont,SymFlankerVCont,RandFlankerVCont,SymFlankerHCont,RandFlankerHCont],'LineWidth',LineWidth);
% axis([-200 1000 -1 6]);
% set(gca,'YTick',-1:1:6);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on');
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Rand Solo','Ref Vertical Flankers','Rand Vertical Flankers','Ref Horizontal Flankers','Rand Horizontal Flankers'},'FontSize',FontSize,'Location','south');
% xlabel('Time from stimulus onset (ms)');
% ylabel('Amplitude (microvolts)');
% grid('on')
% legend('boxoff')
% 
% % 
% % 
% % 
% % FIGURE 2
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','--'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 1 0],[0 0 0],[0 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [DiffTargetCont,DiffFlankerVCont,DiffFlankerHCont,Zeroline],'LineWidth',LineWidth);
% axis([-200 1000 -2 2]);
% set(gca,'YTick',-2:1:2,'YTickLabels',[]);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Ref Vertical Flankers','Ref Horizontal Flankers'},'FontSize',FontSize,'Location','southeast');
% xlabel('Time from stimulus onset (ms)','color','w');
% ylabel('SPN amplitude (microvolts)','color','w');
% grid('on')
% legend('boxoff')