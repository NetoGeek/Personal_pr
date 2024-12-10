#!/bin/bash

ICON_PATH="/path/to/your/icon.png"  # Update this to the path of your icon file

display_menu() {
    zenity --list --title="Basic Monitoring Tool for Admins" --column="Option" --column="Description" --width=800 --height=800 \
        --window-icon="$ICON_PATH" \
        1 "UPTIME" \
        2 "Scheduled jobs" \
        3 "Download & Upload" \
        4 "Logged in Users" \
        5 "Update system" \
        6 "History" \
        7 "Quit connected users without root" \
        8 "Create a job" \
        9 "Put other users' processes in Sleep mode" \
        10 "PING TEST" \
        11 "Devices on the Network" \
        12 "Network Performance" \
        13 "ARP Table" \
        14 "System Logs" \
        15 "Network Changes" \
        16 "Open Ports" \
        17 "Network Traffic" \
        18 "Firewall Rules" \
        19 "IP Address Lookup" \
        20 "Exit"
}

while true; do
    choice=$(display_menu)
    echo -e "\n"
    case $choice in
    1)
        var=$(uptime)
        zenity --info --title="System Uptime" --text="$var" --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    2)
        v2=$(crontab -l)
        zenity --info --title="Scheduled Jobs" --text="$v2" --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    3)
        v3=$(speedtest-cli | grep -e "Download" -e "Upload")
        zenity --info --title="Download & Upload Speed" --text="$v3" --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    4)
        v4=$(w)
        zenity --info --title="Logged in Users" --text="$v4" --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    5)
        sudo apt update | zenity --progress --title="Updating System" --text="Updating..." --percentage=0 --auto-close --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    6)
        v6=$(history | sort -r | head -20)
        zenity --info --title="Command History" --text="$v6" --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    7)
        pkill -u $(who | awk '{print $1}' | grep -v '^root$' | sort -u)
        zenity --info --title="Users Disconnected" --text="Non-root users have been logged out." --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    8)
        crontab -e
        ;;
    9)
         pids=$(pgrep -u $(who | awk '{print $1}' | grep -v '^root$' | sort -u))
         if [ -n "$pids" ]; then
           sudo kill -STOP $pids
           zenity --info --title="Sleep Mode" --text="Other users' processes have been put into Sleep mode." --width=400 --height=200 --window-icon="$ICON_PATH"
         else
           zenity --info --title="Sleep Mode" --text="No processes to put into Sleep mode." --width=400 --height=200 --window-icon="$ICON_PATH"
         fi
         ;;
    10)
        target=8.8.8.8
        v10=$(ping -c 5 $target)
        if [ $? -eq 0 ]; then
            zenity --info --title="Ping Result" --text="HOST IS UP" --width=400 --height=200 --window-icon="$ICON_PATH"
        else
            zenity --info --title="Ping Result" --text="HOST is down at:\n$(date)" --width=400 --height=200 --window-icon="$ICON_PATH"
            echo "$(date)" >> pingtrack.txt
        fi
        ;;
    11)
        v11=$(sudo arp-scan --interface=eth0 --localnet)
        zenity --info --title="Devices on the Network" --text="$v11" --width=800 --height=600 --window-icon="$ICON_PATH"
        ;;
    12)
        v12=$(sudo vnstat)
        zenity --info --title="Network Performance" --text="$v12" --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    13)
        v13=$(arp -a)
        zenity --info --title="ARP Table" --text="$v13" --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    14)
        v14=$(journalctl -xe)
        zenity --info --title="System Logs" --text="$v14" --width=800 --height=600 --window-icon="$ICON_PATH"
        ;;
    15)
        v15=$(sudo nmap -sP $(hostname -I | awk '{print $1"/24"}'))
        zenity --info --title="Network Changes" --text="$v15" --width=800 --height=600 --window-icon="$ICON_PATH"
        ;;
    16)
        v16=$(ss -tuln | grep LISTEN)
        zenity --info --title="Open Ports" --text="$v16" --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    17)
        sudo tcpdump -i eth0 -nn -c 100 | zenity --text-info --title="Network Traffic" --width=800 --height=600 --window-icon="$ICON_PATH"
        ;;
    18)
        v18=$(iptables -L)
        zenity --info --title="Firewall Rules" --text="$v18" --width=600 --height=300 --window-icon="$ICON_PATH"
        ;;
    19)
        ipaddr=$(zenity --entry --title="IP Address Lookup" --text="Enter the IP address:" --window-icon="$ICON_PATH")
        if [ -n "$ipaddr" ]; then
            v19=$(whois "$ipaddr")
            zenity --info --title="IP Address Lookup" --text="$v19" --width=800 --height=600 --window-icon="$ICON_PATH"
        else
            zenity --error --title="Error" --text="No IP address entered." --width=400 --height=200 --window-icon="$ICON_PATH"
        fi
        ;;
    20)
        exit
        ;;
    *)
        zenity --error --title="Error" --text="Invalid option selected" --width=400 --height=200 --window-icon="$ICON_PATH"
        ;;
    esac
done
