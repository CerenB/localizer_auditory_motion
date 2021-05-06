function [cfg] = loadAudioFiles(cfg)

    % Set the subj name to retrieve its own sounds
    if cfg.debug.do
        subjName = 'sub-ctrl666';
    else
        zeroPadding = 3;
        pattern = ['%0' num2str(zeroPadding) '.0f'];
        subjName = ['sub-' cfg.subject.subjectGrp, sprintf(pattern, cfg.subject.subjectNb)];
    end

    %% Load the sounds
    freq = [];

    directions = 'UDRL';

    for isTarget = 0:1

        for i = 1:numel(directions)

            suffix = directions(i);
            if isTarget
                suffix = [suffix '_T'];
            end

            fileName = fullfile('input', subjName, ...
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