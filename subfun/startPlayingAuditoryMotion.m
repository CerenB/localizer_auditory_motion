function onset  = startPlayingAuditoryMotion(cfg, thisEvent)

    %% Get parameters

    direction = thisEvent.direction;
        
    soundData = cfg.soundData;

    switch direction
        case -1
            fieldName = 'S';
        case 90
            fieldName = 'U';
        case 270
            fieldName = 'D';
        case 0
            fieldName = 'R';
        case 180
            fieldName = 'L';
    end

    if thisEvent.soundTarget == 1
        fieldName = [fieldName '_T'];
    end
    sound = soundData.(fieldName);

    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, sound);
    PsychPortAudio('Start', cfg.audio.pahandle);
    onset = GetSecs;

end