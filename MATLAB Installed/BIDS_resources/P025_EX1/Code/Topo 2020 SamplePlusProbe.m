close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX1 Color and Shape/Grand Averages'

load timeVectorSamplePlusProbe;
load grandAveragesSamplePlusProbe

load channelLocs.mat;

%CONDITIONS
conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};




%TIME WINDOWS
low = 200
high = 1000;  
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale =4;
contourRes = 3;

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

NSWSymmetryColor = SymmetryColorMem-SymmetryColorPassive;
NSWRandomColor =RandomColorMem-RandomColorPassive;

NSWSymmetryShape = SymmetryShapeMem-SymmetryShapePassive;
NSWRandomShape =RandomShapeMem-RandomShapePassive;



figure('color',[1,1,1])
topoplot(NSWSymmetryColor, channelLocs,'numcontour', contourRes);
caxis([-zscale, zscale])
% colorbar('FontSize',FontSize)
title('NSWSymmetryColor','FontSize',FontSize);
toponame = ['Color(SymmetryProbe)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(NSWRandomColor, channelLocs,'numcontour',contourRes);
caxis([-zscale, zscale])
% colorbar('FontSize',FontSize)
title('NSWRandomColor','FontSize',FontSize);
toponame = ['Color(RandomProbe)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(NSWSymmetryShape, channelLocs,'numcontour', contourRes);
caxis([-zscale, zscale])
% colorbar('FontSize',FontSize)
title('NSWSymmetryShape','FontSize',FontSize);
toponame = ['Shape(SymmetryProbe)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(NSWRandomShape, channelLocs,'numcontour',contourRes);
caxis([-zscale, zscale])
% colorbar('FontSize',FontSize)
title('NSWRandomShape','FontSize',FontSize);
toponame = ['Shape(RandomProbe)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all

