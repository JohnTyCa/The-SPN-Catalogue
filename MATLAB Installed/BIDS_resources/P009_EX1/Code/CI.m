clear
% you will need to set this to a directory on your computer
folder1='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX1 Original';
folder2='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX1 Original/Grand Averages';
cd(folder1)
subjects = 24;
%ELECTRODES
%ELECTRODES
leftelectrodes = [20 21 22 23 25 26]; % These will be used if no dogma selected
rightelectrodes = [57 58 59 60 62 63]; % These will be used if no dogma selected

d = input('which dogma?');

if d ==1
    disp 'dogma 1'
    leftelectrodes = [25 27];
    rightelectrodes =[62 64]; 
end

if d ==2
    disp 'dogma 2'
    leftelectrodes = [25];
    rightelectrodes =[62]; 
end

if d == 3
    disp 'dogma 3'
    leftelectrodes = [20 21 22 23 24 25 26 27];
    rightelectrodes = [57 58 59 60 61 62 63 64]; 
end

if d < 1||d> 3
    disp('Original electrodes used');
end

%smoothWindow = 10;

ConfidenceInterval = 0.95;
CIconstant = tinv(1-(1-ConfidenceInterval)/2,subjects-1);


conditionNames={'REFRAND','RANDREF'};
for i = 1:subjects
    for x = 1:length(conditionNames)
        c = conditionNames{x};
        k = num2str(i);
        n = ['S',k,c,'AVG.mat'];
        load(n)
        dataLeft = mean(condAVG(leftelectrodes,1:end),1)';
        dataRight = mean(condAVG(rightelectrodes,1:end),1)';
        %data = smooth(data,smoothWindow,'moving'); % could pre-smooth for
        %each subject here. 
        ERPerrorLeft.(c).amplitudes(i,:) = dataLeft';
        ERPerrorRight.(c).amplitudes(i,:) = dataRight';
    end  
end


% What diffrence waves do you want? 

ERPerrorLeft.SPNLeft.amplitudes = ERPerrorLeft.RANDREF.amplitudes- ERPerrorLeft.REFRAND.amplitudes;
ERPerrorRight.SPNRight.amplitudes = ERPerrorRight.REFRAND.amplitudes-ERPerrorRight.RANDREF.amplitudes;



conditionNames = {'RANDREF','RANDREF','SPNLeft'};
for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerrorLeft.(c).SD = std(ERPerrorLeft.(c).amplitudes)';
        ERPerrorLeft.(c).SEM = (ERPerrorLeft.(c).SD)/sqrt(subjects)';
        ERPerrorLeft.(c).CI = (ERPerrorLeft.(c).SEM)*CIconstant';
end

conditionNames = {'RANDREF','RANDREF','SPNRight'};
for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerrorRight.(c).SD = std(ERPerrorRight.(c).amplitudes)';
        ERPerrorRight.(c).SEM = (ERPerrorRight.(c).SD)/sqrt(subjects)';
        ERPerrorRight.(c).CI = (ERPerrorRight.(c).SEM)*CIconstant';
end


cd(folder2);
save('ERPerrorLeft','ERPerrorLeft');
save('ERPerrorRight','ERPerrorRight');
clear all