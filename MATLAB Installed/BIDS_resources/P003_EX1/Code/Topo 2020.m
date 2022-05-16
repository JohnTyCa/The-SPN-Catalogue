close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 3/EX1 Reg/Grand Averages';
load timeVector;
%load grandAverages;
load LowPass40grandAverages;
load channelLocs.mat;
load cmocean.mat;
conditionNames = {'ReflectionOne','ReflectionTwo', 'TranslationOne', 'TranslationTwo'};


%TIME WINDOWS
low = 250;
high = 1000;
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

ReflectionOne= selectedData.ReflectionOne.data;
ReflectionTwo = selectedData.ReflectionTwo.data;
TranslationOne= selectedData.TranslationOne.data;
TranslationTwo = selectedData.TranslationTwo.data;


DiffOne= ReflectionOne - TranslationOne;
DiffTwo= ReflectionTwo - TranslationTwo;
GFPDiffOne = std(DiffOne);
GFPDiffTwo = std(DiffTwo);

electrodes = [25 62]; 
MSPNOne =mean(DiffOne(electrodes));
MSPNTwo =mean(DiffTwo(electrodes));


%This is for checking
SPNcheck = [MSPNOne,MSPNTwo];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffOne,GFPDiffTwo];
save('GFPDiffCheck','GFPDiffCheck');


figure('color',[1,1,1])
topoplot(DiffOne, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffOne,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['One object',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffTwo, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffTwo,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Two objects',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear
