#!/bin/bash

## INCLUDE EXTERNAL SCRIPTS

source $RECEIVER_BASH_DIRECTORY/variables.sh
source $RECEIVER_BASH_DIRECTORY/functions.sh


## BEGIN SETUP

clear
echo -e "\n\e[91m   ${RECEIVER_PROJECT_TITLE}"
echo ""
echo -e "\e[92m  Setting up FlightAware PiAware client..."
echo ""
echo -e "\e[93m  ------------------------------------------------------------------------------\e[96m"
echo ""

# Confirm component installation
if ! whiptail --backtitle "${RECEIVER_PROJECT_TITLE}" --title "FlightAware PiAware client Setup" --yesno "The FlightAware PiAware client takes data from a local dump1090 instance and shares this with FlightAware using the piaware package, for more information please see their website:\n\n  https://www.flightaware.com/adsb/piaware/\n\nContinue setup by installing the FlightAware PiAware client?" 13 78 3>&1 1>&2 2>&3; then
    echo -e "\e[91m  \e[5mINSTALLATION HALTED!\e[25m"
    echo -e "  Setup has been halted at the request of the user."
    echo ""
    echo -e "\e[93m  ------------------------------------------------------------------------------"
    echo -e "\e[92m  FlightAware PiAware client setup halted.\e[39m"
    echo ""
    read -p "Press enter to continue..." discard
    exit 1
fi


## CHECK FOR PREREQUISITE PACKAGES

echo -e "\e[95m  Installing packages needed to fulfill dependencies for FlightAware PiAware client...\e[97m"
echo ""
CheckPackage build-essential
CheckPackage git
CheckPackage devscripts
CheckPackage debhelper
CheckPackage tcl8.6-dev
CheckPackage autoconf
CheckPackage python3-dev
CheckPackage python3-venv
CheckPackage python3-setuptools
CheckPackage zlib1g-dev
CheckPackage openssl
CheckPackage libboost-system-dev
CheckPackage libboost-program-options-dev
CheckPackage libboost-regex-dev
CheckPackage libboost-filesystem-dev
CheckPackage patchelf
CheckPackage python3-pip
CheckPackage python3-setuptools
CheckPackage python3-wheel
CheckPackage net-tools
CheckPackage tclx8.4
CheckPackage tcllib
CheckPackage itcl3
CheckPackage libssl-dev
CheckPackage tcl-dev
CheckPackage chrpath

# Some older distros may need different packages than newer ones
case ${RECEIVER_OS_CODE_NAME} in
    focal)
        CheckPackage python3-dev
        ;;
    *)
        CheckPackage python3-build
        ;;
esac

echo ""


## DOWNLOAD OR UPDATE THE TCLTLS REBUILD SOURCE

echo -e "\e[95m  Preparing the tcltls rebuild Git repository...\e[97m"
echo ""
# Build the FlightAware version of tcl-tls to address network issues with the stock package
if [[ -d $RECEIVER_BUILD_DIRECTORY/tcltls-rebuild && -d $RECEIVER_BUILD_DIRECTORY/tcltls-rebuild/.git ]]; then
    # A directory with a git repository containing the source code already exists
    echo -e "\e[94m  Entering the tcltls-rebuild git repository directory...\e[97m"
    cd $RECEIVER_BUILD_DIRECTORY/tcltls-rebuild 2>&1
    echo -e "\e[94m  Updating the local tcltls-rebuild git repository...\e[97m"
    echo ""
    git pull 2>&1
else
    # A directory containing the source code does not exist in the build directory
    echo -e "\e[94m  Entering the ADS-B Receiver Project build directory...\e[97m"
    cd $RECEIVER_BUILD_DIRECTORY 2>&1
    echo -e "\e[94m  Cloning the tcltls-rebuild git repository locally...\e[97m"
    echo ""
    git clone https://github.com/flightaware/tcltls-rebuild 2>&1
fi
echo ""


## BUILD AND INSTALL THE DUMP1090-FA PACKAGE

echo -e "\e[95m  Building and installing the tcltls rebuild package...\e[97m"
echo -e ""

echo -e "\e[94m  Entering the tcltls-rebuild source directory...\e[97m"
cd $RECEIVER_BUILD_DIRECTORY/tcltls-rebuild/tcltls-1.7.22 2>&1
echo -e "\e[94m  Building the tcltls-rebuild package...\e[97m"
echo ""
dpkg-buildpackage -b 2>&1
echo ""
echo -e "\e[94m  Installing the tcltls-rebuild package...\e[97m"
echo ""
sudo dpkg -i $RECEIVER_BUILD_DIRECTORY/tcltls-rebuild/tcl-tls_1.7.22-2+fa1_*.deb 2>&1
echo ""
echo -e "\e[94m  Moving the tcltls-rebuild binary package into the archive directory...\e[97m"
echo ""
cp -vf $RECEIVER_BUILD_DIRECTORY/piaware_builder/*.deb $RECEIVER_BUILD_DIRECTORY/package-archive/ 2>&1
echo ""


## START INSTALLATION

echo -e "\e[95m  Begining the FlightAware PiAware client installation process...\e[97m"
echo ""

if [[ -d $RECEIVER_BUILD_DIRECTORY/piaware_builder && -d $RECEIVER_BUILD_DIRECTORY/piaware_builder/.git ]]; then
    # A directory with a git repository containing the source code already exists
    echo -e "\e[94m  Entering the piaware_builder git repository directory...\e[97m"
    cd $RECEIVER_BUILD_DIRECTORY/piaware_builder 2>&1
    echo -e "\e[94m  Updating the local piaware_builder git repository...\e[97m"
    echo ""
    git pull 2>&1
else
    # A directory containing the source code does not exist in the build directory
    echo -e "\e[94m  Entering the ADS-B Receiver Project build directory...\e[97m"
    cd $RECEIVER_BUILD_DIRECTORY 2>&1
    echo -e "\e[94m  Cloning the piaware_builder git repository locally...\e[97m"
    echo ""
    git clone https://github.com/flightaware/piaware_builder.git 2>&1
fi
echo ""


## BUILD AND INSTALL THE COMPONENT PACKAGE

echo -e "\e[95m  Building and installing the FlightAware PiAware client package...\e[97m"
echo ""

# Change to the component build directory
echo -e "\e[94m  Entering the piaware_builder git repository directory...\e[97m"
cd $RECEIVER_BUILD_DIRECTORY/piaware_builder 2>&1

# Execute build script
distro="bookworm"
case $RECEIVER_OS_CODE_NAME in
    buster | focal)
        distro="buster"
        ;;
    bullseye | jammy)
        distro="bullseye"
        ;;
    bookworm)
        distro="bookworm"
        ;;
esac
echo -e "\e[94m  Executing the FlightAware PiAware client build script...\e[97m"
echo ""
./sensible-build.sh $distro
echo ""

# Change to build script directory
echo -e "\e[94m  Entering the FlightAware PiAware client build directory...\e[97m"
cd $RECEIVER_BUILD_DIRECTORY/piaware_builder/package-${distro} 2>&1

# Build binary package
echo -e "\e[94m  Building the FlightAware PiAware client package...\e[97m"
echo ""
dpkg-buildpackage -b 2>&1
echo ""

# Install binary package
echo -e "\e[94m  Installing the FlightAware PiAware client package...\e[97m"
echo ""
sudo dpkg -i $RECEIVER_BUILD_DIRECTORY/piaware_builder/piaware_*.deb 2>&1
echo ""

# Check that the component package was installed successfully.
echo -e "\e[94m  Checking that the FlightAware PiAware client package was installed properly...\e[97m"

if [[ $(dpkg-query -W -f='${STATUS}' piaware 2>/dev/null | grep -c "ok installed") -eq 0 ]]; then
    echo ""
    echo -e "\e[91m  \e[5mINSTALLATION HALTED!\e[25m"
    echo -e "  UNABLE TO INSTALL A REQUIRED PACKAGE."
    echo -e "  SETUP HAS BEEN TERMINATED!"
    echo ""
    echo -e "\e[93mThe package \"piaware\" could not be installed.\e[39m"
    echo ""
    echo -e "\e[93m  ------------------------------------------------------------------------------"
    echo -e "\e[92m  FlightAware PiAware client setup halted.\e[39m"
    echo ""
    read -p "Press enter to continue..." discard
    exit 1
else
    # Create binary package archive directory.
    if [[ ! -d $RECEIVER_BUILD_DIRECTORY/package-archive ]]; then
        echo -e "\e[94m  Creating package archive directory...\e[97m"
        echo ""
        mkdir -vp $RECEIVER_BUILD_DIRECTORY/package-archive 2>&1
        echo ""
    fi

    # Archive binary package.
    echo -e "\e[94m  Moving the FlightAware PiAware client binary package into the archive directory...\e[97m"
    echo ""
    cp -vf $RECEIVER_BUILD_DIRECTORY/piaware_builder/*.deb $RECEIVER_BUILD_DIRECTORY/package-archive/ 2>&1
    echo ""
fi


## COMPONENT POST INSTALL ACTIONS

# Instruct the user as to how they can claim their receiver online.
whiptail --backtitle "${RECEIVER_PROJECT_TITLE}" --title "Claiming Your PiAware Device" --msgbox "FlightAware requires you claim your feeder online using the following URL:\n\n  http://flightaware.com/adsb/piaware/claim\n\nTo claim your device simply visit the address listed above." 12 78


## SETUP COMPLETE

# Return to the project root directory.
echo -e "\e[94m  Returning to ${RECEIVER_PROJECT_TITLE} root directory...\e[97m"
cd $RECEIVER_ROOT_DIRECTORY 2>&1

echo ""
echo -e "\e[93m  ------------------------------------------------------------------------------"
echo -e "\e[92m  FlightAware PiAware client setup is complete.\e[39m"
echo ""
read -p "Press enter to continue..." discard

exit 0
