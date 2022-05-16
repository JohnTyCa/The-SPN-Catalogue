close all
clear all
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 11/Sup Ex1/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;
load cmocean;
%CONDITIONS
conditionNames={'SymmetryShort','RandomShort','SymmetryMedium','RandomMedium','SymmetryLong','RandomLong'};

%TIME WINDOWS
low = 200;
high = 350;
% 
low = 200;
high = 550;
% % %  % % % 
low = 200;
high = 1050;


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
SymmetryShort = selectedData.SymmetryShort.data;
RandomShort = selectedData.RandomShort.data;
SymmetryMedium = selectedData.SymmetryMedium.data;
RandomMedium = selectedData.RandomMedium.data;
SymmetryLong = selectedData.SymmetryLong.data;
RandomLong = selectedData.RandomLong.data;

DiffSymmetryShort = SymmetryShort-RandomShort;
DiffSymmetryMedium = SymmetryMedium-RandomMedium;
DiffSymmetryLong = SymmetryLong-RandomLong;
GFPDiffSymmetryShort = std(DiffSymmetryShort);
GFPDiffSymmetryMedium = std(DiffSymmetryMedium);
GFPDiffSymmetryLong = std(DiffSymmetryLong);

%%%%%%%%%% this is for checking
electrodes = [25 62]; % These will be used if no dogma selected

if high == 350
    ShortSPNcheck =mean(DiffSymmetryShort(electrodes));
    save('ShortSPNcheck2','ShortSPNcheck');
    ShortGFPDiffCheck = GFPDiffSymmetryShort;
    save('ShortGFPDiffCheck','ShortGFPDiffCheck');
end
    
if high == 550
    MediumSPNcheck =mean(DiffSymmetryMedium(electrodes));
    save('MediumSPNcheck2','MediumSPNcheck');
    MediumGFPDiffCheck = GFPDiffSymmetryMedium;
    save('MediumGFPDiffCheck','MediumGFPDiffCheck');
end


if high == 1050
    LongSPNcheck =mean(DiffSymmetryLong(electrodes));
    save('LongSPNcheck2','LongSPNcheck');
    LongGFPDiffCheck = GFPDiffSymmetryLong;
    save('LongGFPDiffCheck','LongGFPDiffCheck');
end
%%%%%%%%


figure('color',[1,1,1])
topoplot(DiffSymmetryShort, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymmetryShort,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryShort',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);


figure('color',[1,1,1])
topoplot(DiffSymmetryMedium, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymmetryMedium,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryMedium',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

figure('color',[1,1,1])
topoplot(DiffSymmetryLong, channelLocs,'numcontour', contourRes,'colormap',cmocean);
caxis([-zscale, zscale])
colorbar('FontSize',FontSize)
t =['GFP=',num2str(round(GFPDiffSymmetryLong,3))];
title(t,'FontSize',FontSize,'fontweight','normal');
toponame = ['SymmetryLong',(num2str(low)),'-',num2str(high),'.png'];
saveas(gcf,toponame);

clear all

load ShortSPNcheck2
load MediumSPNcheck2
load LongSPNcheck2

SPNcheck = [ShortSPNcheck,MediumSPNcheck,LongSPNcheck];
save('SPNcheck2','SPNcheck');

load ShortGFPDiffCheck
load MediumGFPDiffCheck
load LongGFPDiffCheck

GFPDiffCheck = [ShortGFPDiffCheck,MediumGFPDiffCheck,LongGFPDiffCheck];

save('GFPDiffCheck','GFPDiffCheck');