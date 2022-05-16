clear all
% DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 4/EX2 both (surviving 17)';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 4/EX2 both (surviving 17)/Grand Averages';
cd(folder1);
load timeVector

% SUBJECTS
nSubjects = 24;
skip  =[4 6 12 15 18 20 23]; % a few participants were lost from this project. Rampone et al. (2014) report the results from 24. 
subjects = nSubjects-length(skip);

% CONDITIONS
conditionNames = {'Reflection','Random'};

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
       
        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAverages','grandAverages');
clear
