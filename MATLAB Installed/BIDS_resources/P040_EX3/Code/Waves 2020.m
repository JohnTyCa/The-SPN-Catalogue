% clear all
% close all
% 
% % DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
% cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 40/EX3 Crowding BW/Grand Averages'
% load timeVector;
% load grandAverages;
% 
% %CONDITIONS
% conditionNames={'TargetSym','TargetRand','SymFlankerS','SymFlankerR','RandFlankerS','RandFlankerR','TargetSymLeft','TargetRandLeft','SymFlankerSLeft','SymFlankerRLeft','RandFlankerSLeft','RandFlankerRLeft','TargetSymRight','TargetRandRight','SymFlankerSRight','SymFlankerRRight','RandFlankerSRight','RandFlankerRRight'};
% 
% %ELECTRODES
% electrodes = [20 21 22 23 25 26 57 58 59 60 62 63]; 
% 
% %electrodes = [20 21 22 23 25 26];
% %electrodes = [57 58 59 60 62 63]; 
% 
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
% TargetSym= selectedData.TargetSym.data;
% TargetRand = selectedData.TargetRand.data;
% SymFlankerS= selectedData.SymFlankerS.data;
% SymFlankerR = selectedData.SymFlankerR.data;
% RandFlankerS= selectedData.RandFlankerS.data;
% RandFlankerR = selectedData.RandFlankerR.data;
% DiffTargetSym= TargetSym - TargetRand;
% DiffSymFlankerS= SymFlankerS - RandFlankerR; % These can all be compared with Rand Flanker Rand
% DiffSymFlankerR= SymFlankerR - RandFlankerR; % These can all be compared with Rand Flanker Rand
% DiffRandFlankerS=RandFlankerS - RandFlankerR; % These can all be compared with Rand Flanker Rand
% 
% 
% TargetSymLeft= selectedData.TargetSymLeft.data;
% TargetRandLeft = selectedData.TargetRandLeft.data;
% SymFlankerSLeft= selectedData.SymFlankerSLeft.data;
% SymFlankerRLeft = selectedData.SymFlankerRLeft.data;
% RandFlankerSLeft= selectedData.RandFlankerSLeft.data;
% RandFlankerRLeft = selectedData.RandFlankerRLeft.data;
% DiffTargetSymLeft= TargetSymLeft - TargetRandLeft;
% DiffSymFlankerSLeft= SymFlankerSLeft - RandFlankerRLeft; % These can all be compared with Rand Flanker Rand
% DiffSymFlankerRLeft= SymFlankerRLeft - RandFlankerRLeft; % These can all be compared with Rand Flanker Rand
% DiffRandFlankerSLeft=RandFlankerSLeft - RandFlankerRLeft; % These can all be compared with Rand Flanker Rand
% 
% TargetSymRight= selectedData.TargetSymRight.data;
% TargetRandRight = selectedData.TargetRandRight.data;
% SymFlankerSRight= selectedData.SymFlankerSRight.data;
% SymFlankerRRight = selectedData.SymFlankerRRight.data;
% RandFlankerSRight= selectedData.RandFlankerSRight.data;
% RandFlankerRRight = selectedData.RandFlankerRRight.data;
% DiffTargetSymRight= TargetSymRight - TargetRandRight;
% DiffSymFlankerSRight= SymFlankerSRight - RandFlankerRRight; % These can all be compared with Rand Flanker Rand
% DiffSymFlankerRRight= SymFlankerRRight - RandFlankerRRight; % These can all be compared with Rand Flanker Rand
% DiffRandFlankerSRight=RandFlankerSRight - RandFlankerRRight; % These can all be compared with Rand Flanker Rand
% 
% 
% 
% Zeroline = zeros(length(timeVector),1);
% 
% % for bilateral SPNs
% 
% % % FIGURE 1
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','-','-'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],[0.5 0.5 0.5],[0.25 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [TargetSym,TargetRand,SymFlankerS,SymFlankerR,RandFlankerS,RandFlankerR],'LineWidth',LineWidth);
% axis([-200 1000 -1 6]);
% set(gca,'YTick',-1:1:6);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on');
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Rand Solo','Ref (Flankers Ref)','Ref (Flankers Rand)','Rand (Flankers Ref)','Rand (Flanker Rand)'},'FontSize',FontSize,'Location','south');
% xlabel('Time from stimulus onset (ms)');
% ylabel('Amplitude (microvolts)');
% grid('on')
% legend('boxoff')
% 
% 
% % FIGURE 2
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','--'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 1 0],[0 0 1],[0.8 0.8 0],[0 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [DiffTargetSym,DiffSymFlankerS,DiffSymFlankerR,DiffRandFlankerS,Zeroline],'LineWidth',LineWidth);
% axis([-200 1000 -2 2]);
% set(gca,'YTick',-2:1:2,'YTickLabels',[]);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Ref (Flankers Ref)','Ref (Flankers Rand)','Rand (Flankers Ref)'},'FontSize',FontSize,'Location','southeast');
% xlabel('Time from stimulus onset (ms)');
% ylabel('SPN amplitude (microvolts)');
% grid('on')
% legend('boxoff')
% 
% 
% % % For Left brain SPNS
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','-','-'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],[0.5 0.5 0.5],[0.25 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [TargetSymRight,TargetRandRight,SymFlankerSRight,SymFlankerRRight,RandFlankerSRight,RandFlankerRRight],'LineWidth',LineWidth);
% axis([-200 1000 -1 6]);
% set(gca,'YTick',-1:1:6);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on');
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Rand Solo','Ref (Flankers Ref)','Ref (Flankers Rand)','Rand (Flankers Ref)','Rand (Flanker Rand)'},'FontSize',FontSize,'Location','south');
% xlabel('Time from stimulus onset (ms)');
% ylabel('Amplitude (microvolts)');
% grid('on')
% legend('boxoff')
% 
% 
% % FIGURE 2
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','--'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 1 0],[0 0 1],[0.8 0.8 0],[0 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [DiffTargetSymRight,DiffSymFlankerSRight,DiffSymFlankerRRight,DiffRandFlankerSRight,Zeroline],'LineWidth',LineWidth);
% axis([-200 1000 -2 2]);
% set(gca,'YTick',-2:1:2,'YTickLabels',[]);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Ref (Flankers Ref)','Ref (Flankers Rand)','Rand (Flankers Ref)'},'FontSize',FontSize,'Location','southeast');
% xlabel('Time from stimulus onset (ms)','color','w');
% ylabel('SPN amplitude (microvolts)','color','w');
% grid('on')
% legend('boxoff')
% 
% 
% 
% 
% % % For Right brain SPNS
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','-','-'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],[0.5 0.5 0.5],[0.25 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [TargetSymLeft,TargetRandLeft,SymFlankerSLeft,SymFlankerRLeft,RandFlankerSLeft,RandFlankerRLeft],'LineWidth',LineWidth);
% axis([-200 1000 -1 6]);
% set(gca,'YTick',-1:1:6);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on');
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Rand Solo','Ref (Flankers Ref)','Ref (Flankers Rand)','Rand (Flankers Ref)','Rand (Flanker Rand)'},'FontSize',FontSize,'Location','south');
% xlabel('Time from stimulus onset (ms)');
% ylabel('Amplitude (microvolts)');
% grid('on')
% legend('boxoff')
% 
% 
% % FIGURE 2
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','--'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 1 0],[0 0 1],[0.8 0.8 0],[0 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [DiffTargetSymLeft,DiffSymFlankerSLeft,DiffSymFlankerRLeft,DiffRandFlankerSRight,Zeroline],'LineWidth',LineWidth);
% axis([-200 1000 -2 2]);
% set(gca,'YTick',-2:1:2,'YTickLabels',[]);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Ref (Flankers Ref)','Ref (Flankers Rand)','Rand (Flankers Ref)'},'FontSize',FontSize,'Location','southeast');
% xlabel('Time from stimulus onset (ms)','color','w');
% ylabel('SPN amplitude (microvolts)','color','w');
% grid('on')
% legend('boxoff')
% 
% 
% 
% 



% For contralateral responses
clear all
close all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 40/EX3 Crowding BW/Grand Averages'
load timeVector;
load grandAverages;

% CONDITIONS
conditionNames={'TargetSym','TargetRand','SymFlankerS','SymFlankerR','RandFlankerS','RandFlankerR','TargetSymLeft','TargetRandLeft','SymFlankerSLeft','SymFlankerRLeft','RandFlankerSLeft','RandFlankerRLeft','TargetSymRight','TargetRandRight','SymFlankerSRight','SymFlankerRRight','RandFlankerSRight','RandFlankerRRight'};


%electrodes = [25 62]
%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'on';

%GRAPHICAL PROPERTIES
FontSize = 28;
LineWidth = 3;
set(0,'DefaultAxesFontSize', FontSize);


% extract left brain response to right hemifield stim
electrodes = [23 24 25 27];
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


TargetSymR= selectedData.TargetSymRight.data;
TargetRandR = selectedData.TargetRandRight.data;
SymFlankerSR= selectedData.SymFlankerSRight.data;
SymFlankerRR = selectedData.SymFlankerRRight.data;
RandFlankerSR= selectedData.RandFlankerSRight.data;
RandFlankerRR = selectedData.RandFlankerRRight.data;


% extract right brain response to left hemifield stim
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


TargetSymL= selectedData.TargetSymLeft.data;
TargetRandL = selectedData.TargetRandLeft.data;
SymFlankerSL= selectedData.SymFlankerSLeft.data;
SymFlankerRL = selectedData.SymFlankerRLeft.data;
RandFlankerSL= selectedData.RandFlankerSLeft.data;
RandFlankerRL = selectedData.RandFlankerRLeft.data;



% average the contralateral responses

TargetSymCont = (TargetSymL+TargetSymR)/2;
TargetRandCont = (TargetRandL+TargetRandR)/2;
SymFlankerSCont = (SymFlankerSL+SymFlankerSR)/2;
SymFlankerRCont = (SymFlankerRL+SymFlankerRR)/2;
RandFlankerSCont = (RandFlankerSL+RandFlankerSR)/2;
RandFlankerRCont = (RandFlankerRL+RandFlankerRR)/2;


% symmetry - random differnece
DiffTargetCont = TargetSymCont-TargetRandCont;
DiffFlankerSCont = SymFlankerSCont - RandFlankerRCont;
DiffFlankerRCont = SymFlankerRCont - RandFlankerRCont;
DiffRandFlankerSCont = RandFlankerSCont - RandFlankerRCont;

Zeroline = zeros(length(timeVector),1);

% % FIGURE 1
close all
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0.5 0 0],[0 1 0],[0 0.5 0],[0 0 1],[0 0 0.5]}';
figure('color',[1,1,1])
P = plot(timeVector, [TargetSymCont,TargetRandCont,SymFlankerSCont,SymFlankerRCont,RandFlankerSCont,RandFlankerRCont],'LineWidth',LineWidth);;
axis([-200 1000 -2 8]);
set(gca,'YTick',-2:2:8);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Ref None','Rand None','Ref(Ref)','Ref(Rand)','Rand(Ref)','Rand(Rand)'},'FontSize',16,'Location','northeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


% FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-','--'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 1 0],[0 0 1],[0 0 0],[0 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffTargetCont,DiffFlankerSCont,DiffFlankerRCont,DiffRandFlankerSCont,Zeroline],'LineWidth',LineWidth);
axis([-200 1000 -3 1]);
set(gca,'YTick',-3:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'None','Ref (Ref)','Ref(Rand)','Rand(Ref)'},'FontSize',FontSize,'Location','southwest');
%xlabel('Time from stimulus onset (ms)','color','w');
xlabel('Time from stimulus onset (ms)');
%ylabel('SPN amplitude (microvolts)','color','w');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')

% 
% 
% 
% 
% % For ipsilateral responses
% clear all
% close all
% 
% % DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
% cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 40/EX3 Crowding BW/Grand Averages'
% load timeVector;
% load grandAverages;
% 
% % CONDITIONS
% conditionNames={'TargetSym','TargetRand','SymFlankerS','SymFlankerR','RandFlankerS','RandFlankerR','TargetSymLeft','TargetRandLeft','SymFlankerSLeft','SymFlankerRLeft','RandFlankerSLeft','RandFlankerRLeft','TargetSymRight','TargetRandRight','SymFlankerSRight','SymFlankerRRight','RandFlankerSRight','RandFlankerRRight'};
% 
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
% 
% % extract right brain response to right hemifield stim
% electrodes = [57 58 59 60 62 63]; 
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
% 
% TargetSymR= selectedData.TargetSymRight.data;
% TargetRandR = selectedData.TargetRandRight.data;
% SymFlankerSR= selectedData.SymFlankerSRight.data;
% SymFlankerRR = selectedData.SymFlankerRRight.data;
% RandFlankerSR= selectedData.RandFlankerSRight.data;
% RandFlankerRR = selectedData.RandFlankerRRight.data;
% 
% 
% % extract left brain response to left hemifield stim
% electrodes = [20 21 22 23 25 26];
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
% 
% TargetSymL= selectedData.TargetSymLeft.data;
% TargetRandL = selectedData.TargetRandLeft.data;
% SymFlankerSL= selectedData.SymFlankerSLeft.data;
% SymFlankerRL = selectedData.SymFlankerRLeft.data;
% RandFlankerSL= selectedData.RandFlankerSLeft.data;
% RandFlankerRL = selectedData.RandFlankerRLeft.data;
% 
% 
% 
% % average the contralateral responses
% 
% TargetSymIpsi = (TargetSymL+TargetSymR)/2;
% TargetRandIpsi = (TargetRandL+TargetRandR)/2;
% SymFlankerSIpsi = (SymFlankerSL+SymFlankerSR)/2;
% SymFlankerRIpsi = (SymFlankerRL+SymFlankerRR)/2;
% RandFlankerSIpsi = (RandFlankerSL+RandFlankerSR)/2;
% RandFlankerRIpsi = (RandFlankerRL+RandFlankerRR)/2;
% 
% 
% % symmetry - random differnece
% DiffTargetIpsi = TargetSymIpsi-TargetRandIpsi;
% DiffFlankerSIpsi = SymFlankerSIpsi - RandFlankerRIpsi;
% DiffFlankerRIpsi = SymFlankerRIpsi - RandFlankerRIpsi;
% DiffRandFlankerSIpsi = RandFlankerSIpsi - RandFlankerRIpsi;
% 
% Zeroline = zeros(length(timeVector),1);
% 
% % % FIGURE 1
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','-','-'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],[0.5 0.5 0.5],[0.25 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [TargetSymIpsi,TargetRandIpsi,SymFlankerSIpsi,SymFlankerRIpsi,RandFlankerSIpsi,RandFlankerRIpsi],'LineWidth',LineWidth);;
% axis([-200 1000 -1 6]);
% set(gca,'YTick',-1:1:6);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on');
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Rand Solo','Ref (Flankers Ref)','Ref (Flankers Rand)','Rand (Flankers Ref)','Rand (Flanker Rand)'},'FontSize',12,'Location','northwest');
% xlabel('Time from stimulus onset (ms)');
% ylabel('Amplitude (microvolts)');
% grid('on')
% legend('boxoff')
% 
% 
% % FIGURE 2
% StyleArray = {'LineStyle'};
% StyleOrder = {'-','-','-','-','--'}';
% ColorArray = {'Color'};
% ColorOrder = {[1 0 0],[0 1 0],[0 0 0],[0.5 0.5 0.5],[0 0 0]}';
% figure('color',[1,1,1])
% P = plot(timeVector, [DiffTargetIpsi,DiffFlankerSIpsi,DiffFlankerRIpsi,DiffRandFlankerSIpsi,Zeroline],'LineWidth',LineWidth);
% axis([-200 1000 -2 2]);
% set(gca,'YTick',-2:1:2,'YTickLabels',[]);
% set(gca,'XTick',-200:200:1000,'XMinorTick','on','XTickLabels',[]);
% set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
% legend({'Ref Solo','Ref (Flankers Ref)','Ref (Flankers Rand)','Rand (Flankers Ref)'},'FontSize',FontSize,'Location','northwest');
% xlabel('Time from stimulus onset (ms)','color','w');
% ylabel('SPN amplitude (microvolts)','color','w');
% grid('on')
% legend('boxoff')
% 
