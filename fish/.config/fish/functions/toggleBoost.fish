function toggleBoost
    set current (cat /sys/devices/system/cpu/cpufreq/boost)
    if test "$current" = 1
        echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost >/dev/null
        set_color green
        echo "Turbo Boost DISABLED (Cooling Mode - Play Dark Souls 3)"
        set_color normal
    else
        echo 1 | sudo tee /sys/devices/system/cpu/cpufreq/boost >/dev/null
        set_color red
        echo "Turbo Boost ENABLED (Performance Mode - Play Minecraft)"
        set_color normal
    end
end
