clear
%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 24';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 24/Grand Averages';
cd(folder1);
load timeVector

%SUBJECTS
nSubjects = 48;
skip = [];
subjects = nSubjects-length(skip)

%CONDITIONS
conditionNames={'LCRandRand','RCRandRand','LCRandSymm','RCRandSymm','LCSymmRand','RCSymmRand'};

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
        
        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        %n = ['S',k,conditionNames{c},'EyeFiltered2point5AVG.mat']; % used to be called this
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAverages','grandAverages')
clear all