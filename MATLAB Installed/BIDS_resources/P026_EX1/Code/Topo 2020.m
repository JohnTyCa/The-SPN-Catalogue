close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 26/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean;
%CONDITIONS
conditionNames={'SymmAlc','RandAlc','SymmPla','RandPla'};

%TIME WINDOWS

%TIME WINDOWS
low = 200
high =400  

low = 400
high =1000  
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


SymmAlc=selectedData.SymmAlc.data;
RandAlc=selectedData.RandAlc.data;
SymmPla= selectedData.SymmPla.data;
RandPla=selectedData.RandPla.data;


DiffAlc = SymmAlc-RandAlc;
DiffPla = SymmPla-RandPla;

GFPDiffAlc = std(DiffAlc);
GFPDiffPla = std(DiffPla);

% This is for checking
if high == 400
    electrodes = [25 27 62 64]; % PO7 O1 O2 PO8
    MSPNAlc =mean(DiffAlc(electrodes));
    MSPNPla =mean(DiffPla(electrodes));
    SPNcheck2a = [MSPNAlc,MSPNPla];
    save('SPNcheck2a','SPNcheck2a');
    GFPDiffChecka =[GFPDiffAlc,GFPDiffPla];
    save('GFPDiffChecka','GFPDiffChecka');
end

if high == 1000
    electrodes = [25 27 62 64]; % PO7 O1 O2 PO8
    MSPNAlc =mean(DiffAlc(electrodes));
    MSPNPla =mean(DiffPla(electrodes));
    SPNcheck2b = [MSPNAlc,MSPNPla];
    save('SPNcheck2b','SPNcheck2b');
    GFPDiffCheckb =[GFPDiffAlc,GFPDiffPla];
    save('GFPDiffCheckb','GFPDiffCheckb');
end

figure('color',[1,1,1])
topoplot(DiffAlc, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffAlc,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Alcohol',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffPla, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffPla,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['Placebo',(num2str(low)),'-',num2str(high),'.png'];
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
