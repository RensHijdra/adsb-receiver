#!/bin/bash

## INCLUDE EXTERNAL SCRIPTS

source $RECEIVER_BASH_DIRECTORY/variables.sh
source $RECEIVER_BASH_DIRECTORY/functions.sh


## BEGIN SETUP

clear
echo -e "\n\e[91m   ${RECEIVER_PROJECT_TITLE}"
echo -e ""
echo -e "\e[92m  Setting up PlaneFinder ADS-B Client..."
echo -e ""
echo -e "\e[93m  ------------------------------------------------------------------------------\e[96m"
echo -e ""

# Confirm component installation
if ! whiptail --backtitle "${RECEIVER_PROJECT_TITLE}" --title "PlaneFinder ADS-B Client Setup" --yesno "The PlaneFinder ADS-B Client is an easy and accurate way to share your ADS-B and MLAT data with Plane Finder. It comes with a beautiful user interface that helps you explore and interact with your data in realtime.\n\n  https://planefinder.net/sharing/client\n\nContinue setup by installing PlaneFinder ADS-B Client?" 13 78 3>&1 1>&2 2>&3; then
    echo -e "\e[91m  \e[5mINSTALLATION HALTED!\e[25m"
    echo -e "  Setup has been halted at the request of the user."
    echo -e ""
    echo -e "\e[93m  ------------------------------------------------------------------------------"
    echo -e "\e[92m  PlaneFinder ADS-B Client setup halted.\e[39m"
    echo -e ""
    read -p "Press enter to continue..." discard
    exit 1
fi


## CHECK FOR PREREQUISITE PACKAGES

echo -e "\e[95m  Installing packages needed to fulfill dependencies for PlaneFinder ADS-B Client...\e[97m"
echo -e ""
CheckPackage wget

# Some architectures require additional packages.
case "${CPU_ARCHITECTURE}" in
    "aarch64")
        echo -e "\e[94m  Adding support for the armhf architecture...\e[97m"
        sudo dpkg --add-architecture armhf
        CheckPackage libc6:armhf
        ;;
esac
echo ""


## DETERMINE WHICH PACACKAGE TO INSTALL

echo -e "\e[94m  Determining the package to install...\e[97m"
BASE_DOWNLOAD_URL="http://client.planefinder.net/"
case "${RECIEVER_CPU_ARCHITECTURE}" in
    "armv7l"|"armv6l")
        PACKAGE_NAME="pfclient_${PLANEFINDER_CLIENT_VERSION_ARMHF}_armhf.deb"
        ;;
    "aarch64")
        PACKAGE_NAME="pfclient_${PLANEFINDER_CLIENT_VERSION_ARM64}_armhf.deb"
        ;;
    "x86_64")
        PACKAGE_NAME="pfclient_${PLANEFINDER_CLIENT_VERSION_AMD64}_amd64.deb"
        ;;
    "i386")
        PACKAGE_NAME="pfclient_${PLANEFINDER_CLIENT_VERSION_I386}_i386.deb"
        ;;
    *)
        echo -e "\e[91m  \e[5mINSTALLATION HALTED!\e[25m"
        echo -e "  Unsupported CPU archetecture."
        echo -e ""
        echo -e "  Archetecture Detected: ${CPU_ARCHITECTURE}"
        echo -e ""
        echo -e "\e[93m  ------------------------------------------------------------------------------"
        echo -e "\e[92m  PlaneFinder ADS-B Client setup halted.\e[39m"
        echo -e ""
        read -p "Press enter to continue..." CONTINUE
        exit 1
        ;;
esac


## START INSTALLATION

echo -e ""
echo -e "\e[95m  Begining the PlaneFinder ADS-B Client installation process...\e[97m"
echo -e ""

# Create the component build directory if it does not exist
if [[ ! -d $RECEIVER_BUILD_DIRECTORY/planefinder ]]; then
    echo -e "\e[94m  Creating the PlaneFinder ADS-B Client build directory...\e[97m"
    echo ""
    mkdir -vp $RECEIVER_BUILD_DIRECTORY/planefinder
    echo ""
fi
echo -e "\e[94m  Entering the PlaneFinder ADS-B Client build directory...\e[97m"
cd $RECEIVER_BUILD_DIRECTORY/planefinder 2>&1
echo ""


## DOWNLOAD AND INSTALL THE PACKAGE

echo -e "\e[95m  Installing the PlaneFinder ADS-B Client package...\e[97m"
echo -e ""

# Download the appropriate package depending on the devices architecture
echo -e "\e[94m  Downloading the appropriate deb package...\e[97m"
echo ""
wget --no-check-certificate ${BASE_DOWNLOAD_URL}/${PACKAGE_NAME} -O $RECEIVER_BUILD_DIRECTORY/planefinder/${PACKAGE_NAME}

# Install the proper package depending on the devices architecture
echo -e "\e[94m  Installing the PlaneFinder Client...\e[97m"
echo -e ""
sudo dpkg -i $RECEIVER_BUILD_DIRECTORY/planefinder/${PACKAGE_NAME} 2>&1
echo ""

# Archive the deb package
echo -e "\e[94m  Archiving the deb package...\e[97m"
if [[ ! -d "${RECEIVER_BUILD_DIRECTORY}/package-archive" ]]; then
    echo -e "\e[94m  Creating package archive directory...\e[97m"
    echo -e ""
    mkdir -vp $RECEIVER_BUILD_DIRECTORY/package-archive 2>&1
    echo -e ""
fi
echo -e "\e[94m  Moving the PlaneFinder ADS-B Client binary package into the archive directory...\e[97m"
echo -e ""
mv -vf $RECEIVER_BUILD_DIRECTORY/planefinder/pfclient_*.deb $RECEIVER_BUILD_DIRECTORY/package-archive 2>&1
echo -e ""


## COMPONENT POST INSTALL ACTIONS

# Display final setup instructions which cannot be handled by this script
RECEIVER_IP_ADDRESS=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
whiptail --backtitle "${RECEIVER_PROJECT_TITLE}" --title "PlaneFinder ADS-B Client Setup Instructions" --msgbox "At this point the PlaneFinder ADS-B Client should be installed and running; however this script is only capable of installing the PlaneFinder ADS-B Client. There are still a few steps left which you must manually do through the PlaneFinder ADS-B Client at the following URL:\n\n  http://${RECEIVER_IP_ADDRESS}:30053\n\nThe follow the instructions supplied by the PlaneFinder ADS-B Client.\n\nUse the following settings when asked for them.\n\nData Format: Beast\nTcp Address: 127.0.0.1\nTcp Port: 30005" 20 78


## SETUP COMPLETE

# Return to the project root directory.
echo -e "\e[94m  Returning to ${RECEIVER_PROJECT_TITLE} root directory...\e[97m"
cd $RECEIVER_ROOT_DIRECTORY 2>&1

echo -e ""
echo -e "\e[93m  ------------------------------------------------------------------------------"
echo -e "\e[92m  PlaneFinder ADS-B Client setup is complete.\e[39m"
echo -e ""
read -p "Press enter to continue..." discard

exit 0
