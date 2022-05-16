% topoplots
close all
clear all
% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 38/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'REFdownRANDup','RANDdownREFup','REFdownREFupREFdown','REFupREFdownREFup','RandRandRand','Oddball'};

%TIME WINDOWS
low = 250;
high = 600;
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
REFdownRANDup = selectedData.REFdownRANDup.data;
RANDdownREFup = selectedData.RANDdownREFup.data;
REFdownREFupREFdown = selectedData.REFdownREFupREFdown.data;
REFupREFdownREFup= selectedData.REFupREFdownREFup.data;

DiffREFdownRANDup = REFdownRANDup - RandRandRand;
DiffRANDdownREFup  = RANDdownREFup  - RandRandRand;
DiffREFdownREFupREFdown = REFdownREFupREFdown - RandRandRand;
DiffREFupREFdownREFup = REFupREFdownREFup - RandRandRand;

GFPDiffREFdownRANDup = std(DiffREFdownRANDup);
GFPDiffRANDdownREFup = std(DiffRANDdownREFup);
GFPDiffREFdownREFupREFdown = std(DiffREFdownREFupREFdown);
GFPDiffREFupREFdownREFup = std(DiffREFupREFdownREFup);

%%%%%%%%%% this is for checking
electrodes = [25 27 62 64]; 
MSPNREFdownRANDup =mean(DiffREFdownRANDup(electrodes));
MSPNRANDdownREFup =mean(DiffRANDdownREFup(electrodes));
MSPNREFdownREFupREFdown =mean(DiffREFdownREFupREFdown(electrodes));
MSPNREFupREFdownREFup =mean(DiffREFupREFdownREFup(electrodes));


SPNcheck = [MSPNREFdownRANDup,MSPNRANDdownREFup,MSPNREFdownREFupREFdown,MSPNREFupREFdownREFup];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffREFdownRANDup,GFPDiffRANDdownREFup,GFPDiffREFdownREFupREFdown,GFPDiffREFupREFdownREFup];
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffREFdownRANDup, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffREFdownRANDup,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['REFdownRANDup',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRANDdownREFup, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRANDdownREFup,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RANDdownREFup',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffREFdownREFupREFdown, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffREFdownREFupREFdown,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['REFdownREFupREFdown',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffREFupREFdownREFup, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffREFupREFdownREFup,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['REFupREFdownREFup',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all



