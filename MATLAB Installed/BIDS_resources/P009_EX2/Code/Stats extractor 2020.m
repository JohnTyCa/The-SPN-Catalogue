clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX2 One Sided';
folder2='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX2 One Sided/Grand Averages';
cd(folder1);

%SUBJECTS
subjects = 24;
skip = []

%CONDITIONS
conditionNames={'REFNOTHING','RANDNOTHING','NOTHINGREF','NOTHINGRAND'};
%conditionNames={'REFNOTHINGDARK','RANDNOTHINGDARK','NOTHINGREFDARK','NOTHINGRANDDARK','REFNOTHINGLIGHT','RANDNOTHINGLIGHT','NOTHINGREFLIGHT','NOTHINGRANDLIGHT'};


%TIME WINDOWS

low = 200
high = 600

% low = 600
% high = 1000
% 
% low = 300
% high = 400 
% 
% low = 600
% high = 1000

load timeVector
ii = find(timeVector >=low & timeVector <=high);

%ELECTRODES
leftelectrodes = [20 21 22 23 25 26]; % These will be used if no dogma selected
rightelectrodes = [57 58 59 60 62 63]; % These will be used if no dogma selected

d = input('which dogma?')

if d ==1;
    display 'dogma 1'
    leftelectrodes = [25 27];
    rightelectrodes =[62 64]; 
end

if d ==2;
    display 'dogma 2'
    leftelectrodes = [25];
    rightelectrodes =[62]; 
end

if d == 3;
    display 'dogma 3'
    leftelectrodes = [20 21 22 23 24 25 26 27];
    rightelectrodes = [57 58 59 60 61 62 63 64]; 
end

if d < 1|d> 3;
    display('Original electrodes used');
end

% LOOP
for c = 1:length(conditionNames)
    p=0;
    for i = 1:subjects;
        if ismember(i,skip)
            continue
        end
        p = p+1;
        k = num2str(i); 
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n);
        Results(p,c) = mean(mean(condAVG(leftelectrodes,ii)));
        Results(p,c+length(conditionNames)) = mean(mean(condAVG(rightelectrodes,ii)));
    end
end

% SAVE AND RELOAD
cd(folder2);
Results = Results(:,[3:6]);
save('Results','Results');
clear all
load 'Results'



