clear
%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 11/Sup Ex1';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 11/Sup Ex1/Grand Averages';
cd(folder1)
load timeVector


nSubjects = 36;
skip = [];
subjects = nSubjects-length(skip)


%CONDITIONS
conditionNames={'SymmetryShort','RandomShort','SymmetryMedium','RandomMedium','SymmetryLong','RandomLong'};


%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
       
        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'AVG'];
        load(n)
        g = g+condAVG;
        clear condAVG
    end
    grandAverages.(condName) =  g/subjects;
    clear g
end

cd(folder2);
save('grandAverages','grandAverages');
clear;