clear
%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 31/EX1 Shape';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 31/EX1 Shape/Grand Averages';
cd(folder1)
load timeVector

%SUBJECTS
nSubjects = 28;
skip = []
subjects = nSubjects-length(skip)

%CONDITIONS
conditionNames ={'SymmetrySame','SymmetryNovel','AsymmetrySame','AsymmetryNovel'}; % 1x4 cell arrays

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
        if ismember(s,skip)
        disp(['not in GrandAverage:' num2str(s)])
        continue
        end
        %disp(['present in GrandAverage:' num2str(s)])
        
        k = num2str(s);
        n = ['S',k,condName,'AVG.mat'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/(subjects);
    clear g
end

cd(folder2);

save('grandAverages','grandAverages');

clear all


