close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 4/EX2 both (surviving 17)/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean.mat;
%CONDITIONS
conditionNames = {'Reflection','Random'};

%TIME WINDOWS
low = 250;
high = 1000;
ii = find(timeVector >=low & timeVector <=high);

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale =5
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
Reflection = selectedData.Reflection.data;

Diff= Reflection - Random;
GFPDiff = std(Diff);


%This is for checking
electrodes = [22 23 24 25 59 60 61 62]; % Left and right (Scott et al. 2009)
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
toponame = ['Reflection',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear
