close all
clear all
% you will need to set this to a directory on your computer
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 32/EX2 FigureGround/Grand Averages'
load timeVector;
load grandAverages;
load ERPerror;
%CONDITIONS
conditionNames={'FigureSym', 'GroundSym','FigureAsym','GroundAsym'};



%ELECTRODES
electrodes = [25 27 62 64];

%DO YOU WANT TO SMOOTH THE ERP WAVES? . 
smoothfactor = 5;
smoothOn = 'on';

%GRAPHICAL PROPERTIES
FontSize = 28;
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


FigureSym= selectedData.FigureSym.data;
GroundSym = selectedData.GroundSym.data;
FigureAsym = selectedData.FigureAsym.data;
GroundAsym = selectedData.GroundAsym.data;
DiffFigureSym  = FigureSym  - FigureAsym;
DiffGroundSym   = GroundSym - GroundAsym;
Zeroline = zeros(length(timeVector),1);


%FIGURE 1
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','-','-'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[0 0 0.5],[1 0 0],[0.5 0 0]}';
figure('color',[1,1,1])
P = plot(timeVector, [FigureSym,FigureAsym,GroundSym,GroundAsym],'LineWidth',LineWidth);
axis([-200 1500 -5 2]);
set(gca,'YTick',-5:1:2);
set(gca,'XTick',-200:200:1500,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Figure Symmetry','Figure Asymmetry','Ground Symmetry','Ground Asymmetry'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('Amplitude (microvolts)');
grid('on')
legend('boxoff')


CISPNFigure = smooth(ERPerror.SPNFigure.CI,smoothfactor,'moving');
CISPNGround = smooth(ERPerror.SPNGround.CI,smoothfactor,'moving');
PosCISPNFigure= DiffFigureSym+CISPNFigure;
NegCISPNFigure = DiffFigureSym-CISPNFigure;
PosCISPNGround= DiffGroundSym+CISPNGround;
NegCISPNGround = DiffGroundSym-CISPNGround;

%FIGURE 2
StyleArray = {'LineStyle'};
StyleOrder = {'-','-','--','-.','-.','-.','-.'}';
ColorArray = {'Color'};
ColorOrder = {[0 0 1],[1 0 1],[0 0 0],[0 0 1],[0 0 1],[1 0 1],[1 0 1]}';
figure('color',[1,1,1])
P = plot(timeVector, [DiffFigureSym,DiffGroundSym,Zeroline,PosCISPNFigure,NegCISPNFigure,PosCISPNGround,NegCISPNGround],'LineWidth',LineWidth);
axis([-200 1500 -1.5 0.5]);
set(gca,'YTick',-1.5:0.5:0.5);
set(gca,'XTick',-200:200:1500,'XMinorTick','on');
set(P,StyleArray,StyleOrder,ColorArray,ColorOrder)
legend({'Figure','Ground'},'FontSize',FontSize,'Location','southeast');
xlabel('Time from stimulus onset (ms)');
ylabel('SPN amplitude (microvolts)');
grid('on')
legend('boxoff')
clear all

