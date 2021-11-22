function [PROJECT,EXP,CAT,APPENDIX,VALIDATE] = CreateSimplifiedCatalogue()

% ======================================================= %
% Read CAT_ORIG file.
% ======================================================= %

CAT_ORIG = readtable('Catalogue.csv');

APPENDIX_opts = detectImportOptions('Appendix.csv');
APPENDIX_opts = setvaropts(APPENDIX_opts,{'SET_Suffix' 'SET_ICA_Suffix' 'SET_ICA_Max_Suffix'},'WhiteSpaceRule','preserve');
APPENDIX = readtable('Appendix.csv',APPENDIX_opts);

% ======================================================= %
% Remove NaN rows.
% ======================================================= %

CAT_ORIG(find(isnan(table2array(CAT_ORIG(2:end,1))))+1,:) = [];

% ======================================================= %
% Let's get the mean SPN for the original clusters to do
% some validation later.
% ======================================================= %

VALIDATE = table(CAT_ORIG.ProjectFolder, CAT_ORIG.SubFolder, CAT_ORIG.SPNID, CAT_ORIG.M, CAT_ORIG.SD, CAT_ORIG.M_1,CAT_ORIG.M_2,CAT_ORIG.M_3,CAT_ORIG.D,'VariableNames',{'Project' 'Experiment' 'SPNID' 'MeanSPN' 'SPN_SD' 'MeanSPN1' 'MeanSPN2' 'MeanSPN3' 'D'});

% ======================================================= %
% We are only interested in certain columns of CAT_ORIG. Some
% columns have duplicate names so we need to avoid them.
% ======================================================= %

CAT_ORIG = CAT_ORIG(:,1:26);

% ======================================================= %
% Extract appropriate columns and rename as necessary.
% ======================================================= %

Titles = CAT_ORIG.Properties.VariableNames;
%             Titles = CAT_ORIG(1,:);
ColsToKeep = find(~cell2mat(cellfun(@(x) isnumeric(x), Titles, 'UniformOutput',false)));
Titles = Titles(ColsToKeep);
ColToRename = find(cellfun(@(x) ~isempty(str2num(x(1))),Titles));
Titles(ColToRename) = cellfun(@(x) ['C' x],Titles(ColToRename),'UniformOutput',false);
Titles = strrep(strrep(strrep(Titles,' ',''),'.','_'),'%','');

% ======================================================= %
% Extract appropriate portion of catlogue.
% ======================================================= %

CAT_ORIG = CAT_ORIG(:,ColsToKeep);
CAT_ORIG = table2struct(CAT_ORIG);

% ======================================================= %
% Create simplified catalogue.
% ======================================================= %

CAT = table();

CAT.SPNID = [CAT_ORIG.SPNID]';
CAT.Project = [CAT_ORIG.ProjectFolder]';

for iCond = 1:length(CAT_ORIG)
    CAT.Experiment{iCond,1} = strrep(strrep(CAT_ORIG(iCond).SubFolder,'N/A','EX1'),'Sup EX','SX');
    CAT.Experiment{iCond,1} = CAT.Experiment{iCond,1}(1:3);
    CAT.Full_Name{iCond,1} = ['P' nDigitString(CAT.Project(iCond,1),3) '_' CAT.Experiment{iCond,1}];
end

CAT.Experiment_Folder = {CAT_ORIG.SubFolder}';

CAT.N = [CAT_ORIG.NInCondition]';
CAT.AKA = {CAT_ORIG.NickName}';
CAT.Year = {CAT_ORIG.Year}';
CAT.Regular_Condition = {CAT_ORIG.Regular}';
CAT.Irregular_Condition = {CAT_ORIG.LessRegularComparision}';

CAT.Electrodes_Original = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.OriginalElectrodeCluster},'UniformOutput',false)';
CAT.Electrodes_Cluster_1 = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.Cluster1},'UniformOutput',false)';
CAT.Electrodes_Cluster_2 = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.Cluster2},'UniformOutput',false)';
CAT.Electrodes_Cluster_3 = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.Cluster3},'UniformOutput',false)';
CAT.Electrodes_Custom = cellfun(@(x) strsplit(x,{',',' '}), {CAT_ORIG.OriginalElectrodeCluster},'UniformOutput',false)';
CAT.Window_Original = cellfun(@(x) strsplit(x,{',' ' ' '-'}), {CAT_ORIG.OriginalTimeWindow},'UniformOutput',false)';
% CAT.Window_Cluster = cellfun(@(x) strsplit(x,{',' ' ' '-'}), {CAT_ORIG.TimeWindowForClusters},'UniformOutput',false)';
CAT.Window_Custom = cellfun(@(x) strsplit(x,{',' ' ' '-'}), {CAT_ORIG.OriginalTimeWindow},'UniformOutput',false)';

CAT.Attend_Regularity = [CAT_ORIG.AttendRegularity]';
CAT.W = [CAT_ORIG.WCalculation]';
CAT.SPN = VALIDATE.MeanSPN;
CAT.SD = VALIDATE.SPN_SD;
CAT.D = VALIDATE.D;
CAT.SPN1 = VALIDATE.MeanSPN1;
CAT.SPN2 = VALIDATE.MeanSPN2;
CAT.SPN3 = VALIDATE.MeanSPN3;

CAT.Regular_Prefix = APPENDIX.Prefix_Regular;
CAT.Irregular_Prefix = APPENDIX.Prefix_Irregular;

CAT.Regular_Prefix_AllData = APPENDIX.Prefix_Regular_AllData;
CAT.Irregular_Prefix_AllData = APPENDIX.Prefix_Irregular_AllData;

CAT.Time_Vector_Name = APPENDIX.TimeVectorName;

CAT.Post_AVG_Suffix = APPENDIX.PostAVGSuffix;
CAT.Post_AVG_Suffix_AllData = APPENDIX.PostAVGSuffix_AllData;

CAT.Skip_Subjects = cellfun(@(x) strsplit(x,'; '),APPENDIX.SkipSubjects,'UniformOutput',false);
CAT.Skip_Subjects = cellfun(@(x) cellfun(@str2num,x,'UniformOutput',false),CAT.Skip_Subjects,'UniformOutput',false);

CAT.Skip_Subjects_AllData = cellfun(@(x) strsplit(x,'; '),APPENDIX.SkipSubjects_AllData,'UniformOutput',false);
CAT.Skip_Subjects_AllData = cellfun(@(x) cellfun(@str2num,x,'UniformOutput',false),CAT.Skip_Subjects_AllData,'UniformOutput',false);

CAT.Folder_Override = cellfun(@(x) strsplit(x,'; '), APPENDIX.FolderOverride,'UniformOutput',false);
CAT.Folder_Override_AllData = cellfun(@(x) strsplit(x,'; '), APPENDIX.FolderOverride_AllData,'UniformOutput',false);

CAT.Condition_Name_Override = APPENDIX.ConditionOverride;

CAT.Two_Digit_Subject_String = APPENDIX.Two_Digit_Subject_String_Original;
CAT.Two_Digit_Subject_String_AllData = APPENDIX.Two_Digit_Subject_String_AllData;

CAT.SET_Suffix = APPENDIX.SET_Suffix;
CAT.SET_ICA_Suffix = APPENDIX.SET_ICA_Suffix;
CAT.SET_ICA_Max_Suffix = APPENDIX.SET_ICA_Max_Suffix;

CAT.Task_Names = APPENDIX.Task_Names;
CAT.File_Notes = APPENDIX.File_Notes;

CAT = table2struct(CAT);

% ======================================================= %
% Produce Projects.
% ======================================================= %

UniqueProjects = unique([CAT.Project]);

PROJECT = struct();
Count = 0;
for iProject = 1:length(UniqueProjects)
    
    CurrentProjectIndices = [CAT.Project] == UniqueProjects(iProject);
    CurrentProjectCond = CAT(CurrentProjectIndices);
    
    PROJECT(iProject).Project = CurrentProjectCond(1).Project;
    PROJECT(iProject).Experiment = {CurrentProjectCond.Experiment};
    PROJECT(iProject).Full_Name = {CurrentProjectCond.Full_Name};
    PROJECT(iProject).N = [CurrentProjectCond.N];
    PROJECT(iProject).SPNID = [CurrentProjectCond.SPNID];
    PROJECT(iProject).Regular_Condition = {CurrentProjectCond.Regular_Condition};
    PROJECT(iProject).W = [CurrentProjectCond.W];
    PROJECT(iProject).Attend_Regularity = [CurrentProjectCond.Attend_Regularity];
    
end

% ======================================================= %
% Produce Experiments.
% ======================================================= %

UniqueExperiments = unique({CAT.Full_Name});

EXP = struct();
Count = 0;
for iExp = 1:length(UniqueExperiments)
    
    CurrentExperimentIndices = strcmp({CAT.Full_Name},UniqueExperiments{iExp});
    CurrentExperimentCond = CAT(CurrentExperimentIndices);
    
    EXP(iExp).Project = CurrentExperimentCond(1).Project;
    EXP(iExp).Experiment = CurrentExperimentCond(1).Experiment;
    EXP(iExp).Full_Name = CurrentExperimentCond(1).Full_Name;
    EXP(iExp).N = CurrentExperimentCond(1).N;
    EXP(iExp).SPNID = [CurrentExperimentCond.SPNID];
    EXP(iExp).Regular_Condition = {CurrentExperimentCond.Regular_Condition};
    EXP(iExp).W = [CurrentExperimentCond.W];
    EXP(iExp).Attend_Regularity = [CurrentExperimentCond.Attend_Regularity];
    
end

end