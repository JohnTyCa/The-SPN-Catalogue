close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX2 One Sided/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean.mat;
%CONDITIONS
conditionNames={'REFNOTHING','RANDNOTHING','NOTHINGREF','NOTHINGRAND'};

%TIME WINDOWS
low = 200;
high = 600;

low = 600;
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
REFNOTHING= selectedData.REFNOTHING.data;
RANDNOTHING = selectedData.RANDNOTHING.data;
NOTHINGREF= selectedData.NOTHINGREF.data;
NOTHINGRAND = selectedData.NOTHINGRAND.data;




DiffLeftHem= NOTHINGREF - NOTHINGRAND;
DiffRightHem= REFNOTHING - RANDNOTHING;

GFPDiffLeftHem = std(DiffLeftHem);
GFPDiffRightHem = std(DiffRightHem);

%%%%%%%%%% this is for checking
if high == 600
electrodesL = [20 21 22 23 25 26]; % Left
electrodesR = [57 58 59 60 62 63]; % Right
MSPNLeft =mean(DiffLeftHem(electrodesL));
MSPNRight =mean(DiffRightHem(electrodesR));
SPNcheck2a = [MSPNLeft,MSPNRight]; % take from CIwaves
save('SPNcheck2a','SPNcheck2a');
GFPDiffChecka = [GFPDiffLeftHem,GFPDiffRightHem]%copyorder
save('GFPDiffChecka','GFPDiffChecka');
end
%%%%%%%%


%%%%%%%%%% this is for checking
if high == 1000
electrodesL = [20 21 22 23 25 26]; % Left
electrodesR = [57 58 59 60 62 63]; % Right
MSPNLeft =mean(DiffLeftHem(electrodesL));
MSPNRight =mean(DiffRightHem(electrodesR));
SPNcheck2b = [MSPNLeft,MSPNRight]; % take from CIwaves
save('SPNcheck2b','SPNcheck2b');
GFPDiffCheckb = [GFPDiffLeftHem,GFPDiffRightHem]%copyorder
save('GFPDiffCheckb','GFPDiffCheckb');
end
%%%%%%%%

figure('color',[1,1,1])
topoplot(DiffLeftHem, channelLocs,'numcontour', contourRes,'colormap',cmocean);
%headplot(DiffLeftHem, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffLeftHem,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['LeftSPN',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffRightHem, channelLocs,'numcontour', contourRes,'colormap',cmocean);
%headplot(DiffRightHem, 'BioSemiSpline.spl', 'maplimits',[-zscale, zscale],'electrodes', 'off', 'view', [0 0]);
colorbar('FontSize',FontSize)
caxis([-zscale, zscale])
t =['GFP=',num2str(round(GFPDiffRightHem,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['RightSPN',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);



clear all

load SPNcheck2a
load SPNcheck2b

SPNcheck = (SPNcheck2a+SPNcheck2b)/2;
save('SPNcheck2','SPNcheck');

load GFPDiffchecka
load GFPDiffcheckb

GFPDiffCheck = (GFPDiffChecka+GFPDiffCheckb)/2;
save('GFPDiffCheck','GFPDiffCheck');
clear all

