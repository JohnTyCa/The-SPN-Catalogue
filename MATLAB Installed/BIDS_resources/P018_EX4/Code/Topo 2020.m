% topoplots
close all
clear all

% you will need to set path to EEGLAB, and then change this to a directory
% on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX4 Ref Vert and Horz/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'RandRandRand', 'Rep','Change'};

%%TIME WINDOWS
low = 250;
high = 600;  
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
RandRandRand = selectedData.RandRandRand.data;
Rep = selectedData.Rep.data;
Change = selectedData.Change.data;
DiffRep = Rep - RandRandRand;
DiffChange = Change - RandRandRand;


GFPDiffRep = std(DiffRep);
GFPDiffChange = std(DiffChange);

%%%%%%%%%% this is for checking
electrodes = [25 27 62 64]; 
MSPNRep =mean(DiffRep(electrodes));
MSPNChange =mean(DiffChange(electrodes));
SPNcheck = [MSPNRep,MSPNChange]; % take from CIwaves
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffRep,GFPDiffChange];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffRep, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRep,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Repeated Orientations',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffChange, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffChange,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Changing Orientations',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all



