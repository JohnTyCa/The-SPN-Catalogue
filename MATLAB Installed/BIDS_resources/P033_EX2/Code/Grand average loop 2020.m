clear
%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 33/EX2 Luminance';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 33/EX2 Luminance/Grand Averages';
cd(folder1)
load timeVector

%SUBJECTS
nSubjects = 16;
skip  =[];
subjects = nSubjects-length(skip)

% CONDITIONS
conditionNames={'RandFlatGabors','SymFlatGabors','RandSlantGabors','SymSlantGabors','RandFlatSolidPoly','SymFlatSolidPoly','RandSlantSolidPoly','SymSlantSolidPoly'};

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
save('grandAverages','grandAverages')

clear



