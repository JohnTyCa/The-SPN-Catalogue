classdef SPNCAT_Export_func < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        LeftPanel                       matlab.ui.container.Panel
        TabGroup                        matlab.ui.container.TabGroup
        MeanValuesTab                   matlab.ui.container.Tab
        ConditionsListBoxLabel          matlab.ui.control.Label
        ConditionsListBox               matlab.ui.control.ListBox
        ElectrodesListBox               matlab.ui.control.ListBox
        ElectrodesListBoxLabel          matlab.ui.control.Label
        DifferenceWaveButton            matlab.ui.control.StateButton
        SelectTimeButton                matlab.ui.control.StateButton
        ExportMeanButton                matlab.ui.control.Button
        StartEditField_2Label           matlab.ui.control.Label
        StartEditField                  matlab.ui.control.NumericEditField
        EndEditField_2Label             matlab.ui.control.Label
        EndEditField                    matlab.ui.control.NumericEditField
        FullTimecourseTab               matlab.ui.container.Tab
        ProjectsPanel                   matlab.ui.container.Panel
        ProjectsListBox                 matlab.ui.control.ListBox
        DifferenceWaveButton_Timecourse  matlab.ui.control.StateButton
        ExportTimecourseButton          matlab.ui.control.Button
        ExportFormatButtonGroup         matlab.ui.container.ButtonGroup
        MATButton                       matlab.ui.control.RadioButton
        AVRButton                       matlab.ui.control.RadioButton
        SETButton                       matlab.ui.control.RadioButton
        BIDButton                       matlab.ui.control.RadioButton
        FilterPanel                     matlab.ui.container.Panel
        MinSPNuVEditFieldLabel          matlab.ui.control.Label
        MinSPNuVEditField               matlab.ui.control.NumericEditField
        MinWEditFieldLabel              matlab.ui.control.Label
        MinWEditField                   matlab.ui.control.NumericEditField
        MinDEditFieldLabel              matlab.ui.control.Label
        MinDEditField                   matlab.ui.control.NumericEditField
        IgnoreRegularityCheckBox        matlab.ui.control.CheckBox
        AttendRegularityCheckBox        matlab.ui.control.CheckBox
        XButton_SPN                     matlab.ui.control.StateButton
        YButton_SPN                     matlab.ui.control.StateButton
        XButton_W                       matlab.ui.control.StateButton
        YButton_W                       matlab.ui.control.StateButton
        XButton_D                       matlab.ui.control.StateButton
        YButton_D                       matlab.ui.control.StateButton
        SupplementaryPanel              matlab.ui.container.Panel
        ExportRandomConditionsCheckBox  matlab.ui.control.CheckBox
        DataFileforExportButtonGroup    matlab.ui.container.ButtonGroup
        BDFContinuousButton             matlab.ui.control.RadioButton
        SETEpochedButton                matlab.ui.control.RadioButton
        SETEpochedICAButton             matlab.ui.control.RadioButton
        SETEpochedICAMaxButton          matlab.ui.control.RadioButton
        RightPanel                      matlab.ui.container.Panel
        UIAxesWaveform                  matlab.ui.control.UIAxes
        UIAxesLegend                    matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = private)
        TIME % One and only time vector
        ELECTRODES % One and only electrode list
        PLOT % Plot data
        DATA % Main data structure
        EXPORT % Data to export
        PATCH_COND % Time highlight handle (Condition Plot)
        PATCH_GA % Time highlight handle (GA Plot)
        SLINE_COND % Start line for time highlighting (Condition Plot)
        ELINE_COND % End line for time highlighting (Condition Plot)
        SLINE_GA % Start line for time highlighting (GA Plot)
        ELINE_GA % End line for time highlighting (GA Plot)
        CallingApp % The main app that calls this app.
        SELECTSTATUS = 0 % The status of the current time selection button.
        LEGHANDLE % Handle for legend.
        FILTER % Filter parameters.
        CONDTOSHOW % Conditions that are not filtered out.
        ALLEXP % Description
        CURRENTPROJECT;
        
        PROJECT;
        EXP;
        CAT;
    end
    
    methods (Access = private)
        
        function ExtractPlotData(app)
            
            cla(app.UIAxesWaveform);
            cla(app.UIAxesLegend);
            
            if strcmp(app.TabGroup.SelectedTab.Title,'Full Timecourse')
                
                % =========================================================== %
                % Configure the figures to plot SPN, W and D.
                % =========================================================== %
                
                if isfield(app.FILTER,'XParam')
                    if strcmp(app.FILTER.XParam,'X_SPN')
                        XData = [app.CAT.SPN];
                        XParam = 'SPN (uV)';
                    elseif strcmp(app.FILTER.XParam,'X_W')
                        XData = [app.CAT.W];
                        XParam = 'W';
                    elseif strcmp(app.FILTER.XParam,'X_D')
                        XData = [app.CAT.D];
                        XParam = 'Effect Size (D)';
                    else
                        XData = [];
                    end
                else
                    XData = [];
                end
                
                if isfield(app.FILTER,'YParam')
                    if strcmp(app.FILTER.YParam,'Y_SPN')
                        YData = [app.CAT.SPN];
                        YParam = 'SPN (uV)';
                    elseif strcmp(app.FILTER.YParam,'Y_W')
                        YData = [app.CAT.W];
                        YParam = 'W';
                    elseif strcmp(app.FILTER.YParam,'Y_D')
                        YData = [app.CAT.D];
                        YParam = 'Effect Size (D)';
                    else
                        YData = [];
                    end
                else
                    YData = [];
                end
                
                if isempty(XData) | isempty(YData)
                    return
                end
                
                MinX = roundTo(min(XData),1,'Direction','down');
                MaxX = roundTo(max(XData),1,'Direction','up');
                MinY = roundTo(min(YData),1,'Direction','down');
                MaxY = roundTo(max(YData),1,'Direction','up');
                
                for iCond = 1:length(app.CAT)
                    if app.CAT(iCond).Included & app.CAT(iCond).Attend_Regularity
                        app.CAT(iCond).Marker = 'greeno';
                        app.CAT(iCond).MarkerC = 'green';
                        app.CAT(iCond).MarkerM = 'o';
                    elseif app.CAT(iCond).Included & ~app.CAT(iCond).Attend_Regularity
                        app.CAT(iCond).Marker = 'redo';
                        app.CAT(iCond).MarkerC = 'red';
                        app.CAT(iCond).MarkerM = 'o';
                    elseif ~app.CAT(iCond).Included & app.CAT(iCond).Attend_Regularity
                        app.CAT(iCond).Marker = 'greenx';
                        app.CAT(iCond).MarkerC = 'green';
                        app.CAT(iCond).MarkerM = 'x';
                    elseif ~app.CAT(iCond).Included & ~app.CAT(iCond).Attend_Regularity
                        app.CAT(iCond).Marker = 'redx';
                        app.CAT(iCond).MarkerC = 'red';
                        app.CAT(iCond).MarkerM = 'x';
                    end
                    
                    hold(app.UIAxesWaveform,'on');
                    
                    scatter(app.UIAxesWaveform,XData(iCond),YData(iCond),app.CAT(iCond).Marker);
                    
                end
                
                if ~app.UIAxesWaveform.Visible
                    app.UIAxesWaveform.Visible = 'on';
                end
                
                axis(app.UIAxesWaveform,[MinX MaxX MinY MaxY]);
                app.UIAxesWaveform.XLabel.String = XParam;
                app.UIAxesWaveform.YLabel.String = YParam;
                
                app.UIAxesWaveform.Title.String = [XParam ' vs ' YParam];
                
            else
                
                % =========================================================== %
                % To start, we will make a variable with only the selected
                % conditions.
                % =========================================================== %
                
                PLOT = app.CURRENTPROJECT(ismember([app.CURRENTPROJECT.SPNID],app.ConditionsListBox.Value));
                
                % =========================================================== %
                % If there are no conditions selected, return.
                % =========================================================== %
                
                if isempty(PLOT)
                    cla(app.UIAxesWaveform);
                    cla(app.UIAxesGA);
                    %                     errordlg('Cannot plot difference wave for irregular conditions.');
                    return
                end
                
                % =========================================================== %
                % Get ELECTRODE and TIME indices.
                % =========================================================== %
                
                [ElectrodeIndices,TimeIndices] = ExtractIndices(app);
                
                % =========================================================== %
                % Now we have the ELECTRODE and TIME indices, we can extract
                % the data.
                % =========================================================== %
                
                for iCond = 1:length(PLOT)
                    if app.DifferenceWaveButton.Value
                        PLOT(iCond).Plot_Data = PLOT(iCond).Data - PLOT(iCond).Data_Irregular;
                    else
                        PLOT(iCond).Plot_Data = PLOT(iCond).Data;
                    end
                    PLOT(iCond).Line_Data = squeeze(mean(mean(PLOT(iCond).Plot_Data(ElectrodeIndices,:,:),1),3));
                    PLOT(iCond).Mean = squeeze(mean(mean(PLOT(iCond).Plot_Data(ElectrodeIndices,TimeIndices,:,:),2),1));
                    PLOT(iCond).Legend_Name = [PLOT(iCond).Full_Name ' (SPN ' num2str(PLOT(iCond).SPNID) ')'];
                end
                
                % =========================================================== %
                % Plot the individual conditions.
                % =========================================================== %
                
                cla(app.UIAxesWaveform);
                
                app.LEGHANDLE = [];
                for iCond = 1:length(PLOT)
                    plot(app.UIAxesWaveform,app.TIME,PLOT(iCond).Line_Data);
                    if ~ishold(app.UIAxesWaveform)
                        hold(app.UIAxesWaveform,'on');
                    end
                    plot(app.UIAxesLegend,NaN,NaN);
                    if ~ishold(app.UIAxesLegend)
                        hold(app.UIAxesLegend,'on');
                    end
                end
                hold(app.UIAxesWaveform,'off');
                hold(app.UIAxesLegend,'off');
                
                app.LEGHANDLE = legend(app.UIAxesLegend,strrep({PLOT.Legend_Name},'_',' '));
                app.LEGHANDLE.Units = 'pixels';
                app.LEGHANDLE.Position = app.UIAxesLegend.Position;
                
                % =========================================================== %
                % Get the min values for the Y-Axis.
                % =========================================================== %
                
                [MinY_Cond, MaxY_Cond] = GetLimits(app,cat(1,PLOT.Line_Data));
                
                % =========================================================== %
                % Set the axis for plots and other plot configuration.
                % =========================================================== %
                
                axis(app.UIAxesWaveform,[app.TIME(1) app.TIME(end) MinY_Cond MaxY_Cond]);
                app.UIAxesWaveform.XLabel.String = 'SPN (uV)';
                app.UIAxesWaveform.YLabel.String = 'Time (ms);'
                app.UIAxesWaveform.Title.String = 'Waveforms for Individual Conditions';
                
                % =========================================================== %
                % Highlight the time selection.
                % =========================================================== %
                
                app.UIAxesWaveform = HighlightTime(app,app.UIAxesWaveform);
                
            end
            
        end
        
        function [ElectrodeIndices,TimeIndices] = ExtractIndices(app)
            
            % =========================================================== %
            % Determine the electrode indices.
            % =========================================================== %
            
            ElectrodeIndices = find(ismember({app.ELECTRODES.labels},app.ElectrodesListBox.Value));
            
            % =========================================================== %
            % Determine time indices. There are two ways to do this that
            % are almost identical, and will only make a single time sample
            % difference. First, we could take all data occurring AFTER the
            % desired start time, as well as all data points occurring
            % BEFORE the desired start time. Alternatively, we could take
            % all data points starting from the time point NEAREST to the
            % starting time, ending at the data point NEAREST to the end
            % time. Either could be argued for, but we will use the first
            % option.
            % =========================================================== %
            
            TimeIndices = find(app.TIME >= app.StartEditField.Value & app.TIME <= app.EndEditField.Value);
            
        end
        
        function Handle = HighlightTime(app,Handle)
            
            DeletePatch(app,Handle)
            
            if ~ishold(Handle); hold(Handle,'on'); end
            
            if ~isempty(app.StartEditField.Value)
                Handle.UserData.SLINE = xline(Handle,app.StartEditField.Value,'Color','green','LineWidth',2);
            end
            
            if ~isempty(app.EndEditField.Value) && ~app.SELECTSTATUS
                Handle.UserData.ELINE = xline(Handle,app.EndEditField.Value,'Color','red','LineWidth',2);
            end
            
            if ~isempty(app.StartEditField.Value) && ~isempty(app.EndEditField.Value) && ~app.SELECTSTATUS
                
                PatchX = [app.StartEditField.Value app.EndEditField.Value app.EndEditField.Value app.StartEditField.Value];
                PatchY = repelem(ylim(Handle),1,2);
                Handle.UserData.PATCH = patch(Handle,PatchX,PatchY,'green');
                Handle.UserData.PATCH.FaceAlpha = 0.2;
                Handle.UserData.PATCH.EdgeColor = 'none';
                Handle.Children = Handle.Children([2:end 1]);
                
            end
            
            hold(Handle,'off');
            
            % % %             if ~isempty(app.UIAxesLegend.Legend)
            % % %
            % % %                 LegendStrings = app.UIAxesLegend.Legend.String;
            % % %                 LegendRemoval = zeros(1,length(LegendStrings));
            % % %                 for iData = 1:10
            % % %                     LegendRemoval = LegendRemoval + ismember(LegendStrings,['data' num2str(iData)]);
            % % %                 end
            % % %
            % % %                 app.UIAxesLegend.Legend.String(logical(LegendRemoval)) = [];
            % % %
            % % %                 return
            % % %
            % % %             end
            
        end
        
        
        function [MinY, MaxY] = GetLimits(~,Data)
            
            % =========================================================== %
            % Get the min values for the Y-Axis.
            % =========================================================== %
            
            MinVal = min(Data,[],'all');
            MinRange = 10^10;;
            while abs(MinVal) < MinRange
                MinRange = MinRange / 10;
            end
            %             MinRange = MinRange * 10;
            
            MinY = roundTo(MinVal,MinRange,'Direction','down');
            
            % =========================================================== %
            % Get the max values for the Y-Axis.
            % =========================================================== %
            
            MaxVal = max(Data,[],'all');
            MaxRange = 10^10;
            while MaxVal < MaxRange
                MaxRange = MaxRange / 10;
            end
            %             MaxRange = MaxRange * 10;
            
            MaxY = roundTo(MaxVal,MaxRange,'Direction','up');
            
        end
        
        function DeletePatch(app,Handle)
            
            % =========================================================== %
            % Delete XLINE.
            % =========================================================== %
            
            ObjectsToDelete = findobj(Handle,'Type','ConstantLine');
            delete(ObjectsToDelete);
            
            % =========================================================== %
            % Delete PATCH.
            % =========================================================== %
            
            ObjectsToDelete = findobj(Handle,'Type','Patch');
            delete(ObjectsToDelete);
            
        end
        
        function FlipEnable(app)
            
            app.SelectTimeButton.Enable = ~app.SelectTimeButton.Enable;
            app.StartEditField.Enable = ~app.StartEditField.Enable;
            app.EndEditField.Enable = ~app.EndEditField.Enable;
            app.ElectrodesListBox.Enable = ~app.ElectrodesListBox.Enable;
            app.ExportMeanButton.Enable = ~app.ExportMeanButton.Enable;
            app.ConditionsListBox.Enable = ~app.ConditionsListBox.Enable;
            app.DifferenceWaveButton.Enable = ~app.DifferenceWaveButton.Enable;
            
        end
        
        function InitiateTimecourseTab(app)
            
            FilterValueChanged(app,[]);
            
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            
            % =========================================================== %
            % Store main app in property for CloseRequestFcn to use
            % =========================================================== %
            
            app.CallingApp = mainapp;
            
            % =========================================================== %
            % Since some projects have different time vectors, we need to
            % create an "average" time series. For the purpose of
            % exporting, this is difficult. Hence, I will ignore it for now
            % and fix it in the future if required.
            % =========================================================== %
            
            CurrentTimeVectors = {mainapp.CURRENTPROJECT.TimeVector}';
            MinValue = cellfun(@min,CurrentTimeVectors);
            MaxValue = cellfun(@max,CurrentTimeVectors);
            
            if length(unique(MinValue)) > 1
                error('Epochs have different starting times. You will have to figure out another way of equalising time vector lengths.')
            end
            
            if length(unique(MaxValue)) > 1
                error('Epochs have different end times. Fix the protocol.')
            end
            
            app.TIME = CurrentTimeVectors{1};
            
            % =========================================================== %
            % Now we have all the data we need, we can configure the app.
            % =========================================================== %
            
            app.ConditionsListBox.Items =  join([{mainapp.CURRENTPROJECT.Full_Name}', cellstr(repelem('SPN',length(mainapp.CURRENTPROJECT),1)) cellstr(num2str([mainapp.CURRENTPROJECT.SPNID]')) {mainapp.CURRENTPROJECT.Regular_Condition}'])
            app.ConditionsListBox.ItemsData = [mainapp.CURRENTPROJECT.SPNID];
            app.ElectrodesListBox.Items = {mainapp.E.labels};
            app.StartEditField.Value = app.TIME(1);
            app.EndEditField.Value = app.TIME(end);
            app.ConditionsListBox.Value = [mainapp.CURRENTPROJECT.SPNID];
            
            % =========================================================== %
            % Determine starter values, for the electrodes. There is an off
            % chance that the default electrodes inside the
            % ELECTRODE_ORIGINAL column from the cATALOGUE are different
            % between CONDITIONS across the EXPERIMENTS. Hence, we will
            % just take all unique electrodes across all CONDITIONS.
            % =========================================================== %
            
            SelectedElectrodes = unique(cat(2,mainapp.CURRENTPROJECT.Electrodes_Original));
            app.ElectrodesListBox.Value = SelectedElectrodes;
            
            % =========================================================== %
            % Let's give the main structure a nicer name.
            % =========================================================== %
            
            app.ELECTRODES = mainapp.E;
            app.CURRENTPROJECT = mainapp.CURRENTPROJECT;
            
            % =========================================================== %
            % Create the filter structure.
            % =========================================================== %
            
            app.FILTER.MinSPN = 0;
            app.FILTER.MinW = 0;
            app.FILTER.MinD = 0;
            app.FILTER.AttendReg = 0;
            app.FILTER.IgnoreReg = 0;
            
            % =========================================================== %
            % Extract the PROJECT, EXP and CAT variables from the MAINAPP
            % and store them privately in the current APP.
            % =========================================================== %
            
            app.PROJECT = mainapp.PROJECT;
            app.EXP = mainapp.EXP;
            app.CAT = mainapp.CAT;
            
            % =========================================================== %
            % Extract and plot the data.
            % =========================================================== %
            
            ConditionsListBoxValueChanged(app, []);
            
        end

        % Value changed function: ConditionsListBox
        function ConditionsListBoxValueChanged(app, event)
            
            ExtractPlotData(app);
            
        end

        % Value changed function: ElectrodesListBox
        function ElectrodesListBoxValueChanged(app, event)
            
            ExtractPlotData(app);
            
        end

        % Value changed function: StartEditField
        function StartEditFieldValueChanged(app, event)
            
            [~,TimeIndices] = ExtractIndices(app);
            app.StartEditField.Value = app.TIME(TimeIndices(1));
            
            app.UIAxesWaveform = HighlightTime(app,app.UIAxesWaveform);
            
        end

        % Value changed function: EndEditField
        function EndEditFieldValueChanged(app, event)
            
            [~,TimeIndices] = ExtractIndices(app);
            app.EndEditField.Value = app.TIME(TimeIndices(end));
            
            app.UIAxesWaveform = HighlightTime(app,app.UIAxesWaveform);
            
        end

        % Button pushed function: ExportMeanButton
        function ExportMeanButtonPushed(app, event)
            
            % =========================================================== %
            % To start, we will make a variable with only the selected
            % conditions.
            % =========================================================== %
            
            EXPORT = app.CURRENTPROJECT(ismember([app.CURRENTPROJECT.SPNID],app.ConditionsListBox.Value));
            
            % =========================================================== %
            % Get ELECTRODE and TIME indices.
            % =========================================================== %
            
            [ElectrodeIndices,TimeIndices] = ExtractIndices(app);
            
            % =========================================================== %
            % We can configure the data for export here. Should really do
            % this in a separate function so that it doesn't pointlessly
            % execute every time the conditions are changed. However, the
            % data is present here and we are only doing simple array
            % building so it should be quick to compute.
            %
            % First, we create tables that will allow us to export a single
            % CSV file for each experiment, but only if the experiment has
            % been selected in the CONDITIONS LISTBOX.
            % =========================================================== %
            
            UniqueExperiments = unique({EXPORT.Full_Name});
            
            EXPORT_EXP = struct();
            
            for iExp = 1:length(UniqueExperiments)
                
                ExperimentIndices = find(strcmp({EXPORT.Full_Name},UniqueExperiments{iExp}));
                
                EXPORT_EXP(iExp).SPNID = [EXPORT(ExperimentIndices).SPNID];
                EXPORT_EXP(iExp).Project = EXPORT(ExperimentIndices(1)).Project;
                EXPORT_EXP(iExp).Experiment = EXPORT(ExperimentIndices(1)).Experiment;
                EXPORT_EXP(iExp).Full_Name = EXPORT(ExperimentIndices(1)).Full_Name;
                EXPORT_EXP(iExp).N = [EXPORT(ExperimentIndices).N];
                EXPORT_EXP(iExp).Regular_Condition = {EXPORT(ExperimentIndices).Regular_Condition};
                EXPORT_EXP(iExp).Irregular_Condition = {EXPORT(ExperimentIndices).Irregular_Condition};
                EXPORT_EXP(iExp).Data = {EXPORT(ExperimentIndices).Data};
                EXPORT_EXP(iExp).Data_Irregular = {EXPORT(ExperimentIndices).Data_Irregular};
                EXPORT_EXP(iExp).Time_Vector = {EXPORT(ExperimentIndices).TimeVector};
                
                for iCond = 1:length(ExperimentIndices)
                    
                    TEMPDATA = EXPORT_EXP(iExp).Data{iCond};
                    TEMPDATA_IRREG = EXPORT_EXP(iExp).Data_Irregular{iCond};
                    
                    if app.DifferenceWaveButton.Value
                        TEMPDATA = TEMPDATA - TEMPDATA_IRREG;
                    end
                    
                    EXPORT_EXP(iExp).Export_Data(:,iCond) = squeeze(mean(mean(TEMPDATA(ElectrodeIndices,TimeIndices,:),2),1));
                    EXPORT_EXP(iExp).Export_Data_Irregular(:,iCond) = squeeze(mean(mean(TEMPDATA_IRREG(ElectrodeIndices,TimeIndices,:),2),1));
                    
                end
                
                EXPORT_EXP(iExp).Export_Data = array2table(EXPORT_EXP(iExp).Export_Data,'VariableNames',strrep({EXPORT(ExperimentIndices).Regular_Condition},' ','_'));
                
                UniqueRandomConditions = unique({EXPORT(ExperimentIndices).Irregular_Condition});
                RemovalIndex = ones(1,length({EXPORT(ExperimentIndices).Irregular_Condition}));
                for iCond = 1:length(UniqueRandomConditions)
                    ConditionIndex = strcmp({EXPORT(ExperimentIndices).Irregular_Condition},UniqueRandomConditions{iCond});
                    RemovalIndex(ConditionIndex(1)) = 0;
                end
                EXPORT_EXP(iExp).Export_Data_Irregular(:,logical(RemovalIndex)) = [];
                EXPORT_EXP(iExp).Export_Data_Irregular = array2table(EXPORT_EXP(iExp).Export_Data_Irregular,'VariableNames',strrep(UniqueRandomConditions,' ','_'));
                
                if app.DifferenceWaveButton.Value
                    EXPORT_EXP(iExp).Export_Data_All = EXPORT_EXP(iExp).Export_Data;
                else
                    EXPORT_EXP(iExp).Export_Data_All = horzcat(EXPORT_EXP(iExp).Export_Data,EXPORT_EXP(iExp).Export_Data_Irregular);
                end
                
            end
            
            % =========================================================== %
            % Next, we will export the long format data with everything
            % across all experiments.
            % =========================================================== %
            
            EXPORT_LONG = struct();
            
            nCond = cellfun(@(x) size(x,2),{EXPORT_EXP.Export_Data_All});
            nSub = cellfun(@height,{EXPORT_EXP.Export_Data_All});
            
            Count = 0;
            for iExp = 1:length(EXPORT_EXP)
                for iCond = 1:nCond(iExp)
                    for iSub = 1:nSub(iExp)
                        Count = Count + 1;
                        SubCorrection = sum(nSub(1:iExp-1));
                        EXPORT_LONG(Count).Subject = iSub + SubCorrection;
                        EXPORT_LONG(Count).Experiment = EXPORT_EXP(iExp).Full_Name;
                        EXPORT_LONG(Count).Condition = EXPORT_EXP(iExp).Export_Data_All.Properties.VariableNames{iCond};
                        EXPORT_LONG(Count).MeanAmp = table2array(EXPORT_EXP(iExp).Export_Data_All(iSub,iCond));
                    end
                end
            end
            
            EXPORT_LONG = struct2table(EXPORT_LONG);
            
            % =========================================================== %
            % We get the path in which to save the file.
            % =========================================================== %
            
            SavePath = uigetdir;
            waitfor(SavePath);
            
            % =========================================================== %
            % Define the path for the long format data.
            % =========================================================== %
            
            Save_Long = [SavePath filesep 'P' nDigitString(EXPORT(1).Project,3) '_LONG.csv'];
            
            Count = 0; AlreadyExist = 0;
            while exist(Save_Long,'file')
                Count = Count + 1;
                Save_Long = [SavePath filesep 'P' nDigitString(EXPORT(1).Project,3) '_LONG-' num2str(Count) '.csv'];
                AlreadyExist = 1;
            end
            
            if AlreadyExist
                disp(['Long data for P' nDigitString(EXPORT(1).Project,3) ' already present, appended with -' num2str(Count) '.'])
            end
            
            % =========================================================== %
            % Define the path for the wide format data.
            % =========================================================== %
            
            Save_Wide = cell(1,length(EXPORT_EXP));
            for iExp = 1:length(EXPORT_EXP)
                
                Save_Wide{iExp} = [SavePath filesep EXPORT_EXP(iExp).Full_Name '_WIDE.csv'];
                
                Count = 0; AlreadyExist = 0;
                while exist(Save_Wide{iExp},'file')
                    Count = Count + 1;
                    Save_Wide{iExp} = [SavePath filesep EXPORT_EXP(iExp).Full_Name '-' num2str(Count) '.csv'];
                    AlreadyExist = 1;
                end
                
                if AlreadyExist
                    disp(['Save data for ' EXPORT_EXP(iExp).Full_Name ' already present, appended with -' num2str(Count) '.'])
                end
                
            end
            
            % =========================================================== %
            % Save the data.
            % =========================================================== %
            
            writetable(EXPORT_LONG,Save_Long);
            disp(['Long Data Saved - ' Save_Long]);
            for iExp = 1:length(EXPORT_EXP)
                writetable(EXPORT_EXP(iExp).Export_Data_All,Save_Wide{iExp});
                disp(['Wide Data Saved (' EXPORT_EXP(iExp).Full_Name ') - ' Save_Wide{iExp}]);
            end
            
            % =========================================================== %
            % Close the figure.
            % =========================================================== %
            
            UIFigureCloseRequest(app, []);
            
        end

        % Value changed function: DifferenceWaveButton
        function DifferenceWaveButtonValueChanged(app, event)
            ExtractPlotData(app);
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            
            % Enable the Plot Opions button in main app
            
            app.CallingApp.ExportButton.Enable = 'on';
            
            % Delete the dialog box
            
            delete(app);
            
        end

        % Value changed function: SelectTimeButton
        function SelectTimeButtonValueChanged(app, event)
            
            app.SELECTSTATUS = 1;
            
            DeletePatch(app,app.UIAxesWaveform);
            
            FlipEnable(app);
            
        end

        % Button down function: UIAxesWaveform
        function UIAxesButtonDown(app, event)
            
            SelectedTime = event.IntersectionPoint(1);
            
            if app.SELECTSTATUS == 1
                app.StartEditField.Value = SelectedTime;
                app.SELECTSTATUS = app.SELECTSTATUS + 1;
                HighlightTime(app,app.UIAxesWaveform);
            elseif app.SELECTSTATUS == 2
                app.EndEditField.Value = SelectedTime;
                app.SELECTSTATUS = 0;
                app.SelectTimeButton.Value = 0;
                HighlightTime(app,app.UIAxesWaveform);
                FlipEnable(app);
            end
            
        end

        % Selection change function: TabGroup
        function TabGroupSelectionChanged(app, event)
            
            selectedTab = app.TabGroup.SelectedTab;
            
            if strcmp(selectedTab.Title,'Full Timecourse')
                
                cla(app.UIAxesWaveform);
                cla(app.UIAxesLegend);
                
                if ~isfield(app.FILTER,'XParam') | ~isfield(app.FILTER,'YParam')
                    app.UIAxesWaveform.Visible = 'off';
                elseif isempty(app.FILTER.XParam) & isempty(app.FILTER.YParam)
                    app.UIAxesWaveform.Visible = 'off';
                else
                    app.UIAxesWaveform.Visible = 'on';
                end
                
                app.UIAxesLegend.Visible = 'off';
                app.LEGHANDLE.Visible = 'off';
                
                InitiateTimecourseTab(app)
                
            else
                
                ExtractPlotData(app);
                app.UIAxesWaveform.Visible = 'on';
                app.UIAxesLegend.Visible = 'on';
                app.LEGHANDLE.Visible = 'on';
                
            end
            
        end

        % Button pushed function: ExportTimecourseButton
        function ExportTimecourseButtonPushed(app, event)
            
            ProgressBar = uiprogressdlg(app.UIFigure,'Title','Please Wait',...
                'Message','Exporting data');
            
            % =========================================================== %
            % Get the directory to save the data. Data will be saved
            % according to SPNID.
            % =========================================================== %
            
            Save_Directory = uigetdir;
            waitfor(Save_Directory);
            
            EXPORT_TIMECOURSE = {};
            
            % =========================================================== %
            % Depending on the export format, we extract the appropriate
            % data.
            % =========================================================== %
            
            if strcmp(app.ExportFormatButtonGroup.SelectedObject.Text,'.MAT') | strcmp(app.ExportFormatButtonGroup.SelectedObject.Text,'.AVR')
                
                Conditions_To_Export = app.ProjectsListBox.Value;
                
                Count = 0;
                for iCond = Conditions_To_Export
                    Count = Count + 1;
                    [EXPORT_TIMECOURSE{Count}, Error] = ExtractConditionData(app.CallingApp.CAT,app.CallingApp.DATADIR,iCond,0);
                    if app.DifferenceWaveButton_Timecourse.Value
                        EXPORT_TIMECOURSE{Count}.Data = EXPORT_TIMECOURSE{Count}.Data - EXPORT_TIMECOURSE{Count}.Data_Irregular;
                        EXPORT_TIMECOURSE{Count}.Data_Irregular = [];
                    end
                    ProgressBar.Message = ['Getting data ready for export: SPN ' nDigitString(iCond,4)];
                end
                EXPORT_TIMECOURSE = vertcat(EXPORT_TIMECOURSE{:});
                
            elseif strcmp(app.ExportFormatButtonGroup.SelectedObject.Text,'.SET')
                
                Conditions_To_Export = app.ProjectsListBox.Value;
                
                Count = 0;
                for iCond = Conditions_To_Export
                    Count = Count + 1;
                    [EXPORT_TIMECOURSE{Count}, Error] = ExtractConditionData(app.CallingApp.CAT,app.CallingApp.DATADIR,iCond,1);
                    ProgressBar.Message = ['Getting data ready for export: SPN ' nDigitString(iCond,4)];
                end
                
                EXPORT_TIMECOURSE = vertcat(EXPORT_TIMECOURSE{:});
                
                for iExport = 1:length(EXPORT_TIMECOURSE)
                    
                    SAVE_DIRECTORY_EXPERIMENT = [Save_Directory filesep EXPORT_TIMECOURSE(iExport).Full_Name filesep];
                    if ~exist(SAVE_DIRECTORY_EXPERIMENT); mkdir(SAVE_DIRECTORY_EXPERIMENT); end
                    
                    Count = 0;
                    
                    for iSub = EXPORT_TIMECOURSE(iExport).SubjectNumbers
                        
                        Count = Count + 1;
                        
                        % Regular Condition.
                        
                        SAVE_NAME = [EXPORT_TIMECOURSE(iExport).Full_Name '_S' nDigitString(iSub,2) '_' nDigitString(EXPORT_TIMECOURSE(iExport).SPNID,4)];
                        
                        ProgressBar.Message = ['Exporting data: ' SAVE_NAME app.ExportFormatButtonGroup.SelectedObject.Text];
                        
                        copyfile(EXPORT_TIMECOURSE(iExport).SubjectFiles_Reg_AllData{Count},[SAVE_DIRECTORY_EXPERIMENT SAVE_NAME '.set']);
                        copyfile(strrep(EXPORT_TIMECOURSE(iExport).SubjectFiles_Reg_AllData{Count},'.set','.fdt'),[SAVE_DIRECTORY_EXPERIMENT SAVE_NAME '.fdt']);
                        
                        % Irregular Condition.
                        
                        if app.ExportRandomConditionsCheckBox.Value
                            ProgressBar.Message = ['Exporting data: ' SAVE_NAME '_IRREGULAR' app.ExportFormatButtonGroup.SelectedObject.Text];
                            copyfile(EXPORT_TIMECOURSE(iExport).SubjectFiles_Irreg_AllData{Count},[SAVE_DIRECTORY_EXPERIMENT SAVE_NAME '_IRREGULAR.set']);
                            copyfile(strrep(EXPORT_TIMECOURSE(iExport).SubjectFiles_Irreg_AllData{Count},'.set','.fdt'),[SAVE_DIRECTORY_EXPERIMENT SAVE_NAME '_IRREGULAR.fdt']);
                        end
                        
                    end
                    
                end
                
                ProgressBar.Message = 'Export complete!';
                pause(1);
                close(ProgressBar);
                return
                
            elseif strcmp(app.ExportFormatButtonGroup.SelectedObject.Text,'BIDS')
                
                Experiments_To_Export = app.ProjectsListBox.Value;
                
                % =========================================================== %
                % Prepare the original data variable.
                % =========================================================== %
                
                switch app.DataFileforExportButtonGroup.SelectedObject.Text
                    
                    case 'BDF'
                        Function_Options = {1 0 0 0 1};
                        
                    case 'SET (Epoched)'
                        Function_Options = {0 1 0 0 1};
                        
                    case 'SET (Epoched, ICA)'
                        Function_Options = {0 0 1 0 1};
                        
                    case 'SET (Epoched, ICA, Max)'
                        Function_Options = {0 0 0 1 1};
                        
                end
                
                Conditions_To_Export = [app.CAT(ismember({app.CAT.Full_Name},Experiments_To_Export)).SPNID];
                Count = 0; Error = [];
                for iCond = Conditions_To_Export
                    Count = Count + 1;
                    [EXPORT_TIMECOURSE{Count}, Error(Count)] = ExtractConditionData(app.CallingApp.CAT,app.CallingApp.DATADIR,iCond,1,Function_Options{:});
                    ProgressBar.Message = ['Getting data ready for export: SPN ' nDigitString(iCond,4)];
                end
                EXPORT_TIMECOURSE = vertcat(EXPORT_TIMECOURSE{:});
                for iCond = 1:length(EXPORT_TIMECOURSE)
                    EXPORT_TIMECOURSE(iCond).Error = Error(iCond);
                end
                
                % =========================================================== %
                % Prepare the data by experiment.
                % =========================================================== %
                
                UniqueExperiments = unique({EXPORT_TIMECOURSE.Full_Name});
                
                EXPORT_TIMECOURSE_EXP = struct();
                for iExp = 1:length(UniqueExperiments)
                    Experiment_Indices = find(strcmp({EXPORT_TIMECOURSE.Full_Name},UniqueExperiments{iExp}));
                    EXPORT_TIMECOURSE_EXP(iExp).SPNID = [EXPORT_TIMECOURSE(Experiment_Indices).SPNID];
                    EXPORT_TIMECOURSE_EXP(iExp).Project = EXPORT_TIMECOURSE(Experiment_Indices(1)).Project;
                    EXPORT_TIMECOURSE_EXP(iExp).Experiment = EXPORT_TIMECOURSE(Experiment_Indices(1)).Experiment;
                    EXPORT_TIMECOURSE_EXP(iExp).Full_Name = EXPORT_TIMECOURSE(Experiment_Indices(1)).Full_Name;
                    EXPORT_TIMECOURSE_EXP(iExp).SubjectNumbers_AllData = EXPORT_TIMECOURSE(Experiment_Indices(1)).SubjectNumbers_AllData;
                    EXPORT_TIMECOURSE_EXP(iExp).Task_Names = {EXPORT_TIMECOURSE(Experiment_Indices).Task_Names};
                    EXPORT_TIMECOURSE_EXP(iExp).File_Notes = {EXPORT_TIMECOURSE(Experiment_Indices).File_Notes};
                    EXPORT_TIMECOURSE_EXP(iExp).Error = [EXPORT_TIMECOURSE(Experiment_Indices).Error];
                    if any(EXPORT_TIMECOURSE_EXP(iExp).Error)
                        continue
                    end
                    EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info_Files = EXPORT_TIMECOURSE(Experiment_Indices(1)).SubjectFiles_Trigger_Info_AllData;
                    EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info = load(fullfile(EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info_Files.folder,EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info_Files.name));
                    EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info = EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info.triggerInfo;
                    
                    BDF_Files = cat(1,EXPORT_TIMECOURSE(Experiment_Indices).SubjectFiles_BDF_AllData);
                    SET_Files = cat(1,EXPORT_TIMECOURSE(Experiment_Indices).SubjectFiles_SET_Epoched_AllData);
                    SET_ICA_Files = cat(1,EXPORT_TIMECOURSE(Experiment_Indices).SubjectFiles_SET_Epoched_ICA_AllData);
                    SET_ICA_Max_Files = cat(1,EXPORT_TIMECOURSE(Experiment_Indices).SubjectFiles_SET_Epoched_ICA_Max_AllData);
                    
                    for iSub = 1:length(EXPORT_TIMECOURSE_EXP(iExp).SubjectNumbers_AllData)
                        if ~isempty(BDF_Files)
                            EXPORT_TIMECOURSE_EXP(iExp).BDF_Files{iSub} = vertcat(BDF_Files{:,iSub});
                            [~, idx] = unique(strcat({EXPORT_TIMECOURSE_EXP(iExp).BDF_Files{iSub}.folder}',repelem({[filesep]},length(EXPORT_TIMECOURSE_EXP(iExp).BDF_Files{iSub}),1),{EXPORT_TIMECOURSE_EXP(iExp).BDF_Files{iSub}.name}'),'stable');
                            EXPORT_TIMECOURSE_EXP(iExp).BDF_Files{iSub} = EXPORT_TIMECOURSE_EXP(iExp).BDF_Files{iSub}(idx);
                        end
                        if ~isempty(SET_Files)
                            EXPORT_TIMECOURSE_EXP(iExp).SET_Files{iSub} = vertcat(SET_Files{:,iSub});
                            [~, idx] = unique(strcat({EXPORT_TIMECOURSE_EXP(iExp).SET_Files{iSub}.folder}',repelem({[filesep]},length(EXPORT_TIMECOURSE_EXP(iExp).SET_Files{iSub}),1),{EXPORT_TIMECOURSE_EXP(iExp).SET_Files{iSub}.name}'),'stable');
                            EXPORT_TIMECOURSE_EXP(iExp).SET_Files{iSub} = EXPORT_TIMECOURSE_EXP(iExp).SET_Files{iSub}(idx);
                        end
                        if ~isempty(SET_ICA_Files)
                            EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Files{iSub} = vertcat(SET_ICA_Files{:,iSub});
                            [~, idx] = unique(strcat({EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Files{iSub}.folder}',repelem({[filesep]},length(EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Files{iSub}),1),{EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Files{iSub}.name}'),'stable');
                            EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Files{iSub} = EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Files{iSub}(idx);
                        end
                        if ~isempty(SET_ICA_Max_Files)
                            EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Max_Files{iSub} = vertcat(SET_ICA_Max_Files{:,iSub});
                            [~, idx] = unique(strcat({EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Max_Files{iSub}.folder}',repelem({[filesep]},length(EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Max_Files{iSub}),1),{EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Max_Files{iSub}.name}'),'stable');
                            EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Max_Files{iSub} = EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Max_Files{iSub}(idx);
                        end
                    end
                    
                end
                
                % =========================================================== %
                % Prepare BIDS.
                % =========================================================== %
                
                BIDS_APPENDIX = readtable([app.CallingApp.Dependencies_Folder 'BIDS.csv']);
                
                BIDS_ERROR = struct(); jCounter = 0;
                
                for iExp = 1:length(EXPORT_TIMECOURSE_EXP)
                    
                    ProgressBar.Message = ['Exporting BIDS for ' EXPORT_TIMECOURSE_EXP(iExp).Full_Name];
                    
                    try
                        
                        if any(EXPORT_TIMECOURSE_EXP(iExp).Error)
                            error(['Error when checking for files for ' EXPORT_TIMECOURSE_EXP(iExp).Full_Name])
                        end
                        
                        BIDS = struct; BIDS_EXPORT = struct(); BIDS_DATA = [];
                        
                        % =========================================================== %
                        % Prepare BIDS (DATA).
                        % =========================================================== %
                        
                        switch app.DataFileforExportButtonGroup.SelectedObject.Text
                            
                            case 'BDF (Continuous)'
                                BIDS_DATA = EXPORT_TIMECOURSE_EXP(iExp).BDF_Files;
                                
                            case 'SET (Epoched)'
                                BIDS_DATA = EXPORT_TIMECOURSE_EXP(iExp).SET_Files;
                                
                            case 'SET (Epoched, ICA)'
                                BIDS_DATA = EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Files;
                                
                            case 'SET (Epoched, ICA, Max)'
                                BIDS_DATA = EXPORT_TIMECOURSE_EXP(iExp).SET_ICA_Max_Files;
                                
                        end
                        
                        for iSub = 1:length(BIDS_DATA)
                            Data_File = BIDS_DATA{iSub};
                            if length(Data_File) == 1
                                BIDS.DATA(iSub).file = [Data_File.folder filesep Data_File.name];
                            else
                                if strcmp(app.DataFileforExportButtonGroup.SelectedObject.Text,'BDF')
                                    ALLEEG = []; EEG = []; CURRENTSET = 0;
                                    for iFile = 1:length(Data_File)
                                        EEG = pop_biosig([Data_File(iFile).folder filesep Data_File(iFile).name], 'channels',1:length(app.CallingApp.E),'ref',48); % import raw data with CZ reference
                                        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off');
                                    end
                                    EEG_MERGED = pop_mergeset(ALLEEG,1:length(Data_File));
                                    EEG_MERGED.event(strcmp({EEG_MERGED.event.type},'boundary')) = [];
                                    EEG_MERGED.urevent(strcmp({EEG_MERGED.urevent.type},'boundary')) = [];
                                    for iRow = 1:length(EEG_MERGED.event)
                                        EEG_MERGED.event(iRow).type = str2num(EEG_MERGED.event(iRow).type);
                                    end
                                    TempFolder = 'TEMP';
                                    [~,Subject_Folder,~] = fileparts(Data_File(1).folder);
                                    if ~exist(TempFolder); mkdir(TempFolder); end
                                    pop_writeeeg(EEG_MERGED, [TempFolder filesep Subject_Folder '.bdf'], 'TYPE','BDF');
                                    BIDS.DATA(iSub).file = [TempFolder filesep Subject_Folder '.bdf'];
                                else
                                    
                                    if isempty(EXPORT_TIMECOURSE_EXP(iExp).Task_Names) & isempty(EXPORT_TIMECOURSE_EXP(iExp).File_Notes)
                                        error(['>1 ' app.DataFileforExportButtonGroup.SelectedObject.Text ' files present, but no "Task_Names" or "File_Notes" in APPENDIX to indicate this is expected, for ' EXPORT_TIMECOURSE_EXP(iExp).Full_Name ' - ' Data_File.name]);
                                    end
                                    
                                    for iFile = 1:length(Data_File)
                                        BIDS.DATA(iSub).file{iFile} = [Data_File(iFile).folder filesep Data_File(iFile).name];
                                        BIDS.DATA(iSub).session(iFile) = 1;
                                        BIDS.DATA(iSub).run(iFile) = iFile;
                                        if ~isempty(EXPORT_TIMECOURSE_EXP(iExp).Task_Names{iFile})
                                            BIDS.DATA(iSub).Task_Names = EXPORT_TIMECOURSE_EXP(iExp).Task_Names{iFile};
                                        end
                                        if ~isempty(EXPORT_TIMECOURSE_EXP(iExp).File_Notes{iFile})
                                            BIDS.DATA(iSub).notes{iFile} = EXPORT_TIMECOURSE_EXP(iExp).File_Notes{iFile};
                                        end
                                    end
                                    
                                end
                            end
                            
                        end
                        
                        BIDS_EXPORT.DATA = BIDS.DATA;
                        
                        % =========================================================== %
                        % Prepare BIDS (CODE - ALLDATA) (YET TO BE IMPLEMENTED)
                        % =========================================================== %
                        
                        
                        
                        % =========================================================== %
                        % Prepare BIDS (GENERAL).
                        % =========================================================== %
                        
                        Experiment_Index = find(ismember(BIDS_APPENDIX.SPNID,EXPORT_TIMECOURSE_EXP(iExp).SPNID));
                        
                        if isempty(BIDS_APPENDIX.Title{Experiment_Index(1)})
                            BIDS_EXPORT.GENERAL.ReferencesAndLinks = {'UNPUBLISHED'};
                        else
                            BIDS_EXPORT.GENERAL.Name = BIDS_APPENDIX.Title{Experiment_Index(1)};
                            BIDS_EXPORT.GENERAL.Authors = strsplit(BIDS_APPENDIX.Authors{Experiment_Index(1)},{'., ' ' and '});
                            BIDS_EXPORT.GENERAL.ReferencesAndLinks = {BIDS_APPENDIX.ReferencesAndLinks{Experiment_Index(1)}};
                        end
                        
                        % =========================================================== %
                        % Prepare BIDS (EVENTS DESCRIPTION).
                        % =========================================================== %
                        
                        warning off;
                        
                        BIDS.EVENTS_DES = table({''},{''},{''},{''},'VariableNames',{'Column' 'Title' 'LevelName' 'Content'});
                        
                        BIDS.EVENTS_DES.Column{1,1} = 'Onset';
                        BIDS.EVENTS_DES.Title{1,1} = 'Description';
                        BIDS.EVENTS_DES.LevelName{1,1} = '';
                        BIDS.EVENTS_DES.Content{1,1} = 'Event Onset';
                        
                        BIDS.EVENTS_DES.Column{2,1} = 'Onset';
                        BIDS.EVENTS_DES.Title{2,1} = 'Units';
                        BIDS.EVENTS_DES.LevelName{2,1} = '';
                        BIDS.EVENTS_DES.Content{2,1} = 'ms';
                        
                        BIDS.EVENTS_DES.Column{3,1} = 'TriggerValue';
                        BIDS.EVENTS_DES.Title{3,1} = 'Description';
                        BIDS.EVENTS_DES.LevelName{3,1} = '';
                        BIDS.EVENTS_DES.Content{3,1} = 'Event Triggers';
                        
                        for iEvent = 1:size(EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info,1)
                            for iTrigger = 1:length(EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info{iEvent,2})
                                BIDS.EVENTS_DES.Column{end+1,1} = 'TriggerValue';
                                BIDS.EVENTS_DES.Title{end,1} = 'Levels';
                                BIDS.EVENTS_DES.LevelName{end,1} = ['x' num2str(EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info{iEvent,2}(iTrigger))];
                                BIDS.EVENTS_DES.Content{end,1} = EXPORT_TIMECOURSE_EXP(iExp).Trigger_Info{iEvent,1};
                            end
                        end
                        
                        for iRow = 1:height(BIDS.EVENTS_DES)
                            if isempty(BIDS.EVENTS_DES.LevelName{iRow,1})
                                BIDS_EXPORT.EVENTS_DES.(BIDS.EVENTS_DES.Column{iRow,1}).(BIDS.EVENTS_DES.Title{iRow,1}) = BIDS.EVENTS_DES.Content{iRow,1};
                            else
                                BIDS_EXPORT.EVENTS_DES.(BIDS.EVENTS_DES.Column{iRow,1}).(BIDS.EVENTS_DES.Title{iRow,1}).(BIDS.EVENTS_DES.LevelName{iRow,1}) = BIDS.EVENTS_DES.Content{iRow,1};
                            end
                        end
                        
                        warning on;
                        
                        % =========================================================== %
                        % Prepare BIDS (PARTICIPANT INFO).
                        % =========================================================== %
                        
                        warning off;
                        
                        BIDS.PARTICIPANT_INFO = table({''},'VariableNames',{'ID'});
                        
                        for iSub = 1:length(BIDS_DATA)
                            BIDS.PARTICIPANT_INFO.ID{iSub,1} = EXPORT_TIMECOURSE_EXP(iExp).SubjectNumbers_AllData(iSub);
                        end
                        
                        Headers = BIDS.PARTICIPANT_INFO.Properties.VariableNames;
                        BIDS_EXPORT.PARTICIPANT_INFO = [Headers; table2cell(BIDS.PARTICIPANT_INFO)];
                        
                        warning on;
                        
                        % =========================================================== %
                        % Prepare BIDS (PARTICIPANT INFO DESCRIPTION).
                        % =========================================================== %
                        
                        BIDS.PARTICIPANT_INFO_DES = table({''},{''},{''},{''},'VariableNames',{'Column' 'Title' 'LevelName' 'Content'});
                        
                        BIDS.PARTICIPANT_INFO_DES.Column{1,1} = 'ID';
                        BIDS.PARTICIPANT_INFO_DES.Title{1,1} = 'Description';
                        BIDS.PARTICIPANT_INFO_DES.LevelName{1,1} = '';
                        BIDS.PARTICIPANT_INFO_DES.Content{1,1} = 'Unique Participant Identifier';
                        
                        for iRow = 1:height(BIDS.PARTICIPANT_INFO_DES)
                            if isempty(BIDS.PARTICIPANT_INFO_DES.LevelName{iRow,1})
                                BIDS_EXPORT.PARTICIPANT_INFO_DES.(BIDS.PARTICIPANT_INFO_DES.Column{iRow,1}).(BIDS.PARTICIPANT_INFO_DES.Title{iRow,1}) = BIDS.PARTICIPANT_INFO_DES.Content{iRow,1};
                            else
                                BIDS_EXPORT.PARTICIPANT_INFO_DES.(BIDS.PARTICIPANT_INFO_DES.Column{iRow,1}).(BIDS.PARTICIPANT_INFO_DES.Title{iRow,1}).(BIDS.PARTICIPANT_INFO_DES.LevelName{iRow,1}) = BIDS.PARTICIPANT_INFO_DES.Content{iRow,1};
                            end
                        end
                        
                        % =========================================================== %
                        % Export BIDS.
                        % =========================================================== %
                        
                        Save_Directory_Exp = [Save_Directory filesep EXPORT_TIMECOURSE_EXP(iExp).Full_Name filesep];
                        if ~exist(Save_Directory_Exp); mkdir(Save_Directory_Exp); end
                        
                        try
                            bids_export(BIDS_EXPORT.DATA, ...
                                'targetdir', Save_Directory_Exp, ...
                                'gInfo', BIDS_EXPORT.GENERAL, ...
                                'pInfo', BIDS_EXPORT.PARTICIPANT_INFO, ...
                                'pInfoDesc', BIDS_EXPORT.PARTICIPANT_INFO_DES, ...
                                'eInfoDesc', BIDS_EXPORT.EVENTS_DES);
                        catch
                            fclose('all')
                            bids_export(BIDS_EXPORT.DATA, ...
                                'targetdir', Save_Directory_Exp, ...
                                'gInfo', BIDS_EXPORT.GENERAL, ...
                                'pInfo', BIDS_EXPORT.PARTICIPANT_INFO, ...
                                'pInfoDesc', BIDS_EXPORT.PARTICIPANT_INFO_DES, ...
                                'eInfoDesc', BIDS_EXPORT.EVENTS_DES);
                        end
                        
                        % =========================================================== %
                        % Do cleanup in case of temp folder data.
                        % =========================================================== %
                        
                        try
                            rmdir('TEMP','s');
                        catch
                        end
                        
                    catch ME
                        
                        jCounter = jCounter + 1;
                        BIDS_ERROR(jCounter).Full_Name = EXPORT_TIMECOURSE_EXP(iExp).Full_Name;
                        BIDS_ERROR(jCounter).ME = ME;
                        continue
                        
                    end
                    
                end
                
                if ~isempty(fieldnames(BIDS_ERROR))
                    uialert(app.UIFigure,['Could not export the following experiments due to errors, please check the log file for more information: ' strjoin({BIDS_ERROR.Full_Name}, ', ')], 'Error During Export');
                    for iError = 1:length(BIDS_ERROR)
                        ErrorReport = getReport(BIDS_ERROR(iError).ME,'extended','hyperlinks','off');
                        disp(ErrorReport);
                        disp(' ');
                        disp(' ');
                        disp(' ');
                    end
                end
                
                ProgressBar.Message = 'Export complete!';
                pause(1);
                close(ProgressBar);
                return
                
            end
            
            % =========================================================== %
            % This is where we iterate through each subject and save a
            % single file for each of them. Then, we save the average
            % across all of those subjects. We will also store the data for
            % each of these subjects in a variable so that we can save the
            % data averaged across all conditions for the same experiment.
            % =========================================================== %
            
            for iExport = 1:length(EXPORT_TIMECOURSE)
                
                SAVE_DIRECTORY_EXPERIMENT = [Save_Directory filesep EXPORT_TIMECOURSE(iExport).Full_Name filesep];
                if ~exist(SAVE_DIRECTORY_EXPERIMENT); mkdir(SAVE_DIRECTORY_EXPERIMENT); end
                
                Count = 0;
                
                for iSub = EXPORT_TIMECOURSE(iExport).SubjectNumbers
                    
                    Count = Count + 1;
                    
                    % Regular Condition.
                    
                    SAVE_NAME = [EXPORT_TIMECOURSE(iExport).Full_Name '_S' nDigitString(iSub,2) '_' nDigitString(EXPORT_TIMECOURSE(iExport).SPNID,4)];
                    SAVE_DATA = EXPORT_TIMECOURSE(iExport).Data(:,:,Count);
                    
                    ProgressBar.Message = ['Exporting data: ' SAVE_NAME app.ExportFormatButtonGroup.SelectedObject.Text];
                    
                    switch app.ExportFormatButtonGroup.SelectedObject.Text
                        
                        case '.MAT'
                            save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME '.mat'],'SAVE_DATA');
                            
                        case '.AVR'
                            besa_save2Avr_v2(SAVE_DIRECTORY_EXPERIMENT, [SAVE_NAME '.avr'], SAVE_DATA, EXPORT_TIMECOURSE(iExport).TimeVector,{app.CallingApp.E.labels},1,1,EXPORT_TIMECOURSE(iExport).Regular_Condition);
                            
                    end
                    
                    % Irregular Condition.
                    
                    if app.ExportRandomConditionsCheckBox.Value && ~app.DifferenceWaveButton_Timecourse.Value
                        
                        SAVE_NAME_IRREGULAR = [EXPORT_TIMECOURSE(iExport).Full_Name '_S' nDigitString(iSub,2) '_' nDigitString(EXPORT_TIMECOURSE(iExport).SPNID,4) '_IRREGULAR'];
                        SAVE_DATA_IRREGULAR = EXPORT_TIMECOURSE(iExport).Data_Irregular(:,:,Count);
                        
                        ProgressBar.Message = ['Exporting data: ' SAVE_NAME_IRREGULAR app.ExportFormatButtonGroup.SelectedObject.Text];
                        
                        switch app.ExportFormatButtonGroup.SelectedObject.Text
                            
                            case '.MAT'
                                save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME_IRREGULAR '.mat'],'SAVE_DATA_IRREGULAR');
                                
                            case '.AVR'
                                besa_save2Avr_v2(SAVE_DIRECTORY_EXPERIMENT, [SAVE_NAME_IRREGULAR '.avr'], SAVE_DATA, EXPORT_TIMECOURSE(iExport).TimeVector,{app.CallingApp.E.labels},1,1,EXPORT_TIMECOURSE(iExport).Irregular_Condition);
                                
                        end
                        
                        
                    end
                    
                end
                
                % =========================================================== %
                % Save the average across all subjects for the current
                % export.
                % =========================================================== %
                
                % Regular condition.
                
                SAVE_NAME = [EXPORT_TIMECOURSE(iExport).Full_Name '_SXX_' nDigitString(EXPORT_TIMECOURSE(iExport).SPNID,4)];
                SAVE_DATA = mean(EXPORT_TIMECOURSE(iExport).Data,3);
                
                ProgressBar.Message = ['Exporting data: ' SAVE_NAME app.ExportFormatButtonGroup.SelectedObject.Text];
                
                switch app.ExportFormatButtonGroup.SelectedObject.Text
                    case '.MAT'
                        save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME '.mat'],'SAVE_DATA');
                        TIME = EXPORT_TIMECOURSE(iExport).TimeVector;
                        save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME '_TIME.mat'],'TIME');
                    case '.AVR'
                        besa_save2Avr_v2(SAVE_DIRECTORY_EXPERIMENT, [SAVE_NAME '.avr'], SAVE_DATA, EXPORT_TIMECOURSE(iExport).TimeVector,{app.CallingApp.E.labels},1,1,EXPORT_TIMECOURSE(iExport).Regular_Condition);
                end
                
                % Irregular condition.
                
                if app.ExportRandomConditionsCheckBox.Value && ~app.DifferenceWaveButton_Timecourse.Value
                    
                    SAVE_NAME_IRREGULAR = [EXPORT_TIMECOURSE(iExport).Full_Name '_SXX_' nDigitString(EXPORT_TIMECOURSE(iExport).SPNID,4) '_IRREGULAR'];
                    SAVE_DATA_IRREGULAR = mean(EXPORT_TIMECOURSE(iExport).Data_Irregular,3);
                    
                    ProgressBar.Message = ['Exporting data: ' SAVE_NAME_IRREGULAR app.ExportFormatButtonGroup.SelectedObject.Text];
                    
                    switch app.ExportFormatButtonGroup.SelectedObject.Text
                        case '.MAT'
                            save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME_IRREGULAR '.mat'],'SAVE_DATA_IRREGULAR');
                            TIME = EXPORT_TIMECOURSE(iExport).TimeVector;
                            save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME_IRREGULAR '_TIME.mat'],'TIME');
                        case '.AVR'
                            besa_save2Avr_v2(SAVE_DIRECTORY_EXPERIMENT, [SAVE_NAME_IRREGULAR '.avr'], SAVE_DATA_IRREGULAR, EXPORT_TIMECOURSE(iExport).TimeVector,{app.CallingApp.E.labels},1,1,EXPORT_TIMECOURSE(iExport).Irregular_Condition);
                    end
                    
                end
                
            end
            
            % =========================================================== %
            % Produce a variable summarising the conditions to be exported,
            % but sorted according to the experiment.
            % =========================================================== %
            
            UniqueExperiments = unique({EXPORT_TIMECOURSE.Full_Name});
            
            EXPORT_TIMECOURSE_EXP = struct();
            for iExp = 1:length(UniqueExperiments)
                EXPERIMENT_DATA = EXPORT_TIMECOURSE(strcmp({EXPORT_TIMECOURSE.Full_Name},UniqueExperiments{iExp}));
                EXPORT_TIMECOURSE_EXP(iExp).SPNID = [EXPERIMENT_DATA.SPNID];
                EXPORT_TIMECOURSE_EXP(iExp).Project = EXPERIMENT_DATA(1).Project;
                EXPORT_TIMECOURSE_EXP(iExp).Experiment = EXPERIMENT_DATA(1).Experiment;
                EXPORT_TIMECOURSE_EXP(iExp).Full_Name = EXPERIMENT_DATA(1).Full_Name;
                EXPORT_TIMECOURSE_EXP(iExp).Data = {EXPERIMENT_DATA.Data};
                EXPORT_TIMECOURSE_EXP(iExp).Data_Irregular = {EXPERIMENT_DATA.Data_Irregular};
                EXPORT_TIMECOURSE_EXP(iExp).Time_Vector = {EXPERIMENT_DATA.TimeVector};
            end
            
            % =========================================================== %
            % Multiple time vectors are assigned to the grand average data,
            % but we only need one. Thus, we will test to see whether they
            % are all identical (they should be), and throw an error if
            % not.
            % =========================================================== %
            
            for iExp = length(EXPORT_TIMECOURSE_EXP):-1:1
                if length(unique(cellfun(@length,EXPORT_TIMECOURSE_EXP(iExp).Time_Vector))) > 1
                    warning(['A single experiment had more than one Time Vector range between conditions. In this case, the average across conditions cannot be exported - ' EXPORT_TIMECOURSE_EXP(iExp).Full_Name])
                    EXPORT_TIMECOURSE_EXP(iExp) = [];
                else
                    EXPORT_TIMECOURSE_EXP(iExp).Time_Vector = EXPORT_TIMECOURSE_EXP(iExp).Time_Vector{1};
                end
            end
            
            % =========================================================== %
            % We have the GA data for each subject, stored according to the
            % experiment and project they belong to. We can now loop
            % through each subject and save the average across the selected
            % conditions for each experiment.
            % =========================================================== %
            
            for iExp = 1:length(EXPORT_TIMECOURSE_EXP)
                
                SAVE_DIRECTORY_EXPERIMENT = [Save_Directory filesep EXPORT_TIMECOURSE_EXP(iExp).Full_Name filesep];
                if ~exist(SAVE_DIRECTORY_EXPERIMENT); mkdir(SAVE_DIRECTORY_EXPERIMENT); end
                
                GA_DATA = mean(cat(4,EXPORT_TIMECOURSE_EXP(iExp).Data{:}),4);
                GA_DATA_IRREGULAR = mean(cat(4,EXPORT_TIMECOURSE_EXP(iExp).Data_Irregular{:}),4);
                
                SGA_DATA = mean(GA_DATA,3);
                SGA_DATA_IRREGULAR = mean(GA_DATA_IRREGULAR,3);
                
                % =========================================================== %
                % First, through all the subjects.
                % =========================================================== %
                
                % Regular condition.
                
                for iSub = 1:size(GA_DATA,3)
                    
                    SAVE_NAME = [EXPORT_TIMECOURSE_EXP(iExp).Full_Name '_S' nDigitString(iSub,2) '_XXXX'];
                    SAVE_DATA = GA_DATA(:,:,iSub);
                    
                    ProgressBar.Message = ['Exporting data: ' SAVE_NAME app.ExportFormatButtonGroup.SelectedObject.Text];
                    
                    switch app.ExportFormatButtonGroup.SelectedObject.Text
                        case '.MAT'
                            save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME '.mat'],'SAVE_DATA');
                            
                        case '.AVR'
                            besa_save2Avr_v2(SAVE_DIRECTORY_EXPERIMENT, [SAVE_NAME '.avr'], SAVE_DATA, EXPORT_TIMECOURSE_EXP(iExp).Time_Vector,{app.CallingApp.E.labels},1,1,'COND_AV');
                    end
                    
                end
                
                % Irregular condition.
                
                if app.ExportRandomConditionsCheckBox.Value && ~app.DifferenceWaveButton_Timecourse.Value
                    
                    for iSub = 1:size(GA_DATA_IRREGULAR,3)
                        
                        SAVE_NAME_IRREGULAR = [EXPORT_TIMECOURSE_EXP(iExp).Full_Name '_S' nDigitString(iSub,2) '_XXXX_IRREGULAR'];
                        SAVE_DATA_IRREGULAR = GA_DATA_IRREGULAR(:,:,iSub);
                        
                        ProgressBar.Message = ['Exporting data: ' SAVE_NAME_IRREGULAR app.ExportFormatButtonGroup.SelectedObject.Text];
                        
                        switch app.ExportFormatButtonGroup.SelectedObject.Text
                            case '.MAT'
                                save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME_IRREGULAR '.mat'],'SAVE_DATA_IRREGULAR');
                                
                            case '.AVR'
                                besa_save2Avr_v2(SAVE_DIRECTORY_EXPERIMENT, [SAVE_NAME_IRREGULAR '.avr'], SAVE_DATA, EXPORT_TIMECOURSE_EXP(iExp).Time_Vector,{app.CallingApp.E.labels},1,1,'COND_AV');
                        end
                        
                    end
                    
                end
                
                % =========================================================== %
                % Second, one super grand average file that contains the
                % average across all subjects and conditions.
                % =========================================================== %
                
                % Regular condition.
                
                SAVE_NAME = [EXPORT_TIMECOURSE_EXP(iExp).Full_Name '_SXX_XXXX'];
                
                ProgressBar.Message = ['Exporting data: ' SAVE_NAME app.ExportFormatButtonGroup.SelectedObject.Text];
                
                switch app.ExportFormatButtonGroup.SelectedObject.Text
                    case '.MAT'
                        save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME '.mat'],'SGA_DATA');
                    case '.AVR'
                        besa_save2Avr_v2(SAVE_DIRECTORY_EXPERIMENT, [SAVE_NAME '.avr'], SGA_DATA, EXPORT_TIMECOURSE_EXP(iExp).Time_Vector,{app.CallingApp.E.labels},1,1,'COND_AV');
                end
                
                % Irregular condition.
                
                if app.ExportRandomConditionsCheckBox.Value && ~app.DifferenceWaveButton_Timecourse.Value
                    
                    SAVE_NAME_IRREGULAR = [EXPORT_TIMECOURSE_EXP(iExp).Full_Name '_SXX_XXXX_IRREGULAR'];
                    
                    ProgressBar.Message = ['Exporting data: ' SAVE_NAME_IRREGULAR app.ExportFormatButtonGroup.SelectedObject.Text];
                    
                    switch app.ExportFormatButtonGroup.SelectedObject.Text
                        case '.MAT'
                            save([SAVE_DIRECTORY_EXPERIMENT SAVE_NAME_IRREGULAR '.mat'],'SGA_DATA_IRREGULAR');
                        case '.AVR'
                            besa_save2Avr_v2(SAVE_DIRECTORY_EXPERIMENT, [SAVE_NAME_IRREGULAR '.avr'], SGA_DATA_IRREGULAR, EXPORT_TIMECOURSE_EXP(iExp).Time_Vector,{app.CallingApp.E.labels},1,1,'COND_AV');
                    end
                    
                end
                
            end
            
            ProgressBar.Message = 'Export complete!';
            pause(1);
            
            close(ProgressBar);
            
        end

        % Value changed function: AttendRegularityCheckBox, 
        % IgnoreRegularityCheckBox, MinDEditField, 
        % MinSPNuVEditField, MinWEditField
        function FilterValueChanged(app, event)
            
            Indices_SPN = abs([app.CAT.SPN]) >= app.MinSPNuVEditField.Value;
            
            Indices_D = abs([app.CAT.D]) >= app.MinDEditField.Value;
            
            if app.MinWEditField.Value == 0
                Indices_W = logical(ones(1,length([app.CAT.W])));
            else
                Indices_W = [app.CAT.W] >=  app.MinWEditField.Value;
            end
            
            if app.AttendRegularityCheckBox.Value && app.IgnoreRegularityCheckBox.Value
                Indices_AttendReg = logical([app.CAT.Attend_Regularity]) | logical(~[app.CAT.Attend_Regularity]);
            elseif app.AttendRegularityCheckBox.Value
                Indices_AttendReg = logical([app.CAT.Attend_Regularity]);
            elseif app.IgnoreRegularityCheckBox.Value
                Indices_AttendReg = logical(~[app.CAT.Attend_Regularity]);
            else
                Indices_AttendReg = logical(ones(1,length([app.CAT.W])));
            end
            
            FilterIndices = Indices_SPN & Indices_D & Indices_W & Indices_AttendReg;
            FilterIndicesCell = num2cell(FilterIndices);
            
            app.CONDTOSHOW = app.CAT(FilterIndices);
            [app.CAT.Included] = FilterIndicesCell{:};
            
            for iCond = 1:length(app.CONDTOSHOW)
                app.CONDTOSHOW(iCond).Summary_Name = [app.CONDTOSHOW(iCond).Full_Name ' (' num2str(app.CONDTOSHOW(iCond).SPNID) ') - ' app.CONDTOSHOW(iCond).Regular_Condition];
            end
            
            app.ProjectsListBox.Items = {app.CONDTOSHOW.Summary_Name};
            app.ProjectsListBox.ItemsData = [app.CONDTOSHOW.SPNID];
            
            ExtractPlotData(app);
            
        end

        % Value changed function: XButton_D, XButton_SPN, 
        % XButton_W, YButton_D, YButton_SPN, YButton_W
        function XYButton_ValueChanged(app, event)
            
            AllButtons = {'Button_SPN' 'Button_W' 'Button_D'};
            
            for iButton = 1:length(AllButtons)
                if ~strcmp(app.([event.Source.Text AllButtons{iButton}]).Tag,event.Source.Tag)
                    app.([event.Source.Text AllButtons{iButton}]).Value = 0;
                end
            end
            
            if strcmp(event.Source.Text,'X')
                app.FILTER.XParam = event.Source.Tag;
            elseif strcmp(event.Source.Text,'Y')
                app.FILTER.YParam = event.Source.Tag;
            end
            
            if ~isfield(app.FILTER,'XParam')
                app.FILTER.XParam = [];
            end
            
            if ~isfield(app.FILTER,'YParam')
                app.FILTER.YParam = [];
            end
            
            ExtractPlotData(app);
            
        end

        % Value changed function: DifferenceWaveButton_Timecourse
        function DifferenceWaveButton_TimecourseValueChanged(app, event)
            value = app.DifferenceWaveButton_Timecourse.Value;
            if value
                app.ExportRandomConditionsCheckBox.Value = 0;
                app.ExportRandomConditionsCheckBox.Enable = 0;
            else
                app.ExportRandomConditionsCheckBox.Enable = 1;
            end
        end

        % Selection changed function: ExportFormatButtonGroup
        function ExportFormatButtonGroupSelectionChanged(app, event)
            
            selectedButton = app.ExportFormatButtonGroup.SelectedObject;
            
            if strcmp(selectedButton.Text,'.MAT') | strcmp(selectedButton.Text,'.AVR')
                
                app.FilterPanel.Enable = 'on';
                app.SupplementaryPanel.Enable = 'on';
                app.DifferenceWaveButton_Timecourse.Enable = 'on';
                app.DataFileforExportButtonGroup.Enable = 'off';
                
                FilterValueChanged(app, []);
                
            elseif strcmp(selectedButton.Text,'.SET')
                
                app.FilterPanel.Enable = 'on';
                app.SupplementaryPanel.Enable = 'on';
                app.DifferenceWaveButton_Timecourse.Value = 0;
                app.DifferenceWaveButton_Timecourse.Enable = 'off';
                app.DataFileforExportButtonGroup.Enable = 'off';
                
                FilterValueChanged(app, []);
                
            elseif strcmp(selectedButton.Text,'BIDS')
                
                app.FilterPanel.Enable = 'off';
                app.ExportRandomConditionsCheckBox.Value = 0;
                app.SupplementaryPanel.Enable = 'off';
                app.DifferenceWaveButton_Timecourse.Value = 0;
                app.DifferenceWaveButton_Timecourse.Enable = 'off';
                app.DataFileforExportButtonGroup.Enable = 'on';
                
                cla(app.UIAxesWaveform);
                app.UIAxesWaveform.Visible = 'off';
                
                app.ProjectsListBox.Items = {app.EXP.Full_Name};
                app.ProjectsListBox.ItemsData = [];
                
            end
            
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {516, 516};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {484, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 868 516];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {484, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create TabGroup
            app.TabGroup = uitabgroup(app.LeftPanel);
            app.TabGroup.SelectionChangedFcn = createCallbackFcn(app, @TabGroupSelectionChanged, true);
            app.TabGroup.Position = [1 7 477 509];

            % Create MeanValuesTab
            app.MeanValuesTab = uitab(app.TabGroup);
            app.MeanValuesTab.Title = 'Mean Values';

            % Create ConditionsListBoxLabel
            app.ConditionsListBoxLabel = uilabel(app.MeanValuesTab);
            app.ConditionsListBoxLabel.HorizontalAlignment = 'center';
            app.ConditionsListBoxLabel.Position = [9 456 311 23];
            app.ConditionsListBoxLabel.Text = 'Conditions';

            % Create ConditionsListBox
            app.ConditionsListBox = uilistbox(app.MeanValuesTab);
            app.ConditionsListBox.Multiselect = 'on';
            app.ConditionsListBox.ValueChangedFcn = createCallbackFcn(app, @ConditionsListBoxValueChanged, true);
            app.ConditionsListBox.Position = [8 162 313 294];
            app.ConditionsListBox.Value = {'Item 1'};

            % Create ElectrodesListBox
            app.ElectrodesListBox = uilistbox(app.MeanValuesTab);
            app.ElectrodesListBox.Multiselect = 'on';
            app.ElectrodesListBox.ValueChangedFcn = createCallbackFcn(app, @ElectrodesListBoxValueChanged, true);
            app.ElectrodesListBox.Position = [328 162 136 294];
            app.ElectrodesListBox.Value = {'Item 1'};

            % Create ElectrodesListBoxLabel
            app.ElectrodesListBoxLabel = uilabel(app.MeanValuesTab);
            app.ElectrodesListBoxLabel.HorizontalAlignment = 'center';
            app.ElectrodesListBoxLabel.Position = [328 455 136 23];
            app.ElectrodesListBoxLabel.Text = 'Electrodes';

            % Create DifferenceWaveButton
            app.DifferenceWaveButton = uibutton(app.MeanValuesTab, 'state');
            app.DifferenceWaveButton.ValueChangedFcn = createCallbackFcn(app, @DifferenceWaveButtonValueChanged, true);
            app.DifferenceWaveButton.Text = 'Difference Wave';
            app.DifferenceWaveButton.Position = [9 135 451 22];

            % Create SelectTimeButton
            app.SelectTimeButton = uibutton(app.MeanValuesTab, 'state');
            app.SelectTimeButton.ValueChangedFcn = createCallbackFcn(app, @SelectTimeButtonValueChanged, true);
            app.SelectTimeButton.Text = 'Select Time';
            app.SelectTimeButton.Position = [103 90 357 22];

            % Create ExportMeanButton
            app.ExportMeanButton = uibutton(app.MeanValuesTab, 'push');
            app.ExportMeanButton.ButtonPushedFcn = createCallbackFcn(app, @ExportMeanButtonPushed, true);
            app.ExportMeanButton.Position = [9 2 87 127];
            app.ExportMeanButton.Text = 'Export';

            % Create StartEditField_2Label
            app.StartEditField_2Label = uilabel(app.MeanValuesTab);
            app.StartEditField_2Label.HorizontalAlignment = 'right';
            app.StartEditField_2Label.Position = [103 46 31 22];
            app.StartEditField_2Label.Text = 'Start';

            % Create StartEditField
            app.StartEditField = uieditfield(app.MeanValuesTab, 'numeric');
            app.StartEditField.ValueChangedFcn = createCallbackFcn(app, @StartEditFieldValueChanged, true);
            app.StartEditField.Position = [149 46 311 22];

            % Create EndEditField_2Label
            app.EndEditField_2Label = uilabel(app.MeanValuesTab);
            app.EndEditField_2Label.HorizontalAlignment = 'right';
            app.EndEditField_2Label.Position = [103 2 27 22];
            app.EndEditField_2Label.Text = 'End';

            % Create EndEditField
            app.EndEditField = uieditfield(app.MeanValuesTab, 'numeric');
            app.EndEditField.ValueChangedFcn = createCallbackFcn(app, @EndEditFieldValueChanged, true);
            app.EndEditField.Position = [145 2 316 22];

            % Create FullTimecourseTab
            app.FullTimecourseTab = uitab(app.TabGroup);
            app.FullTimecourseTab.Title = 'Full Timecourse';

            % Create ProjectsPanel
            app.ProjectsPanel = uipanel(app.FullTimecourseTab);
            app.ProjectsPanel.Title = 'Projects';
            app.ProjectsPanel.Position = [8 2 100 474];

            % Create ProjectsListBox
            app.ProjectsListBox = uilistbox(app.ProjectsPanel);
            app.ProjectsListBox.Items = {};
            app.ProjectsListBox.Multiselect = 'on';
            app.ProjectsListBox.Position = [6 6 87 433];
            app.ProjectsListBox.Value = {};

            % Create DifferenceWaveButton_Timecourse
            app.DifferenceWaveButton_Timecourse = uibutton(app.FullTimecourseTab, 'state');
            app.DifferenceWaveButton_Timecourse.ValueChangedFcn = createCallbackFcn(app, @DifferenceWaveButton_TimecourseValueChanged, true);
            app.DifferenceWaveButton_Timecourse.Text = 'Difference Wave';
            app.DifferenceWaveButton_Timecourse.Position = [119 54 345 22];

            % Create ExportTimecourseButton
            app.ExportTimecourseButton = uibutton(app.FullTimecourseTab, 'push');
            app.ExportTimecourseButton.ButtonPushedFcn = createCallbackFcn(app, @ExportTimecourseButtonPushed, true);
            app.ExportTimecourseButton.Position = [119 8 345 39];
            app.ExportTimecourseButton.Text = 'Export';

            % Create ExportFormatButtonGroup
            app.ExportFormatButtonGroup = uibuttongroup(app.FullTimecourseTab);
            app.ExportFormatButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ExportFormatButtonGroupSelectionChanged, true);
            app.ExportFormatButtonGroup.Title = 'Export Format';
            app.ExportFormatButtonGroup.Position = [119 354 146 120];

            % Create MATButton
            app.MATButton = uiradiobutton(app.ExportFormatButtonGroup);
            app.MATButton.Text = '.MAT';
            app.MATButton.Position = [11 74 58 22];
            app.MATButton.Value = true;

            % Create AVRButton
            app.AVRButton = uiradiobutton(app.ExportFormatButtonGroup);
            app.AVRButton.Text = '.AVR';
            app.AVRButton.Position = [11 52 65 22];

            % Create SETButton
            app.SETButton = uiradiobutton(app.ExportFormatButtonGroup);
            app.SETButton.Text = '.SET';
            app.SETButton.Position = [83 74 65 22];

            % Create BIDButton
            app.BIDButton = uiradiobutton(app.ExportFormatButtonGroup);
            app.BIDButton.Text = 'BIDS';
            app.BIDButton.Position = [83 52 65 22];

            % Create FilterPanel
            app.FilterPanel = uipanel(app.FullTimecourseTab);
            app.FilterPanel.Title = 'Filter';
            app.FilterPanel.Position = [119 152 345 190];

            % Create MinSPNuVEditFieldLabel
            app.MinSPNuVEditFieldLabel = uilabel(app.FilterPanel);
            app.MinSPNuVEditFieldLabel.HorizontalAlignment = 'right';
            app.MinSPNuVEditFieldLabel.Position = [7 77 79 22];
            app.MinSPNuVEditFieldLabel.Text = 'Min SPN (uV)';

            % Create MinSPNuVEditField
            app.MinSPNuVEditField = uieditfield(app.FilterPanel, 'numeric');
            app.MinSPNuVEditField.ValueChangedFcn = createCallbackFcn(app, @FilterValueChanged, true);
            app.MinSPNuVEditField.Position = [101 77 100 22];

            % Create MinWEditFieldLabel
            app.MinWEditFieldLabel = uilabel(app.FilterPanel);
            app.MinWEditFieldLabel.HorizontalAlignment = 'right';
            app.MinWEditFieldLabel.Position = [47 44 39 22];
            app.MinWEditFieldLabel.Text = 'Min W';

            % Create MinWEditField
            app.MinWEditField = uieditfield(app.FilterPanel, 'numeric');
            app.MinWEditField.ValueChangedFcn = createCallbackFcn(app, @FilterValueChanged, true);
            app.MinWEditField.Position = [101 44 100 22];

            % Create MinDEditFieldLabel
            app.MinDEditFieldLabel = uilabel(app.FilterPanel);
            app.MinDEditFieldLabel.HorizontalAlignment = 'right';
            app.MinDEditFieldLabel.Position = [49 12 37 22];
            app.MinDEditFieldLabel.Text = 'Min D';

            % Create MinDEditField
            app.MinDEditField = uieditfield(app.FilterPanel, 'numeric');
            app.MinDEditField.ValueChangedFcn = createCallbackFcn(app, @FilterValueChanged, true);
            app.MinDEditField.Position = [101 12 100 22];

            % Create IgnoreRegularityCheckBox
            app.IgnoreRegularityCheckBox = uicheckbox(app.FilterPanel);
            app.IgnoreRegularityCheckBox.ValueChangedFcn = createCallbackFcn(app, @FilterValueChanged, true);
            app.IgnoreRegularityCheckBox.Text = 'Ignore Regularity';
            app.IgnoreRegularityCheckBox.Position = [88 110 113 22];
            app.IgnoreRegularityCheckBox.Value = true;

            % Create AttendRegularityCheckBox
            app.AttendRegularityCheckBox = uicheckbox(app.FilterPanel);
            app.AttendRegularityCheckBox.ValueChangedFcn = createCallbackFcn(app, @FilterValueChanged, true);
            app.AttendRegularityCheckBox.Text = 'Attend Regularity';
            app.AttendRegularityCheckBox.Position = [88 139 114 22];
            app.AttendRegularityCheckBox.Value = true;

            % Create XButton_SPN
            app.XButton_SPN = uibutton(app.FilterPanel, 'state');
            app.XButton_SPN.ValueChangedFcn = createCallbackFcn(app, @XYButton_ValueChanged, true);
            app.XButton_SPN.Tag = 'X_SPN';
            app.XButton_SPN.Text = 'X';
            app.XButton_SPN.Position = [227 77 45 22];

            % Create YButton_SPN
            app.YButton_SPN = uibutton(app.FilterPanel, 'state');
            app.YButton_SPN.ValueChangedFcn = createCallbackFcn(app, @XYButton_ValueChanged, true);
            app.YButton_SPN.Tag = 'Y_SPN';
            app.YButton_SPN.Text = 'Y';
            app.YButton_SPN.Position = [274 77 45 22];

            % Create XButton_W
            app.XButton_W = uibutton(app.FilterPanel, 'state');
            app.XButton_W.ValueChangedFcn = createCallbackFcn(app, @XYButton_ValueChanged, true);
            app.XButton_W.Tag = 'X_W';
            app.XButton_W.Text = 'X';
            app.XButton_W.Position = [227 44 45 22];

            % Create YButton_W
            app.YButton_W = uibutton(app.FilterPanel, 'state');
            app.YButton_W.ValueChangedFcn = createCallbackFcn(app, @XYButton_ValueChanged, true);
            app.YButton_W.Tag = 'Y_W';
            app.YButton_W.Text = 'Y';
            app.YButton_W.Position = [274 44 45 22];

            % Create XButton_D
            app.XButton_D = uibutton(app.FilterPanel, 'state');
            app.XButton_D.ValueChangedFcn = createCallbackFcn(app, @XYButton_ValueChanged, true);
            app.XButton_D.Tag = 'X_D';
            app.XButton_D.Text = 'X';
            app.XButton_D.Position = [227 12 45 22];

            % Create YButton_D
            app.YButton_D = uibutton(app.FilterPanel, 'state');
            app.YButton_D.ValueChangedFcn = createCallbackFcn(app, @XYButton_ValueChanged, true);
            app.YButton_D.Tag = 'Y_D';
            app.YButton_D.Text = 'Y';
            app.YButton_D.Position = [274 12 45 22];

            % Create SupplementaryPanel
            app.SupplementaryPanel = uipanel(app.FullTimecourseTab);
            app.SupplementaryPanel.Title = 'Supplementary';
            app.SupplementaryPanel.Position = [119 90 345 54];

            % Create ExportRandomConditionsCheckBox
            app.ExportRandomConditionsCheckBox = uicheckbox(app.SupplementaryPanel);
            app.ExportRandomConditionsCheckBox.Text = 'Export Random Conditions (Doubles Data Files!)';
            app.ExportRandomConditionsCheckBox.Position = [7 10 284 22];

            % Create DataFileforExportButtonGroup
            app.DataFileforExportButtonGroup = uibuttongroup(app.FullTimecourseTab);
            app.DataFileforExportButtonGroup.Enable = 'off';
            app.DataFileforExportButtonGroup.Title = 'Data File for Export';
            app.DataFileforExportButtonGroup.Position = [271 354 193 120];

            % Create BDFContinuousButton
            app.BDFContinuousButton = uiradiobutton(app.DataFileforExportButtonGroup);
            app.BDFContinuousButton.Text = 'BDF (Continuous)';
            app.BDFContinuousButton.Position = [11 74 118 22];
            app.BDFContinuousButton.Value = true;

            % Create SETEpochedButton
            app.SETEpochedButton = uiradiobutton(app.DataFileforExportButtonGroup);
            app.SETEpochedButton.Text = 'SET (Epoched)';
            app.SETEpochedButton.Position = [11 52 104 22];

            % Create SETEpochedICAButton
            app.SETEpochedICAButton = uiradiobutton(app.DataFileforExportButtonGroup);
            app.SETEpochedICAButton.Text = 'SET (Epoched, ICA)';
            app.SETEpochedICAButton.Position = [11 30 131 22];

            % Create SETEpochedICAMaxButton
            app.SETEpochedICAMaxButton = uiradiobutton(app.DataFileforExportButtonGroup);
            app.SETEpochedICAMaxButton.Text = 'SET (Epoched, ICA, Max)';
            app.SETEpochedICAMaxButton.Position = [11 9 160 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxesWaveform
            app.UIAxesWaveform = uiaxes(app.RightPanel);
            title(app.UIAxesWaveform, 'Individual Conditions ')
            xlabel(app.UIAxesWaveform, 'Time')
            ylabel(app.UIAxesWaveform, 'uV')
            zlabel(app.UIAxesWaveform, 'Z')
            app.UIAxesWaveform.PlotBoxAspectRatio = [1.63636363636364 1 1];
            app.UIAxesWaveform.YTick = [0 0.5 1];
            app.UIAxesWaveform.FontSize = 16;
            app.UIAxesWaveform.ButtonDownFcn = createCallbackFcn(app, @UIAxesButtonDown, true);
            app.UIAxesWaveform.Position = [7 21 372 262];

            % Create UIAxesLegend
            app.UIAxesLegend = uiaxes(app.RightPanel);
            app.UIAxesLegend.PlotBoxAspectRatio = [2.97297297297297 1 1];
            app.UIAxesLegend.XTick = [];
            app.UIAxesLegend.YTick = [];
            app.UIAxesLegend.Box = 'on';
            app.UIAxesLegend.Position = [7 317 372 187];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SPNCAT_Export_func(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end