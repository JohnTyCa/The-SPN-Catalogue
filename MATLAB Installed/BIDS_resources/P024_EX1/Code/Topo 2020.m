close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 24/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
%CONDITIONS
conditionNames={'LCRandRand','RCRandRand','LCRandSymm','RCRandSymm','LCSymmRand','RCSymmRand'};

%TIME WINDOWS
low = 250;
high =350; %   


% low = 500
% high = 1000
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale =5;
contourRes = 0;

% SELECT DATA LOOP

for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = squeeze(mean(data(1:end, ii),2));
    selectedData.(c).data = data;
end

%save('thisTopo','selectedData');

LCRandRand=selectedData.LCRandRand.data;
RCRandRand=selectedData.RCRandRand.data;
LCRandSymm= selectedData.LCRandSymm.data;
RCRandSymm=selectedData.RCRandSymm.data;
LCSymmRand= selectedData.LCSymmRand.data;
RCSymmRand=selectedData.RCSymmRand.data;


DiffLCRandSymm = LCRandSymm-LCRandRand;
DiffRCRandSymm = RCRandSymm-RCRandRand;
DiffLCSymmRand = LCSymmRand-LCRandRand;
DiffRCSymmRand = RCSymmRand-RCRandRand;


GFPDiffLCRandSymm = std(DiffLCRandSymm);
GFPDiffRCRandSymm = std(DiffRCRandSymm);
GFPDiffLCSymmRand= std(DiffLCSymmRand);
GFPDiffRCSymmRand= std(DiffRCSymmRand);

%%%%%%%%%% this is for checking
if high == 350
    electrodesL =  [23 25 26 27]; %P7 PO3 PO7 O1 left electrodes
    electrodesR = [60 62 63 64]; %P8 PO4 PO8 O2 right electrodes
    MSPNLCRandSymm =mean(DiffLCRandSymm(electrodesL));
    MSPNRCRandSymm =mean(DiffRCRandSymm(electrodesL));
    MSPNLCSymmRand=mean(DiffLCSymmRand(electrodesR));
    MSPNRCSymmRand=mean(DiffRCSymmRand(electrodesR));
    
    SPNcheck2a = [MSPNLCRandSymm,MSPNRCRandSymm,MSPNLCSymmRand,MSPNRCSymmRand];
    save('SPNcheck2a','SPNcheck2a');
    GFPDiffChecka = [GFPDiffLCRandSymm,GFPDiffRCRandSymm,GFPDiffLCSymmRand,GFPDiffRCSymmRand];
    save('GFPDiffChecka','GFPDiffChecka');
end
%%%%%%%%


%%%%%%%%%% this is for checking
if high == 1000
    electrodesL =  [23 25 26 27]; %P7 PO3 PO7 O1 left electrodes
    electrodesR = [60 62 63 64]; %P8 PO4 PO8 O2 right electrodes
    MSPNLCRandSymm =mean(DiffLCRandSymm(electrodesL));
    MSPNRCRandSymm =mean(DiffRCRandSymm(electrodesL));
    MSPNLCSymmRand=mean(DiffLCSymmRand(electrodesR));
    MSPNRCSymmRand=mean(DiffRCSymmRand(electrodesR));
    SPNcheck2b = [MSPNLCRandSymm,MSPNRCRandSymm,MSPNLCSymmRand,MSPNRCSymmRand];
    save('SPNcheck2b','SPNcheck2b');
    GFPDiffCheckb = [GFPDiffLCRandSymm,GFPDiffRCRandSymm,GFPDiffLCSymmRand,GFPDiffRCSymmRand];
    save('GFPDiffCheckb','GFPDiffCheckb');
end
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffLCRandSymm, channelLocs,'numcontour', contourRes,'colormap',cmocean);
%headplot(DiffRCRandSymm, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffLCRandSymm,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Rand < Symm',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRCRandSymm, channelLocs,'numcontour', contourRes,'colormap',cmocean);
%headplot(DiffRCRandSymm, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffRCRandSymm,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Rand > Symm',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffLCSymmRand, channelLocs,'numcontour', contourRes,'colormap',cmocean);
%headplot(DiffLCSymmRand, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffLCSymmRand,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Symm < Rand',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRCSymmRand, channelLocs,'numcontour', contourRes,'colormap',cmocean);
%headplot(DiffRCSymmRand, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffRCSymmRand,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Symm > Rand',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);
clear all



load SPNcheck2a
load SPNcheck2b

SPNcheck = (SPNcheck2a+SPNcheck2b)/2;
save('SPNcheck2','SPNcheck');

load GFPDiffchecka
load GFPDiffcheckb

GFPDiffCheck = (GFPDiffChecka+GFPDiffCheckb)/2;
save('GFPDiffCheck','GFPDiffCheck');
clear all