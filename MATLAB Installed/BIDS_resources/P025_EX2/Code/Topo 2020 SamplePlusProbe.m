close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX2 Symm probe Symm/Grand Averages'
load timeVectorSamplePlusProbe;
load grandAveragesSamplePlusProbe
load channelLocs.mat;
%CONDITIONS
conditionNames={'SymmetryMemory','RandomMemory','SymmetryPassive','RandomPassive'};


%TIME WINDOWS
low = 500
high =1250;  
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale =3;
contourRes = 3;

% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = squeeze(mean(data(1:end, ii),2));
    selectedData.(c).data = data;
end

%save('thisTopo','selectedData');


SymmetryMemory=selectedData.SymmetryMemory.data;
RandomMemory=selectedData.RandomMemory.data;
SymmetryPassive= selectedData.SymmetryPassive.data;
RandomPassive=selectedData.RandomPassive.data;


NSWSymmetry = SymmetryMemory-SymmetryPassive;
NSWRandom =RandomMemory-RandomPassive;

figure('color',[1,1,1])
topoplot(NSWSymmetry, channelLocs,'numcontour', contourRes);
caxis([-zscale, zscale])
% colorbar('FontSize',FontSize)
% title('Memory','FontSize',FontSize);
toponame = ['NSW(SymmetryProbe)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(NSWRandom, channelLocs,'numcontour',contourRes);
caxis([-zscale, zscale])
% colorbar('FontSize',FontSize)
% title('Passive','FontSize',FontSize);
toponame = ['NSW(RandomProbe)',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all