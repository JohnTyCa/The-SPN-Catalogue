close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX1 Color and Shape/Grand Averages'
load timeVector;
load grandAverages;
%load grandAveragesNoICA;
load channelLocs.mat;
load cmocean;

%CONDITIONS
conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};



% %TIME WINDOWS
low = 250
high =450;  

% low = 450
% high =750;  

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

SymmetryColorMem=selectedData.SymmetryColorMem.data;
RandomColorMem=selectedData.RandomColorMem.data;
SymmetryColorPassive= selectedData.SymmetryColorPassive.data;
RandomColorPassive=selectedData.RandomColorPassive.data;

SymmetryShapeMem=selectedData.SymmetryShapeMem.data;
RandomShapeMem=selectedData.RandomShapeMem.data;
SymmetryShapePassive= selectedData.SymmetryShapePassive.data;
RandomShapePassive=selectedData.RandomShapePassive.data;

DiffColorMem = SymmetryColorMem-RandomColorMem;
DiffColorPassive = SymmetryColorPassive-RandomColorPassive;
DiffShapeMem = SymmetryShapeMem-RandomShapeMem;
DiffShapePassive = SymmetryShapePassive-RandomShapePassive;

GFPDiffColorMem = std(DiffColorMem);
GFPDiffColorPassive = std(DiffColorPassive);
GFPDiffShapeMem = std(DiffShapeMem);
GFPDiffShapePassive = std(DiffShapePassive);

%%%%%%%%%% this is for checking
if high == 450
    electrodes = [25 27 62 64]; % PO7 O1 O2 PO8
    MSPNColorMem =mean(DiffColorMem(electrodes));
    MSPNColorPassive =mean(DiffColorPassive(electrodes));
    MSPNShapeMem =mean(DiffShapeMem(electrodes));
    MSPNShapePassive =mean(DiffShapePassive(electrodes));
    
    SPNcheck2a = [MSPNColorMem,MSPNColorPassive,MSPNShapeMem,MSPNShapePassive];
    save('SPNcheck2a','SPNcheck2a');
    GFPDiffChecka = [GFPDiffColorMem,GFPDiffColorPassive,GFPDiffShapeMem,GFPDiffShapePassive];
    save('GFPDiffChecka','GFPDiffChecka');
end

%%%%%%%%

%%%%%%%%%% this is for checking
if high == 750
    electrodes = [25 27 62 64]; % PO7 O1 O2 PO8
    MSPNColorMem =mean(DiffColorMem(electrodes));
    MSPNColorPassive =mean(DiffColorPassive(electrodes));
    MSPNShapeMem =mean(DiffShapeMem(electrodes));
    MSPNShapePassive =mean(DiffShapePassive(electrodes));
    
    SPNcheck2b = [MSPNColorMem,MSPNColorPassive,MSPNShapeMem,MSPNShapePassive];
    save('SPNcheck2b','SPNcheck2b');
    GFPDiffCheckb = [GFPDiffColorMem,GFPDiffColorPassive,GFPDiffShapeMem,GFPDiffShapePassive];
    save('GFPDiffCheckb','GFPDiffCheckb');
end

%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffColorMem, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffColorMem,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Color Mem',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffColorPassive, channelLocs,'numcontour',contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffColorPassive,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Color Passive',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffShapeMem, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffShapeMem,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Shape Mem',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffShapePassive, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffShapePassive,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Shape passive',(num2str(low)),'-',num2str(high),'.png'];
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
