clear
%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX2 Symm probe Symm';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX2 Symm probe Symm/Grand Averages';
cd(folder1)
load timeVector

%SUBJECTS
nSubjects = 24;
skip = [];
subjects = nSubjects-length(skip);

%CONDITIONS
conditionNames={'SymmetryMemory','RandomMemory','SymmetryPassive','RandomPassive'};

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
clear all



% 
% clear
% %DIRECTORY
% folder1 = '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX2 Symm probe Symm'
% folder2 = '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX2 Symm probe Symm/Grand Averages'
% cd(folder1)
% load timeVector
% 
% %SUBJECTS
% nSubjects = 24;
% skip = [];
% subjects = nSubjects-length(skip);
% 
% %CONDITIONS
% conditionNames={'SymmetryMemory','RandomMemory','SymmetryPassive','RandomPassive'};
% 
% %LOOP
% for c = 1:length(conditionNames);
%     g = zeros(64,length(timeVector));
%     condName = conditionNames{c};
%     for s = 1:nSubjects
%        
%         if ismember(s,skip)
%             continue
%         end
%         k = num2str(s);
%         n = ['S',k,condName,'NoICAAVG'];
%         load(n)
%         g = g+condAVG;
%         clear condAVG
%     end
%     grandAverages.(condName) =  g/subjects;
%     clear g
% end
% 
% cd(folder2);
% save('grandAveragesNoICA','grandAverages')
% clear all
% 
% 
% 
% clear
% %DIRECTORY
% folder1 = '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX2 Symm probe Symm'
% folder2 = '/Volumes/SPN Catalog/Expanded Catalogue/Project 25/EX2 Symm probe Symm/Grand Averages'
% cd(folder1)
% load timeVectorSamplePlusProbe
% 
% %SUBJECTS
% nSubjects = 24;
% skip = [];
% subjects = nSubjects-length(skip);
% 
% %CONDITIONS
% conditionNames={'SymmetryMemory','RandomMemory','SymmetryPassive','RandomPassive'};
% 
% %LOOP
% for c = 1:length(conditionNames);
%     g = zeros(64,length(timeVector));
%     condName = conditionNames{c};
%     for s = 1:nSubjects
%        
%         if ismember(s,skip)
%             continue
%         end
%         k = num2str(s);
%         n = ['S',k,'SamplePlusProbe',condName,'AVG'];
%         load(n)
%         g = g+condAVG;
%         clear condAVG
%     end
%     grandAverages.(condName) =  g/subjects;
%     clear g
% end
% 
% cd(folder2);
% save('grandAveragesSamplePlusProbe','grandAverages')
% clear all