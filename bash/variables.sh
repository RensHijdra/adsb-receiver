#!/bin/bash

#####################################################################################
#                                  ADS-B RECEIVER                                   #
#####################################################################################
#                                                                                   #
# This script is not meant to be executed directly.                                 #
# Instead execute install.sh to begin the installation process.                     #
#                                                                                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                   #
# Copyright (c) 2015-2024, Joseph A. Prochazka                                      #
#                                                                                   #
# Permission is hereby granted, free of charge, to any person obtaining a copy      #
# of this software and associated documentation files (the "Software"), to deal     #
# in the Software without restriction, including without limitation the rights      #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell         #
# copies of the Software, and to permit persons to whom the Software is             #
# furnished to do so, subject to the following conditions:                          #
#                                                                                   #
# The above copyright notice and this permission notice shall be included in all    #
# copies or substantial portions of the Software.                                   #
#                                                                                   #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR        #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,          #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE       #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER            #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,     #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     #
# SOFTWARE.                                                                         #
#                                                                                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

## SOFTWARE VERSIONS

# The ADS-B Receiver Project
PROJECT_VERSION="2.8.3"

# FlightAware
DUMP1090_FA_VERSION="9.0"
DUMP978_FA_VERSION="9.0"
PIAWARE_VERSION="9.0.1"
SKYAWARE978_VERSION="9.0"

# PlaneFinder Client
PLANEFINDER_CLIENT_VERSION_ARMHF="5.0.161"
PLANEFINDER_CLIENT_VERSION_ARM64="5.1.440"
PLANEFINDER_CLIENT_VERSION_AMD64="5.0.162"
PLANEFINDER_CLIENT_VERSION_I386="5.0.161"

# Flightradar24 Client
FLIGHTRADAR24_CLIENT_VERSION="1.0.18-5"

# OpenSky Network Client
OPENSKY_NETWORK_CLIENT_VERSION="2.1.7-1"
