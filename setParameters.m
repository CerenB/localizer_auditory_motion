function cfg = setParameters

    % AUDITORY LOCALIZER

    % Initialize the parameters and general configuration variables
    cfg = struct();

    % by default the data will be stored in an output folder created where the
    % setParamters.m file is
    % change that if you want the data to be saved somewhere else
    cfg.dir.output = fullfile( ...
                              fileparts(mfilename('fullpath')), 'output');

    %% Debug mode settings

    cfg.debug.do = true; % To test the script out of the scanner, skip PTB sync
    cfg.debug.smallWin = true; % To test on a part of the screen, change to 1
    cfg.debug.transpWin = false; % To test with trasparent full size screen

    cfg.verbose = 1;
    cfg.skipSyncTests = 0;

  %  cfg.audio.devIdx = 3; % 5 %11

    %% Engine parameters

    cfg.testingDevice = 'mri';
    cfg.eyeTracker.do = false;
    cfg.audio.do = true;

    cfg = setMonitor(cfg);

    % Keyboards
    cfg = setKeyboards(cfg);

    % MRI settings

    cfg = setMRI(cfg);
    cfg.suffix.acquisition = '0p75mmEv';

    cfg.pacedByTriggers.do = false;

    %% Experiment Design

    %     cfg.design.motionType = 'translation';
    %     cfg.design.motionType = 'radial';
    cfg.design.motionType = 'translation';
    cfg.design.names = {'static'; 'motion'};
    % 0: L--R--L; 180: R--L--R;
    cfg.design.motionDirections = [0 180]; %[0 90 180 270]
    cfg.design.nbRepetitions = 1;
    cfg.design.nbEventsPerBlock = 12;

    %% Timing

    % FOR 7T: if you want to create localizers on the fly, the following must be
    % multiples of the scanner sequence TR
    %
    % IBI
    % block length = (cfg.eventDuration + cfg.ISI) * cfg.design.nbEventsPerBlock

    % for info: not actually used since "defined" by the sound duration
    %     cfg.timing.eventDuration = 0.850; % second

    % Time between blocs in secs
    cfg.timing.IBI = 6;
    % Time between events in secs
    cfg.timing.ISI = 0.1;
    % Number of seconds before the motion stimuli are presented
    cfg.timing.onsetDelay = 5.25;
    % Number of seconds after the end all the stimuli before ending the run
    cfg.timing.endDelay = 12.25;

    % reexpress those in terms of number repetition time
    if cfg.pacedByTriggers.do

        cfg.pacedByTriggers.quietMode = true;
        cfg.pacedByTriggers.nbTriggers = 1;

        cfg.timing.eventDuration = cfg.mri.repetitionTime / 2 - 0.04; % second

        % Time between blocs in secs
        cfg.timing.IBI = 0;
        % Time between events in secs
        cfg.timing.ISI = 0;
        % Number of seconds before the motion stimuli are presented
        cfg.timing.onsetDelay = 0;
        % Number of seconds after the end all the stimuli before ending the run
        cfg.timing.endDelay = 2;
    end

    %% Auditory Stimulation

    cfg.audio.channels = 2;

    %% Task(s)

    cfg.task.name = 'auditory localizer';

    % Instruction
    cfg.task.instruction = ['1 - Detect the RED fixation cross\n' ...
                            '2 - Detected the shorter repeated sounds'];

    % Fixation cross (in pixels)
    cfg.fixation.type = 'cross';
    cfg.fixation.colorTarget = cfg.color.red;
    cfg.fixation.color = cfg.color.white;
    cfg.fixation.width = .5;
    cfg.fixation.lineWidthPix = 3;
    cfg.fixation.xDisplacement = 0;
    cfg.fixation.yDisplacement = 0;

    cfg.target.maxNbPerBlock = 1;
    cfg.target.duration = 0.5; % In secs

    cfg.extraColumns = {'direction', 'soundTarget', 'fixationTarget', 'event', 'block', 'keyName'};

end

function cfg = setMonitor(cfg)

    % Monitor parameters for PTB
    cfg.color.white = [255 255 255];
    cfg.color.black = [0 0 0];
    cfg.color.red = [255 0 0];
    cfg.color.grey = mean([cfg.color.black; cfg.color.white]);
    cfg.color.background = cfg.color.black;
    cfg.text.color = cfg.color.white;

    % Monitor parameters
    cfg.screen.monitorWidth = 50; % in cm
    cfg.screen.monitorDistance = 40; % distance from the screen in cm

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.screen.monitorWidth = 69.8;
        cfg.screen.monitorDistance = 170;
    end
end

function cfg = setKeyboards(cfg)
    cfg.keyboard.escapeKey = 'ESCAPE';
    cfg.keyboard.responseKey = {'d', 'a', 'c', 'b'}; % dnze rgyb
    
    cfg.keyboard.keyboard = [];
    cfg.keyboard.responseBox = [];

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.keyboard.keyboard = [];
        cfg.keyboard.responseBox = [];
    end
end

function cfg = setMRI(cfg)
    % letter sent by the trigger to sync stimulation and volume acquisition
    cfg.mri.triggerKey = 's';
    cfg.mri.triggerNb = 1;

    cfg.mri.repetitionTime = 1.75;

    cfg.bids.MRI.Instructions = ['1 - Detect the RED fixation cross\n' ...
                                 '2 - Detected the shorter repeated sounds'];
    cfg.bids.MRI.TaskDescription = [];
    cfg.bids.mri.SliceTiming = [0, 0.9051, 0.0603, 0.9655, 0.1206, 1.0258, 0.181, ...
                              1.0862, 0.2413, 1.1465, 0.3017, 1.2069, 0.362, ...
                              1.2672, 0.4224, 1.3275, 0.4827, 1.3879, 0.5431, ...
                              1.4482, 0.6034, 1.5086, 0.6638, 1.5689, 0.7241, ...
                              1.6293, 0.7844, 1.6896, 0.8448, 0, 0.9051, 0.0603, ...
                              0.9655, 0.1206, 1.0258, 0.181, 1.0862, 0.2413, ...
                              1.1465, 0.3017, 1.2069, 0.362, 1.2672, 0.4224, ...
                              1.3275, 0.4827, 1.3879, 0.5431, 1.4482, 0.6034, ...
                              1.5086, 0.6638, 1.5689, 0.7241, 1.6293, 0.7844, ...
                              1.6896, 0.8448];

end
