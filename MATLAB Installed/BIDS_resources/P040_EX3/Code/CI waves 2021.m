close all
clear all
% you will need to set this to a directory on your computer
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX3 Crowding BW/Grand Averages'
load timeVector;
load grandAverages; 
load ERPerrorLeftBrain

%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'off';

%GRAPHICAL PROPERTIES
FontSize = 20;
LineWidth = 2;
set(0,'DefaultAxesFontSize', FontSize);



%CONDITIONS
conditionNames={'TargetSymLeft','TargetRandLeft','SymFlankerSLeft','SymFlankerRLeft','RandFlankerSLeft','RandFlankerRLeft','TargetSymRight','TargetRandRight','SymFlankerSRight','SymFlankerRRight','RandFlankerSRight','RandFlankerRRight'};

hemisphere= input('which hemisphere?');
if strcmp(hemisphere, 'left') == 1 % SPNs in left hem
    load ERPerrorLeftBrain;
    electrodes = [23 24 25 27];
end

if strcmp(hemisphere, 'right') == 1 % SPNs in right hem
    load ERPerrorRightBrain;
    electrodes = [60 61 62 64]; 
end


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

TargetSymLeft= selectedData.TargetSymLeft.data;
TargetRandLeft = selectedData.TargetRandLeft.data;
SymFlankerSLeft= selectedData.SymFlankerSLeft.data;
SymFlankerRLeft = selectedData.SymFlankerRLeft.data;
RandFlankerSLeft= selectedData.RandFlankerSLeft.data;
RandFlankerRLeft = selectedData.RandFlankerRLeft.data;


TargetSymRight= selectedData.TargetSymRight.data;
TargetRandRight = selectedData.TargetRandRight.data;
SymFlankerSRight= selectedData.SymFlankerSRight.data;
SymFlankerRRight = selectedData.SymFlankerRRight.data;
RandFlankerSRight= selectedData.RandFlankerSRight.data;
RandFlankerRRight = selectedData.RandFlankerRRight.data;


Zeroline = zeros(length(timeVector),1);


close all

%%%%%%%%%%%%% Select left hemisphere electrodes %%%%%%%%%%%%%%%

%SPN 242 when left electrodes selected
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [TargetRandRight,TargetSymRight],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, TargetRandRightIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,TargetSymRightIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%SPN 243 when left electrodes selected
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerRRight,SymFlankerSRight],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand (Flankers Rand)','Sym (Flankers Sym)'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerRRightIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlankerRRightIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%SPN 244 when left electrodes selected
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerRRight,SymFlankerRRight],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand (Flankers Rand)','Sym (Flankers Rand)'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerRRightIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlankerRRightIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')

%SPN 245 when left electrodes selected
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerRRight,RandFlankerSRight],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand (Flankers Rand)','Rand (Flankers Sym)'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerRRIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RandFlankerSRightIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')









%%%%%%%%%%%%% Select right hemisphere electrodes %%%%%%%%%%%%%%%


%SPN246 when right electrodes selected
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [TargetRandLeft,TargetSymLeft],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Random','Symmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, TargetRandLeftIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,TargetSymLeftIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%SPN247 when right electrodes selected
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerRLeft,SymFlankerSLeft],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand (Flankers Rand)','Sym (Flankers Sym)'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerRLeftIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlankerVLeftIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%SPN248 when right electrodes selected
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerRLeft,SymFlankerRLeft],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand (Flankers Rand)','Sym (Flankers Rand)'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerRLeftIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,SymFlankerRLeftIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')


%SPN249 when right electrodes selected
figure('color',[1,1,1])
StyleArray = {'LineStyle'};
StyleOrder = {'-','-'}';
ColorArray = {'Color'};
ColorOrder = {[1 0 0],[0 0 1]}';
P = plot(timeVector, [RandFlankerRLeft,RandFlankerSLeft],'LineWidth',LineWidth);
axis([-200 1000 -10 10]);
set(gca,'YTick',-10:5:10);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Rand (Flankers Rand)','Rand(Flankers Sym)'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')
% hold on
% plot(timeVector, RandFlankerRLeftIndividuals,'LineWidth',0.05,'Color',ColorOrder{1},'LineStyle', ':');
% hold on
% plot(timeVector,RandFlankerSLeftIndividuals,'LineWidth',0.05,'Color',ColorOrder{2},'LineStyle', ':');
% hold on 
% uistack(P,'top')
% legend('off')








%FIGURE 2


DiffTargetLeft = TargetSymLeft-TargetRandLeft;
DiffSymFlankerSLeft = SymFlankerSLeft-RandFlankerRLeft;
DiffSymFlankerRLeft = SymFlankerRLeft-RandFlankerRLeft;
DiffRandFlankerSLeft= RandFlankerSLeft-RandFlankerRLeft;

DiffTargetRight = TargetSymRight-TargetRandRight;
DiffSymFlankerSRight = SymFlankerSRight-RandFlankerRRight;
DiffSymFlankerRRight = SymFlankerRRight-RandFlankerRRight;
DiffRandFlankerSRight= RandFlankerSRight-RandFlankerRRight;




low = 200
high = 600
ii = find(timeVector >=low & timeVector <=high);
MSPNTargetLeft = mean(DiffTargetLeft(ii));
MSPNSymFlankerSLeft = mean(DiffSymFlankerSLeft(ii));
MSPNSymFlankerRLeft = mean(DiffSymFlankerRLeft(ii));
MSPNRandFlankerSLeft =mean(DiffRandFlankerSLeft(ii));

MSPNTargetRight = mean(DiffTargetRight(ii));
MSPNSymFlankerSRight = mean(DiffSymFlankerSRight(ii));
MSPNSymFlankerRRight = mean(DiffSymFlankerRRight(ii));
MSPNRandFlankerSRight =mean(DiffRandFlankerSRight(ii));

%SPNcheck = [MSPNTargetLeft,MSPNSymFlankerSLeft,MSPNSymFlankerRLeft,MSPNRandFlankerSLeft,MSPNTargetRight,MSPNSymFlankerSRight,MSPNSymFlankerRRight,MSPNRandFlankerSRight];
if strcmp(hemisphere, 'left') == 1 % SPNs in left hem
    SPNcheckLeft = [MSPNTargetRight,MSPNSymFlankerSRight,MSPNSymFlankerRRight,MSPNRandFlankerSRight];
    save('SPNcheckLeft','SPNcheckLeft');
    
end
if strcmp(hemisphere, 'right') == 1 % SPNs in left hem
    SPNcheckRight = [MSPNTargetLeft,MSPNSymFlankerSLeft,MSPNSymFlankerRLeft,MSPNRandFlankerSLeft];
    save('SPNcheckRight','SPNcheckRight');
    
end

CITargetLeftSPN = ERPerror.TargetLeftSPN.CI;
CISymFlankerSLeftSPN = ERPerror.SymFlankerSLeftSPN.CI;
CISymFlankerRLeftSPN = ERPerror.SymFlankerRLeftSPN.CI;
CIRandFlankerSLeftSPN = ERPerror.RandFlankerSLeftSPN.CI;


CITargetRightSPN = ERPerror.TargetRightSPN.CI;
CISymFlankerSRightSPN = ERPerror.SymFlankerSRightSPN.CI;
CISymFlankerRRightSPN = ERPerror.SymFlankerRRightSPN.CI;
CIRandFlankerSRightSPN = ERPerror.RandFlankerSRightSPN.CI;



if strcmp(smoothOn, 'on') == 1;
    CITargetLeftSPN = smooth(CITargetLeftSPN,smoothfactor,'moving');
    CISymFlankerSLeftSPN = smooth(CISymFlankerSLeftSPN,smoothfactor,'moving');
    CISymFlankerRLeftSPN = smooth(CISymFlankerRLeftSPN,smoothfactor,'moving');
    CIRandFlankerSLeftSPN = smooth(CIRandFlankerSLeftSPN,smoothfactor,'moving');
    
    CITargetRightSPN = smooth(CITargetRightSPN,smoothfactor,'moving');
    CISymFlankerSRightSPN = smooth(CISymFlankerSRightSPN,smoothfactor,'moving');
    CISymFlankerRRightSPN = smooth(CISymFlankerRRightSPN,smoothfactor,'moving');
    CIRandFlankerSRightSPN = smooth(CIRandFlankerSRightSPN,smoothfactor,'moving'); 
end

PosCITargetLeftSPN= DiffTargetLeft+CITargetLeftSPN;
PosCISymFlankerSLeftSPN= DiffSymFlankerSLeft+CISymFlankerSLeftSPN;
PosCISymFlankerRLeftSPN= DiffSymFlankerRLeft+CISymFlankerRLeftSPN;
PosCIRandFlankerSLeftSPN= DiffRandFlankerSLeft+CIRandFlankerSLeftSPN;
PosCITargetRightSPN= DiffTargetRight+CITargetRightSPN;
PosCISymFlankerSRightSPN= DiffSymFlankerSRight+CISymFlankerSRightSPN;
PosCISymFlankerRRightSPN= DiffSymFlankerRRight+CISymFlankerRRightSPN;
PosCIRandFlankerSRightSPN= DiffRandFlankerSRight+CIRandFlankerSRightSPN;

NegCITargetLeftSPN= DiffTargetLeft-CITargetLeftSPN;
NegCISymFlankerSLeftSPN= DiffSymFlankerSLeft-CISymFlankerSLeftSPN;
NegCISymFlankerRLeftSPN= DiffSymFlankerRLeft-CISymFlankerRLeftSPN;
NegCIRandFlankerSLeftSPN= DiffRandFlankerSLeft-CIRandFlankerSLeftSPN;
NegCITargetRightSPN= DiffTargetRight-CITargetRightSPN;
NegCISymFlankerSRightSPN= DiffSymFlankerSRight-CISymFlankerSRightSPN;
NegCISymFlankerRRightSPN= DiffSymFlankerRRight-CISymFlankerRRightSPN;
NegCIRandFlankerSRightSPN= DiffRandFlankerSRight-CIRandFlankerSRightSPN;



% SPN242 when left electrodes selected
close all
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCITargetRightSPN',fliplr(PosCITargetRightSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTargetRight,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTargetRight,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)
%%%%%%%%%%%%% Select left hemisphere electrodes %%%%%%%%%%%%%%%
% SPN243 when left electrodes selected
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISymFlankerSRightSPN',fliplr(PosCISymFlankerSRightSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSymFlankerSRight,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSymFlankerSRight,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

% SPN244 when left electrodes selected
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISymFlankerRRightSPN',fliplr(PosCISymFlankerRRightSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSymFlankerRRight,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSymFlankerRRight,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

% SPN245 when left electrodes selected
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRandFlankerSRightSPN',fliplr(PosCIRandFlankerSRightSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRandFlankerSRight,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRandFlankerSRight,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)



%%%%%%%%%%%%% Select right hemisphere electrodes %%%%%%%%%%%%%%%
% SPN246 when right electrodes selected 
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCITargetLeftSPN',fliplr(PosCITargetLeftSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffTargetLeft,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNTargetLeft,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)


% SPN247 when right electrodes selected 
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISymFlankerSLeftSPN',fliplr(PosCISymFlankerSLeftSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSymFlankerSLeft,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSymFlankerSLeft,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

% SPN248 when right electrodes selected 
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCISymFlankerRLeftSPN',fliplr(PosCISymFlankerRLeftSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffSymFlankerRLeft,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNSymFlankerRLeft,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

% SPN249 when right electrodes selected 
figure('color',[1,1,1])
themeCol = 'blue';
rectangle('position',[low, -5,high-low,6],'FaceColor',[1 1 0 0.1],'EdgeColor','black'); 
patch([timeVector,fliplr(timeVector)],[NegCIRandFlankerSLeftSPN',fliplr(PosCIRandFlankerSLeftSPN')],themeCol,'EdgeColor','none');
hold on
plot(timeVector,DiffRandFlankerSLeft,themeCol,'LineWidth',LineWidth);
hold on
plot(timeVector, Zeroline,'Color',[1 0 0],'LineWidth',LineWidth,'LineStyle','-');
axis([-200 1000 -5 1]);
set(gca,'YTick',-5:1:1);
set(gca,'XTick',-200:200:1000,'XMinorTick','on');
yline(MSPNRandFlankerSLeft,themeCol,'LineWidth',LineWidth);
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('off')
box('on')
alpha(0.4)

