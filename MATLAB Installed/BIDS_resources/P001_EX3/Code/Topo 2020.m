close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 1/EX3 Rotation/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean.mat;
%CONDITIONS
conditionNames={'Regular','Random'}

%TIME WINDOWS
low = 300;
high = 1000;
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale = 5;
contourRes = 0;

% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = squeeze(mean(data(1:end, ii),2));
    selectedData.(c).data = data;
end


%save('thisTopo','selectedData');
Random= selectedData.Random.data;
Regular = selectedData.Regular.data;
Diff= Regular - Random;
GFPDiff = std(Diff);

%This is for checking
electrodes = [25 62]; 
MSPN =mean(Diff(electrodes));
SPNcheck = MSPN;
save('SPNcheck2','SPNcheck');
GFPDiffCheck = GFPDiff;
save('GFPDiffCheck','GFPDiffCheck');

figure('color',[1,1,1])
topoplot(Diff, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiff,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Rotation',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

