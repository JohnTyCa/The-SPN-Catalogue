function [Condition_Data, Error] = ExtractConditionData(CAT,DataDir,SPNID,InfoOnly,varargin)

% varargin input order:
%
% varargin{1} = BDF
% varargin{2} = SET (Epoched)
% varargin{3} = SET (Epoched, ICA)
% varargin{4} = SET (Epoched, ICA, Max)
% varargin{5} = TriggerInfo

if length(varargin) == 0
    varargin = {0 0 0 0 0};
elseif length(varargin) == 1
    varargin = {varargin{1} 0 0 0};
elseif length(varargin) == 2
    varargin = {varargin{1} varargin{2} 0 0};
elseif length(varargin) == 3
    varargin = {varargin{1} varargin{2} varargin{3} 0};
elseif length(varargin) == 4
    varargin = {varargin{1} varargin{2} varargin{3} varargin{4} 0};
end

Condition_Data = CAT([CAT.SPNID] == SPNID);

% ======================================================= %
% Check existence of the REGULARITY condition files.
% ======================================================= %

Error = 0;

% =============================================== %
% The suffix is defined based on the corresponding
% SUFFIX from the CONDITIONS file.
% =============================================== %

Prefix_Reg = Condition_Data.Regular_Prefix;
Prefix_Irreg = Condition_Data.Irregular_Prefix;

Prefix_Reg_AllData = Condition_Data.Regular_Prefix_AllData;
Prefix_Irreg_AllData = Condition_Data.Irregular_Prefix_AllData;

PostAVGSuffix = Condition_Data.Post_AVG_Suffix;
PostAVGSuffix_AllData = Condition_Data.Post_AVG_Suffix_AllData;

Suffix_Reg = [Prefix_Reg 'AVG' PostAVGSuffix '.mat'];
Suffix_Irreg = [Prefix_Irreg 'AVG' PostAVGSuffix '.mat'];

Suffix_Reg_AllData = [Prefix_Reg_AllData PostAVGSuffix_AllData '.set'];
Suffix_Irreg_AllData = [Prefix_Irreg_AllData PostAVGSuffix_AllData '.set'];

% =============================================== %
% The folder depends on whether there were multiple
% experiments for the project. For example, if
% there was more than one experiment, the path is
% directed to the corresponding sub folder in the
% PROJECT folder.
% =============================================== %

Folder = {};
if ~isempty(Condition_Data.Folder_Override{1})
    for iFolder = 1:length(Condition_Data.Folder_Override)
        Folder{iFolder} = [DataDir filesep 'Project ' num2str(Condition_Data.Project) filesep Condition_Data.Folder_Override{iFolder} filesep];
    end
elseif strcmp(Condition_Data.Experiment_Folder,'N/A')
    Folder{1} = [DataDir filesep 'Project ' num2str(Condition_Data.Project) filesep];
else
    Folder{1} = [DataDir filesep 'Project ' num2str(Condition_Data.Project) filesep Condition_Data.Experiment_Folder filesep];
end

Folder_AllData = {};
if ~isempty(Condition_Data.Folder_Override_AllData{1})
    for iFolder = 1:length(Condition_Data.Folder_Override_AllData)
        Folder_AllData{iFolder} = [DataDir filesep 'Project ' num2str(Condition_Data.Project) 'alldata' filesep Condition_Data.Folder_Override_AllData{iFolder} filesep];
    end
elseif strcmp(Condition_Data.Experiment_Folder,'N/A')
    Folder_AllData{1} = [DataDir filesep 'Project ' num2str(Condition_Data.Project) 'alldata' filesep];
else
    Folder_AllData{1} = [DataDir filesep 'Project ' num2str(Condition_Data.Project) 'alldata' filesep Condition_Data.Experiment_Folder filesep];
end

% =============================================== %
% We extract the subject numbers that are in the
% project folder.
% =============================================== %

SubjectNumbers_Reg = {}; SubjectFiles_Reg = {};
SubjectNumbers_Irreg = {}; SubjectFiles_Irreg = {};
for iFolder = 1:length(Folder)
    [SubjectNumbers_Reg{iFolder}, SubjectFiles_Reg{iFolder}] = CheckFileExistence(Folder{iFolder},Suffix_Reg,Condition_Data.Two_Digit_Subject_String);
    [SubjectNumbers_Irreg{iFolder}, SubjectFiles_Irreg{iFolder}] = CheckFileExistence(Folder{iFolder},Suffix_Irreg,Condition_Data.Two_Digit_Subject_String);
end

SubjectNumbers_Reg_AllData = {}; SubjectFiles_Reg_AllData = {};
SubjectNumbers_Irreg_AllData = {}; SubjectFiles_Irreg_AllData = {};
for iFolder = 1:length(Folder_AllData)
    [SubjectNumbers_Reg_AllData{iFolder}, SubjectFiles_Reg_AllData{iFolder}] = CheckFileExistence(Folder_AllData{iFolder},Suffix_Reg_AllData,Condition_Data.Two_Digit_Subject_String_AllData);
    [SubjectNumbers_Irreg_AllData{iFolder}, SubjectFiles_Irreg_AllData{iFolder}] = CheckFileExistence(Folder_AllData{iFolder},Suffix_Irreg_AllData,Condition_Data.Two_Digit_Subject_String_AllData);
end

% =============================================== %
% Delete subjects present in the SKIP column.
% =============================================== %

for iFolder = 1:length(Folder)
    
    try
        SubjectsToSkip = Condition_Data.Skip_Subjects{iFolder};
    catch
        SubjectsToSkip = [];
    end
    
    DeleteIndices_Reg = ismember(SubjectNumbers_Reg{iFolder},SubjectsToSkip);
    SubjectNumbers_Reg{iFolder}(DeleteIndices_Reg) = [];
    SubjectFiles_Reg{iFolder}(DeleteIndices_Reg) = [];
    
    DeleteIndices_Irreg = ismember(SubjectNumbers_Irreg{iFolder},SubjectsToSkip);
    SubjectNumbers_Irreg{iFolder}(DeleteIndices_Irreg) = [];
    SubjectFiles_Irreg{iFolder}(DeleteIndices_Irreg) = [];
    
end

for iFolder = 1:length(Folder_AllData)
    
    try
        SubjectsToSkip = Condition_Data.Skip_Subjects_AllData{iFolder};
    catch
        SubjectsToSkip = [];
    end
    
    DeleteIndices_Reg = ismember(SubjectNumbers_Reg_AllData{iFolder},SubjectsToSkip);
    SubjectNumbers_Reg_AllData{iFolder}(DeleteIndices_Reg) = [];
    SubjectFiles_Reg_AllData{iFolder}(DeleteIndices_Reg) = [];
    
    DeleteIndices_Irreg = ismember(SubjectNumbers_Irreg_AllData{iFolder},SubjectsToSkip);
    SubjectNumbers_Irreg_AllData{iFolder}(DeleteIndices_Irreg) = [];
    SubjectFiles_Irreg_AllData{iFolder}(DeleteIndices_Irreg) = [];
    
end

% =============================================== %
% Compare subject numbers between different project
% folders for same exeriment.
% =============================================== %

if varargin{1} | varargin{2} | varargin{3} | varargin{4}
    
    if length(cat(2,SubjectNumbers_Reg{:})) ~= length(cat(2,SubjectNumbers_Reg_AllData{:}))
        disp(['Subject numbers not the same between original folder and alldata - ' Condition_Data.Full_Name ' (SPN ' num2str(Condition_Data.SPNID) ' Regular Condition)!']);
        disp(['Original Folder = ' num2str(cat(2,SubjectNumbers_Reg{:}))]);
        disp(['AllData Folder = ' num2str(cat(2,SubjectNumbers_Reg_AllData{:}))]);
        Error = 1;
    end
    
    if length(cat(2,SubjectNumbers_Irreg{:})) ~= length(cat(2,SubjectNumbers_Irreg_AllData{:}))
        disp(['Subject numbers not the same between original folder and alldata - ' Condition_Data.Full_Name ' (SPN ' num2str(Condition_Data.SPNID) ' Irregular Condition)!']);
        disp(['Original Folder = ' num2str(cat(2,SubjectNumbers_Reg{:}))]);
        disp(['AllData Folder = ' num2str(cat(2,SubjectNumbers_Reg_AllData{:}))]);
        Error = 1;
    end
    
end

% =============================================== %
% We configure some output depending on what we
% would expect. We would expect the SUBJECTNUMBERS
% to correspond to the expected number in the
% catalogue.
% =============================================== %

if Condition_Data.N ~= length(cat(2,SubjectNumbers_Reg{:})) |  Condition_Data.N ~= length(cat(2,SubjectNumbers_Irreg{:}))
    disp(['Catalogue reports ' num2str(Condition_Data.N) ' subjects, but ' num2str(length(cat(2,SubjectNumbers_Reg{:}))) ' were found for [' Condition_Data.Full_Name '] - [SPN ' num2str(Condition_Data.SPNID) ' ' Condition_Data.Regular_Prefix ']']);
    disp(['Subjects Found = ' num2str(cat(2,SubjectNumbers_Reg{:}))]);
    disp(['Catalogue reports ' num2str(Condition_Data.N) ' subjects, but ' num2str(length(cat(2,SubjectNumbers_Irreg{:}))) ' were found for [' Condition_Data.Full_Name '] - [SPN ' num2str(Condition_Data.SPNID) ' ' Condition_Data.Irregular_Prefix ']'])
    disp(['Subjects Found = ' num2str(cat(2,SubjectNumbers_Irreg{:}))]);
    Error = 1;
elseif ~all(cat(2,SubjectNumbers_Reg{:}) == cat(2,SubjectNumbers_Irreg{:}))
    disp(['Subject numbers for [' Condition_Data.Full_Name '] - [SPN ' num2str(num2str(Condition_Data.SPNID)) ' ' Condition_Data.Regular_Prefix '] do not match numbers for [' Condition_Data.Full_Name '] - [SPN ' num2str(num2str(Condition_Data.SPNID)) ' ' Condition_Data.Irregular_Prefix ']']);
    Error = 1;
end

% =========================================== %
% We can assume the BDF files have the same subject numbers as
% the set files, so we just use those subject numbers.
% =========================================== %

BDF_Files = {};
if varargin{1}
    for iFolder = 1:length(Folder_AllData)
        for iSub = 1:length(SubjectNumbers_Reg_AllData{iFolder})
            if Condition_Data.Two_Digit_Subject_String_AllData
                BDF_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep '*.bdf']);
            else
                BDF_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) filesep '*.bdf']);
            end
            if isempty(BDF_Files{iFolder}{iSub})
                disp(['No BDF file present for ' Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep]);
                Error = 1;
            end
        end
    end
end

% =========================================== %
% We can assume the SET files have the same subject numbers as
% the set files, so we just use those subject numbers.
% =========================================== %

% SET (Epoched).

SET_Epoched_Files = {};
if varargin{2}
    if isempty(Condition_Data.SET_Suffix)
        disp(['No SET file (Epoched) listed in APPENDIX for ' Condition_Data.Full_Name]);
        Error = 1;
    else
        for iFolder = 1:length(Folder_AllData)
            for iSub = 1:length(SubjectNumbers_Reg_AllData{iFolder})
                if Condition_Data.Two_Digit_Subject_String_AllData
                    SET_Epoched_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) Condition_Data.SET_Suffix]);
                else
                    SET_Epoched_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) filesep 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) Condition_Data.SET_Suffix]);
                end
                if isempty(SET_Epoched_Files{iFolder}{iSub})
                    disp(['No SET file (Epoched) present for ' Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep]);
                    Error = 1;
                end
            end
        end
    end
end

% SET (Epoched, ICA).

SET_Epoched_ICA_Files = {};
if varargin{3}
    if isempty(Condition_Data.SET_ICA_Suffix)
        disp(['No SET file (Epoched, ICA) listed in APPENDIX for ' Condition_Data.Full_Name]);
        Error = 1;
    else
        for iFolder = 1:length(Folder_AllData)
            for iSub = 1:length(SubjectNumbers_Reg_AllData{iFolder})
                if Condition_Data.Two_Digit_Subject_String_AllData
                    SET_Epoched_ICA_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) Condition_Data.SET_ICA_Suffix]);
                else
                    SET_Epoched_ICA_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) filesep 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) Condition_Data.SET_ICA_Suffix]);
                end
                if isempty(SET_Epoched_ICA_Files{iFolder}{iSub})
                    disp(['No SET file (Epoched, ICA) present for ' Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep]);
                    Error = 1;
                end
            end
        end
    end
end

% SET (Epoched, ICA, Max).

SET_Epoched_ICA_Max_Files = {};
if varargin{4}
    if isempty(Condition_Data.SET_ICA_Max_Suffix)
        disp(['No SET file (Epoched, ICA, Max) listed in APPENDIX for ' Condition_Data.Full_Name]);
        Error = 1;
    else
        for iFolder = 1:length(Folder_AllData)
            for iSub = 1:length(SubjectNumbers_Reg_AllData{iFolder})
                if Condition_Data.Two_Digit_Subject_String_AllData
                    SET_Epoched_ICA_Max_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) Condition_Data.SET_ICA_Max_Suffix]);
                else
                    SET_Epoched_ICA_Max_Files{iFolder}{iSub} = dir([Folder_AllData{iFolder} 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) filesep 'S' num2str(SubjectNumbers_Reg_AllData{iFolder}(iSub)) Condition_Data.SET_ICA_Max_Suffix]);
                end
                if isempty(SET_Epoched_ICA_Max_Files{iFolder}{iSub})
                    disp(['No SET file (Epoched, ICA, Max) present for ' Folder_AllData{iFolder} 'S' nDigitString(SubjectNumbers_Reg_AllData{iFolder}(iSub),2) filesep]);
                    Error = 1;
                end
            end
        end
    end
end

% =========================================== %
% We can also extract the triggerInfo file from the parent
% alldata directory.
% =========================================== %

Trigger_Info_Files = {}; TEMP = {};
if varargin{5}
    for iFolder = 1:length(Folder_AllData)
        Trigger_Info_Files{iFolder} = dir([Folder_AllData{iFolder} 'triggerInfo.mat']);
        if isempty(Trigger_Info_Files{iFolder})
            disp(['No triggerInfo file for ' Condition_Data.Full_Name '!'])
            Error = 1;
        else
            TEMP{iFolder} = load(fullfile(Trigger_Info_Files{iFolder}.folder,Trigger_Info_Files{iFolder}.name));
            TEMP{iFolder} = TEMP{iFolder}.triggerInfo;
            TEMP{iFolder}(cellfun(@isnumeric,TEMP{iFolder})) = cellfun(@num2str,(TEMP{iFolder}(cellfun(@isnumeric,TEMP{iFolder}))),'UniformOutput',false);
        end
    end
    if ~isempty(TEMP) & length(TEMP) > 1
        if isempty(setdiff(TEMP{:}))
            Trigger_Info_Files = Trigger_Info_Files{1};
        else
            disp(['Multiple triggerInfo files that do not match for ' Condition_Data.Full_Name ' do not match!']);
            Error = 1;
        end
    else
        Trigger_Info_Files = Trigger_Info_Files{1};
    end
end

% % %             % =========================================== %
% % %             % Extract all .m files to detail all code files in alldata.
% % %             % =========================================== %
% % %
% % %             Code_Files_AllData = {};
% % %             for iFolder = 1:length(Folder_AllData)
% % %                 Code_Files_AllData{iFolder} = dir([Folder_AllData{iFolder} '*.m']);
% % %
% % %
% % %                 [Folder_AllData{iFolder} 'triggerInfo.mat'];
% % %                 if ~exist(Trigger_Info_Files{iFolder})
% % %                     disp([Trigger_Info_Files{iFolder} ' does not exist, but expected!'])
% % %                 end
% % %             end

% =========================================== %
% If no errors found above, we assign the
% variables to the APP.CURRENTPROJECT
% structure.
% =============================================== %

Condition_Data.Folder = Folder;
Condition_Data.SubjectNumbers = cat(2,SubjectNumbers_Reg{:});
Condition_Data.SubjectNumbers_AllData = cat(2,SubjectNumbers_Reg_AllData{:});
Condition_Data.SubjectFiles_Reg = cat(2,SubjectFiles_Reg{:});
Condition_Data.SubjectFiles_Irreg = cat(2,SubjectFiles_Irreg{:});
Condition_Data.SubjectFiles_Reg_AllData = cat(2,SubjectFiles_Reg_AllData{:});
Condition_Data.SubjectFiles_Irreg_AllData = cat(2,SubjectFiles_Irreg_AllData{:});
Condition_Data.SubjectFiles_BDF_AllData = cat(2,BDF_Files{:});
Condition_Data.SubjectFiles_SET_Epoched_AllData = cat(2,SET_Epoched_Files{:});
Condition_Data.SubjectFiles_SET_Epoched_ICA_AllData = cat(2,SET_Epoched_ICA_Files{:});
Condition_Data.SubjectFiles_SET_Epoched_ICA_Max_AllData = cat(2,SET_Epoched_ICA_Max_Files{:});
Condition_Data.SubjectFiles_Trigger_Info_AllData = Trigger_Info_Files;

if Error; return; end

% ======================================================= %
% If only the info is needed, we return so as to not load the
% data and waste processing time.
% ======================================================= %

if InfoOnly
    return
end

% ======================================================= %
% Load up the data from .mat files.
% ======================================================= %

% =============================================== %
% Loop through each subject number found in the
% previous section.
% =============================================== %

SubCount = 0;

for iSub = 1:length(Condition_Data.SubjectNumbers)
    
    FileName_Reg = Condition_Data.SubjectFiles_Reg{iSub};
    FileName_Irreg = Condition_Data.SubjectFiles_Irreg{iSub};
    
    % =========================================== %
    % Load up the regularity condition.
    % =========================================== %
    
    if exist(FileName_Reg)
        LoadedData = load(FileName_Reg);
        FieldNames = fieldnames(LoadedData);
        LoadedData = LoadedData.(FieldNames{1});
        Condition_Data.Data(:,:,iSub) = LoadedData;
    else
        error(['File not found - ' FileName_Reg])
    end
    
    % =========================================== %
    % Load up the corresponding irregularity condition.
    % =========================================== %
    
    if exist(FileName_Irreg)
        LoadedData = load(FileName_Irreg);
        FieldNames = fieldnames(LoadedData);
        LoadedData = LoadedData.(FieldNames{1});
        Condition_Data.Data_Irregular(:,:,iSub) = LoadedData;
    else
        error(['File not found - ' FileName_Irreg])
    end
    
end

% ======================================================= %
% Load up time vector for each EXPERIMENT and CONDITION.
% Some conditions for the same experiment have different
% time vectors. Hence, we load up the time vector for each
% CONDITION individually.
% ======================================================= %

TimeVectorFile = [Condition_Data.Folder{1} filesep Condition_Data.Time_Vector_Name '.mat'];

if exist(TimeVectorFile)
    TempVar = load(TimeVectorFile);
else
    error(['Time Vector file not found - ' TimeVectorFile]);
end

FieldNames = fieldnames(TempVar);
Condition_Data.TimeVector = TempVar.(FieldNames{1});

end