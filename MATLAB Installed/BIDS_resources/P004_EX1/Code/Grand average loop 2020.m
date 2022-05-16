clear all
% DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 4/EX1 Reg or Valence (first 24)';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 4/EX1 Reg or Valence (first 24)/Grand Averages';
cd(folder1);
load timeVector

% SUBJECTS
nSubjects = 24;
skip = [];
subjects = nSubjects-length(skip);

% CONDITIONS
conditionNames = {'RandomGoodValence','RandomBadValence','ReflectionGoodValence','ReflectionBadValence','RandomGoodRegularity','RandomBadRegularity','ReflectionGoodRegularity','ReflectionBadRegularity'};

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
save('grandAverages','grandAverages')
clear