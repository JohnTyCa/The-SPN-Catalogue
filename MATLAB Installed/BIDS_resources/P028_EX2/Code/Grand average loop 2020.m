clear all

%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 28/EX2 rotation';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 28/EX2 rotation/Grand Averages';
cd(folder1);
load timeVector

%SUBJECTS
nSubjects = 28;
skip=[];
subjects = nSubjects-length(skip)

%CONDITIONS 
conditionNames = {'Symmetry','Asymmetry'};  

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'AVG.mat'];
        
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/(subjects); 
end

cd(folder2);
save('grandAverages','grandAverages');

clear all 


