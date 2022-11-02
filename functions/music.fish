function music -d 'DISCRIPTION'
    argparse \
        -x 'v,h' \
        'v/version' 'h/help' -- $argv
    or return 1

    set --local version_apple_music 'v1.0.0'

    if set -q _flag_version
        echo "music: " $version_apple_music
    else if set -q _flag_help
        __music_help
    else
        if test -n "$argv"
            set --local command $argv[1]
            if test $command = 'help'
                __music_help
            else if test $command = 'play'
                __music_play
            else if test $command = 'pause'
                __music_pause
            else if test $command = 'next'
                __music_next
            else if test $command = 'prev'
                __music_prev
            else if test $command = 'status'
                __music_status
            else if test $command = 'info'
                __music_info
            else
                __music_invalid
            end
        else
            __music_invalid
        end
    end
end

function __music_help
    printf '%s\n' \
    'Usage:' \
    '      music [OPTION]' \
    '' \
    'Options:' \
    '      -v, --version       Show version info' \
    '      -h, --help          Show help' \
    '' \
    'Commands:' \
    '      play                Play' \
    '      pause               Pause' \
    '      next                Next track' \
    '      prev                Previous track' \
    '      status              Show status (playing/paused)' \
    '      info                Show track info'
end

function __music_play
    osascript -e 'tell application "Music" to play'
end

function __music_pause
    osascript -e 'tell application "Music" to pause'
end

function __music_next
    osascript -e 'tell application "Music" to next track'
end

function __music_prev
    osascript -e 'tell application "Music" to previous track'
end

function __music_status
    osascript -e 'tell application "Music" to player state as string'
end

function __music_info
    # FIXME: Avoid DRY
    set --local cn (set_color $fish_color_normal)
    set --local cs (set_color $fish_color_cwd)
    
    set --local name (osascript -e 'tell application "Music" to name of current track as string')
    set --local artist (osascript -e 'tell application "Music" to artist of current track as string')
    set --local album (osascript -e 'tell application "Music" to album of current track as string')
    echo "Listening to "$cs$name$cn" by "$cs$artist$cn" from "$cs$album
end

function __music_invalid
    # FIXME: Avoid DRY
    set --local cn (set_color $fish_color_normal)
    set --local ce (set_color $fish_color_error)

    echo $ce"Invalid command"$cn
end
