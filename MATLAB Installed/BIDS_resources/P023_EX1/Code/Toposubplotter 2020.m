% topoplots
close all
clear all

% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER.
% YOU NEED TO SET PATH TO EEGLAB
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders/Project 23/Grand Averages'
load timeVector;
load grandAverages;
load channelLocs.mat;

%CONDITIONS
conditionNames={'AntiSymmBW','SymmBW','RandBW','AntiSymmCol','SymmCol','RandCol'};

%GRAPHICAL PROPERTIES
FontSize = 20;
zscale = 3;  
contourRes = 3;

timeWindows= {[-200,-100],[-100 0],[0 100],[100 200],[200 300],[300 400],[400 500],[500 600],[600 700],[700 800],[800 900],[900 1000]}
l=length(timeWindows)
for t =1:l
    
%TIME WINDOWS
w = timeWindows{t}
low = w(1);
high = w(2);
ii = find(timeVector >=low & timeVector <=high);


% SELECT DATA LOOP
for x = 1:length(conditionNames)
    c = conditionNames{x};
    data = getfield(grandAverages, c);
    data = squeeze(mean(data(1:end, ii),2));
    selectedData.(c).data = data;
end


%save('thisTopo','selectedData');
AntiSymmBW=selectedData.AntiSymmBW.data;
SymmBW=selectedData.SymmBW.data;
RandBW= selectedData.RandBW.data;
AntiSymmCol=selectedData.AntiSymmCol.data;
SymmCol=selectedData.SymmCol.data;
RandCol= selectedData.RandCol.data;
DiffAntiSymmBW = AntiSymmBW-RandBW;
DiffSymmBW = SymmBW-RandBW;
DiffAntiSymmCol = AntiSymmCol-RandCol;
DiffSymmCol = SymmBW-RandCol;

figure(1)
A = subplot(2,l/2,t);
topoplot(DiffAntiSymmBW, channelLocs,'numcontour', contourRes);
caxis([-zscale, zscale])


figure(2)
B = subplot(2,l/2,t);
topoplot(DiffSymmBW, channelLocs,'numcontour', contourRes);
caxis([-zscale, zscale])


figure(3)
C = subplot(2,l/2,t);
topoplot(DiffAntiSymmCol, channelLocs,'numcontour', contourRes);
caxis([-zscale, zscale])


figure(4)
D = subplot(2,l/2,t);
topoplot(DiffSymmCol, channelLocs,'numcontour', contourRes);
caxis([-zscale, zscale])



end


saveas(A,'Subplots AntiSymmBW.png');
saveas(B,'Subplots DiffSymmBW.png');
saveas(C,'Subplots DiffAntiSymmCol.png');
saveas(D,'Subplots DiffSymmCol.png');
clear all
close all