% topoplots
close all
clear all
% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39/Grand Averages750'
load timeVector750;
load grandAverages750;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'RandRandRand', 'RefRefRef'};

low = 250;
high = 850;
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


RandRandRand = selectedData.RandRandRand.data;
RefRefRef = selectedData.RefRefRef.data;
Diff = RefRefRef - RandRandRand;
GFPDiff = std(Diff);


%%%%%%%%%% this is for checking
electrodes = [25 27 62 64]; % 
MSPN =mean(Diff(electrodes));
SPNcheck = MSPN
save('SPNcheck2','SPNcheck');
GFPDiffCheck = GFPDiff;%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(Diff, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiff,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Diff',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all



