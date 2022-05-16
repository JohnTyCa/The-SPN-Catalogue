% topoplots
close all
clear all

% you will need to set path to EEGLAB, and then change this to a directory
% on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX2 Left and Right With Eye Tracking/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean;
%CONDITIONS
conditionNames={'REFRANDs','RANDREFs','REFlREFrREFl','REFrREFlREFr','RandRandRand','Consistent','Changing'};

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
Consistent = selectedData.Consistent.data;
Changing = selectedData.Changing.data;
REFRANDs = selectedData.REFRANDs.data;
RANDREFs = selectedData.RANDREFs.data;
REFlREFrREFl =  selectedData.REFlREFrREFl.data;
REFrREFlREFr =  selectedData.REFrREFlREFr.data;


DiffConsistent = Consistent - RandRandRand;
DiffChanging = Changing - RandRandRand;
DiffREFRANDs = REFRANDs - RandRandRand;
DiffRANDREFs = RANDREFs - RandRandRand;
DiffREFlREFrREFl = REFlREFrREFl - RandRandRand;
DiffREFrREFlREFr = REFrREFlREFr - RandRandRand;

GFPDiffConsistent = std(DiffConsistent);
GFPDiffChanging = std(DiffChanging);
GFPDiffREFRANDs = std(DiffREFRANDs);
GFPDiffRANDREFs = std(DiffRANDREFs);
GFPDiffREFlREFrREFl = std(DiffREFlREFrREFl);
GFPDiffREFrREFlREFr = std(DiffREFrREFlREFr);

%%%%%%%%%% this is for checking
electrodesL = [21 22 25 26]; % left electrodes 
electrodesR = [58 59 62 63]; % right electrodes 
MSPNRANDREFs =mean(DiffRANDREFs(electrodesL));
MSPNREFrREFlREFr =mean(DiffREFrREFlREFr(electrodesL));
MSPNREFRANDs=mean(DiffREFRANDs(electrodesR));
MSPNREFlREFrREFl=mean(DiffREFlREFrREFl(electrodesR));
SPNcheck = [MSPNRANDREFs,MSPNREFrREFlREFr,MSPNREFRANDs,MSPNREFlREFrREFl];
save('SPNcheck2','SPNcheck');
GFPDiffCheck = [GFPDiffRANDREFs,GFPDiffREFrREFlREFr,GFPDiffREFRANDs,GFPDiffREFlREFrREFl]%copyorder
save('GFPDiffCheck','GFPDiffCheck');
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffREFRANDs, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
%headplot(DiffREFRANDs, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 90]);
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffREFRANDs,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['REFRANDs',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRANDREFs, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
%headplot(DiffRANDREFs, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 90]);
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRANDREFs,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RANDREFs',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffREFlREFrREFl, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
%headplot(DiffREFlREFrREFl, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 90]);
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffREFlREFrREFl,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['REFlREFrREFl',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffREFrREFlREFr, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
%headplot(DiffREFrREFlREFr, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 90]);
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffREFrREFlREFr,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['REFrREFlREFr',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);
clear all

