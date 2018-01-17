#!/system/bin/sh
# Copyright (c) 2009-2015, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# Only Oxygen P3C board us aw2013 to drive button-backlight.
# And it need set different brightness with different panel color
OXYGEN_P3C='0x180'

if [ -f /sys/bootinfo/hw_version ]; then
    hw_version=`cat /sys/bootinfo/hw_version`
else
    hw_version=0
fi

if [ $hw_version != $OXYGEN_P3C ]; then
    # LED full scale current is 8mA and limit it to 5mA
    echo 5 > /sys/class/leds/button-backlight/max_brightness
else
    if [ -f /sys/bus/i2c/devices/3-0038/panel_color ]; then
        color=`cat /sys/bus/i2c/devices/3-0038/panel_color`
    elif [ -f /sys/bus/i2c/devices/3-0020/panel_color ]; then
        color=`cat /sys/bus/i2c/devices/3-0020/panel_color`
    else
        color="0"
    fi

    # Update the panel color property and Leds brightness
    case "$color" in
        "1")
            setprop sys.panel.color WHITE
	    echo 180 > /sys/class/leds/button-backlight/max_brightness
            ;;
        "2")
            setprop sys.panel.color BLACK
            echo 255 > /sys/class/leds/button-backlight/max_brightness
            ;;
        *)
            setprop sys.panel.color UNKNOWN
            echo 255 > /sys/class/leds/button-backlight/max_brightness
            ;;
    esac
fi
