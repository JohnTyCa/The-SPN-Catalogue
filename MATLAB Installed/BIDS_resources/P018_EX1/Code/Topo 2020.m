close all
clear all

% you will need to set path to EEGLAB, and then change this to a directory on your computer
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX1 Ref and Ident/Grand Averages';
load timeVector;
load grandAverages;
load channelLocs.mat
load cmocean
%CONDITIONS
conditionNames={'RandRandRand', 'RefRefRef','RandRandRef','RandIdent','RefIdent'};


%TIME WINDOWS
low = 250;
high = 600;  

low = 950;
high = 1300; 

low = 1650;
high = 2000; 

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
RefRefRef = selectedData.RefRefRef.data;
RandIdent = selectedData.RandIdent.data;
RefIdent = selectedData.RefIdent.data;
RandRandRef = selectedData.RandRandRef.data;

DiffRefRefRef = RefRefRef - RandRandRand;
DiffRefIdent = RefIdent - RandIdent;
DiffRandRandRef = RandRandRef - RandRandRand;

GFPDiffRefRefRef = std(DiffRefRefRef);
GFPDiffRefIdent = std(DiffRefIdent);
GFPDiffRandRandRef = std(DiffRandRandRef);

%%%%%%%%%% this is for checking
if high == 600
    electrodes = [25 27 62 64];
    MSPNRefRefRef =mean(DiffRefRefRef(electrodes));
    MSPNRefIdent =mean(DiffRefIdent(electrodes));
    SPNcheck2a = [MSPNRefRefRef,MSPNRefIdent];
    save('SPNcheck2a','SPNcheck2a');
    GFPDiffCheck2a = [GFPDiffRefRefRef,GFPDiffRefIdent];
    save('GFPDiffCheck2a','GFPDiffCheck2a');
end
%%%%%%%%

%%%%%%%%%% this is for checking - This one needs a different time window
if high == 2000
    electrodes = [25 27 62 64];
    MSPNRandRandRef =mean(DiffRandRandRef(electrodes));
    SPNcheck2b = MSPNRandRandRef;
    save('SPNcheck2b','SPNcheck2b');
    GFPDiffCheck2b = GFPDiffRandRandRef;
    save('GFPDiffCheck2b','GFPDiffCheck2b');
end
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffRefRefRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRefRefRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Different Reflections',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRefIdent, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRefIdent,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Identical Reflections',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRandRandRef, channelLocs,'numcontour', contourRes,'colormap',cmocean);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRandRandRef,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RandRandRef',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


clear all

load SPNcheck2a
load SPNcheck2b

SPNcheck = [SPNcheck2a,SPNcheck2b];
save('SPNcheck2','SPNcheck');

load GFPDiffcheck2a
load GFPDiffcheck2b

GFPDiffCheck = [GFPDiffCheck2a,GFPDiffCheck2b];
save('GFPDiffCheck','GFPDiffCheck');
clear all
