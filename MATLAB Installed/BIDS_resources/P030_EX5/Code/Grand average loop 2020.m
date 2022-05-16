clear
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 30/EX5 Gerbino PNG1and3';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 30/EX5 Gerbino PNG1and3/Grand Averages';
cd(folder1)
load timeVector

nSubjects = 30;
skip  =[];
subjects = nSubjects-length(skip)

conditionNames = {'RandomConvex1','RandomConcave1','RefConvex1','RefConcave1','RandomConvex3','RandomConcave3','RefConvex3','RefConcave3'};

%LOOP
for c = 1:length(conditionNames);
    g = zeros(64,length(timeVector));
    condName = conditionNames{c};
    for s = 1:nSubjects
       
        if ismember(s,skip)
            continue
        end
        k = num2str(s);
        n = ['S',k,condName,'AVGBF'];
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


