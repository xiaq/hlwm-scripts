#!/bin/bash

# disable path name expansion or * will be expanded in the line
# cmd=( $line )
set -f

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format: WxH+X+Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=20
font='Monospace-10.5'
title_font='Wenquanyi Micro Hei-11'
bgcolor=$(herbstclient get frame_border_normal_color)
selbg=$(herbstclient get window_border_active_color)
selfg='#101010'

right_width=184

conkyrc=~/.config/herbstluftwm/conkyrc
conkyfmt=~/.config/herbstluftwm/conkyfmt

childpid=()

herbstclient pad $monitor $panel_height

trayer --edge top --align right --widthtype request --height 22 \
    --margin $(( right_width + 6 )) --padding 5 &
childpid+=($!)

make_tag_part() {
    tags=( $(herbstclient tag_status $monitor) )
    for i in "${tags[@]}" ; do
        case ${i:0:1} in
            '#')
                echo -n "^bg($selbg)^fg($selfg)"
                ;;
            '+')
                echo -n "^bg(#9CA668)^fg(#141414)"
                ;;
            ':')
                echo -n "^bg()^fg(#ffffff)"
                ;;
            '!')
                echo -n "^bg(#FF0675)^fg(#141414)"
                ;;
            *)
                echo -n "^bg()^fg(#ababab)"
                ;;
        esac
        echo -n "^ca(1,herbstclient focus_monitor $monitor && "'herbstclient use "'${i:1}'")'
        echo -n " ${i:1} "
        echo -n "^ca()"
    done
}

{
    while true; do
        date +'date ^fg(#efefef)%H:%M:^fg(#909090)%S, %m-^fg(#efefef)%d %a'
        sleep 1 || break
    done &
    childpid+=($!)

    conky -c $conkyrc > >($conkyfmt) &
    childpid+=($!)

    herbstclient --idle
    kill "${childpid[@]}"
} | {
    tag_part=$(make_tag_part)
    visible=true
    date=""
    windowtitle=""
    sys_status=""
    while true; do
        bordercolor="#26221C"
        separator="^bg()^fg($selbg)|"
        # draw tags
        echo -n "$tag_part"
        echo -n "$separator"

        # system status
        echo -n "^bg()^fg() $sys_status "
        echo -n "$separator"

        # tab bar
        echo -n "^fn($title_font)"
        echo -n "^bg()^fg() ${tabbar_part//^/^^}"
        echo -n "^fn()"

        # right part: currently only date
        right_part="$separator^bg() $date $separator"
        #right_text_only=$(echo -n "$right"|sed 's.\^[^(]*([^)]*)..g')
        # get width of right aligned text.. and add some space..
        #width=$($textwidth "$font" "$right_text_only    ")
        echo -n "^pa($(($panel_width - $right_width)))$right_part"
        echo

        # wait for next event
        read line || break
        cmd=( $line )
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                #echo "reseting tags" >&2
                tag_part=$(make_tag_part)
                ;;
            date)
                #echo "reseting date" >&2
                date="${cmd[@]:1}"
                ;;
            quit_panel)
                exit
                ;;
            togglehidepanel)
                currentmonidx=$(herbstclient list_monitors |grep ' \[FOCUS\]$'|cut -d: -f1)
                if [ -n "${cmd[1]}" ] && [ "${cmd[1]}" -ne "$monitor" ] ; then
                    continue
                fi
                if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                    continue
                fi
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    herbstclient pad $monitor 0
                else
                    visible=true
                    herbstclient pad $monitor $panel_height
                fi
                ;;
            reload)
                exit
                ;;
            focus_changed|window_title_changed)
                cur_winid="${cmd[@]:1}"
                all_winids=$(herbstclient layout | sed -ne '/\[FOCUS\]$/s/^.*:\(.*\)\[FOCUS\]$/\1/p')
                width=$tabbar_width
                tabbar_part=
                for i in "${all_winids[@]}"; do
                    tabbar_part=$tabbar_part$i
                done
                ;;
            conky)
                sys_status="${line#conky }"
                ;;
        esac
        done
} |
    dzen2 -w $panel_width -x $x -y $y \
          -fn "$font" -h $panel_height \
          -ta l -bg "$bgcolor" -fg '#efefef'
