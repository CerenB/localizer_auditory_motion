function [cfg] = loadAudioFiles(cfg)

    % Set the subj name to retrieve its own sounds
    if cfg.debug.do
        subjName = 'sub-ctrl666';
    else
        subjName = 'sub-mann';
    end

    
    %% Load the sounds
    freq = [];
    
    %load static sounds
    fileName = fullfile('input', 'Static', 'Static.wav');
    [soundData.S, freq(1)] = audioread(fileName);
    soundData.S = soundData.S';
    
    fileName = fullfile('input', 'Static', 'Static_T.wav');
    [soundData.S_T, freq(2)] = audioread(fileName);
    soundData.S_T = soundData.S_T';

    % load moving sounds
    

    directions = 'UDRL';

    for isTarget = 0:1

        for i = 1:numel(directions)

            suffix = directions(i);
            if isTarget
                suffix = [suffix '_T'];
            end

            fileName = fullfile('input', 'Motion', subjName, ...
                                ['rms_', subjName, '_' suffix '.wav']);

            [tmp, freq(end + 1)] = audioread(fileName); %#ok<*AGROW>
            soundData.(suffix) = tmp';

        end
    end

    if length(unique(freq)) > 1
        error ('Sounds dont have the same frequency');
    else
        freq = unique(freq);
    end

    cfg.soundData = soundData;
    cfg.audio.fs = freq;
    
end

% 
% % static Stimuli
%     fileName = fullfile('input', 'Static', 'Static.wav');
%     [soundData.S, freq1] = audioread(fileName);
%     soundData.S = soundData.S';
% 
%     % motion input
%     fileName = fullfile('input', 'Motion', subjName, [subjName, '_LRL_rms.wav']);
%     [soundData.LRL, freq2] = audioread(fileName);
%     soundData.LRL = soundData.LRL';
% 
%     fileName = fullfile('input', 'Motion', subjName, [subjName, '_RLR_rms.wav']);
%     [soundData.RLR, freq3] = audioread(fileName);
%     soundData.RLR = soundData.RLR';
% 
%     %% Targets
% 
%     % static Stimuli
%     fileName = fullfile('input', 'Static', 'Static_T.wav');
%     [soundData.S_T, freq4] = audioread(fileName);
%     soundData.S_T = soundData.S_T';
% 
%     % motion Stimuli
%     fileName = fullfile('input', 'Motion', subjName, [subjName, '_LRL_T_rms.wav']);
%     [soundData.LRL_T, freq5] = audioread(fileName);
%     soundData.LRL_T = soundData.LRL_T';
% 
%     fileName = fullfile('input', 'Motion', subjName, [subjName, '_RLR_T_rms.wav']);
%     [soundData.RLR_T, freq6] = audioread(fileName);
%     soundData.RLR_T = soundData.RLR_T';
% 
%     if length(unique([freq1 freq2 freq3 freq4 freq5 freq6])) > 1
%         error ('Sounds do not have the same frequency');
%     else
%         freq = unique([freq1 freq2 freq3 freq4 freq5 freq6]);
%     end
% 
%     cfg.soundData = soundData;
%     cfg.audio.fs = freq;