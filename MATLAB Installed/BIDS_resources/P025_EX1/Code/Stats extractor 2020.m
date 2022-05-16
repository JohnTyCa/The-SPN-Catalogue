clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX1 Color and Shape';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX1 Color and Shape/Grand Averages';
cd(folder1);

%SUBJECTS
subjects = 24;
%skip = [8 16 21];
skip = []
% CONDITIONS
conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};

%TIME WINDOWS
low = 250
high = 450

% low = 450
% high = 750

% low = 300
% high = 400

load timeVector
%load timeVectorSamplePlusProbe
ii = find(timeVector >=low & timeVector <=high);


%ELECTRODES
electrodes =[25 27 62 64];  % These will be used if no dogma selected
d = input('which dogma?')

if d ==1;
    display 'dogma 1'
    electrodes = [62 64 27 25]; 
end

if d ==2;
    display 'dogma 2'
    electrodes = [25 62]; 
end

if d ==3;
    display 'dogma 3'
    electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64]; 
end

if d == 4;
    display 'dogmatic left'
    electrodes = [25 27]; 
end

if d == 5;
    display 'dogmatic right'
    electrodes = [62 64];
end

if d < 1|d> 5;
    display('Original electrodes used');
end

%LOOP

for c = 1:length(conditionNames)
    p = 0;
    for i = 1:subjects;
        if ismember(i,skip)
            continue
        end
        p = p+1;
        k = num2str(i); 
        n = ['S',k,conditionNames{c},'AVG.mat'];
        %n = ['S',k,conditionNames{c},'NoICAAVG.mat'];
        %n = ['S',k,'SamplePlusProbe',conditionNames{c},'AVG'];
        load(n);
        Results(p,c) = mean(mean(condAVG(electrodes,ii)));
        clear condAVG
    end
end

%SAVE and RELOAD
cd(folder2)
save('Results','Results');
clear all
load 'Results';


