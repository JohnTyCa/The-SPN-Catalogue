close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX2 Symm probe Symm/Grand Averages'

load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean
%CONDITIONS
conditionNames={'SymmetryMemory','RandomMemory','SymmetryPassive','RandomPassive'};

%TIME WINDOWS
low = 250
high =450;  

low = 450
high =750;  

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


SymmetryMemory=selectedData.SymmetryMemory.data;
RandomMemory=selectedData.RandomMemory.data;
SymmetryPassive= selectedData.SymmetryPassive.data;
RandomPassive=selectedData.RandomPassive.data;


DiffMemory = SymmetryMemory-RandomMemory;
DiffPassive = SymmetryPassive-RandomPassive;

GFPDiffMemory = std(DiffMemory);
GFPDiffPassive = std(DiffPassive);

%%%%%%%%%% this is for checking
if high == 450
    electrodes = [25 27 62 64]; % PO7 O1 O2 PO8
    MSPNMemory =mean(DiffMemory(electrodes));
    MSPNPassive =mean(DiffPassive(electrodes))
    SPNcheck2a = [MSPNMemory,MSPNPassive];
    save('SPNcheck2a','SPNcheck2a');
    GFPDiffChecka =[GFPDiffMemory,GFPDiffPassive];
    save('GFPDiffChecka','GFPDiffChecka');
end

%%%%%%%%


%%%%%%%%%% this is for checking
if high == 750
    electrodes = [25 27 62 64]; % PO7 O1 O2 PO8
    MSPNMemory =mean(DiffMemory(electrodes));
    MSPNPassive =mean(DiffPassive(electrodes))
    SPNcheck2b = [MSPNMemory,MSPNPassive];
    save('SPNcheck2b','SPNcheck2b');
    GFPDiffCheckb =[GFPDiffMemory,GFPDiffPassive];
    save('GFPDiffCheckb','GFPDiffCheckb');
end

figure('color',[1,1,1])
topoplot(DiffMemory, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffMemory,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Memory',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffPassive, channelLocs,'numcontour',contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffPassive,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Passive',(num2str(low)),'-',num2str(high),'.png'];
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
