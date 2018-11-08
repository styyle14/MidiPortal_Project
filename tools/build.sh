#!/bin/bash

THIS_SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
THIS_SCRIPT_DIR="$(dirname "$THIS_SCRIPT")"
TOOLS_DIR="$THIS_SCRIPT_DIR"
MIDIPORTAL_BASE_DIR="$(dirname "$TOOLS_DIR")"
BUILD_DIR="${MIDIPORTAL_BASE_DIR}/build"
SOURCE_CODE_DIR="${MIDIPORTAL_BASE_DIR}/source-code"
MIDIPORTAL_SOURCE_DIR="${SOURCE_CODE_DIR}/MidiPortal"
DEPENDENCIES_SOURCE_DIR="${SOURCE_CODE_DIR}/dependencies"
CABL_SOURCE_DIR="${DEPENDENCIES_SOURCE_DIR}/cabl"

# Build Midiportal-linux
build_midiportal()(
	set -x
	set -e
	if [ "$#" -lt 1 ] || [ "$#" -gt 3 ]; then
		echo "ERROR: Incorrect number of parameters."
		echo "Usage: ${0} [build-name] <cmake parameters> <make parameters>"
		return 1
	fi
	BUILD_NAME="$1"
	MIDIPORTAL_CMAKE_PARAMETERS=( $2 )
	MIDIPORTAL_MAKE_PARAMETERS=( $3 )
	(cd "$BUILD_DIR"
		#BUILD_TOOLCHAIN_DIR="$(readlink -f "./${BUILD_NAME}_toolchain")"
		#mkdir -p "$BUILD_TOOLCHAIN_DIR"
		BUILD_INSTALL_DIR="$(readlink -f "./${BUILD_NAME}_install")"
		mkdir -p "$BUILD_INSTALL_DIR"
		
		#CABL_BUILD_DIR="$(readlink -f "./${BUILD_NAME}_cabl")"
		#mkdir -p "$CABL_BUILD_DIR"
		#(cd "$CABL_BUILD_DIR"
			#cmake "${CABL_CMAKE_PARAMETERS[@]}" "$CABL_SOURCE_DIR"
			#make "${CABL_MAKE_PARAMETERS[@]}"
			#make DESTDIR="$BUILD_TOOLCHAIN_DIR" install
		#)
		
		MIDIPORTAL_BUILD_DIR="$(readlink -f "./${BUILD_NAME}_MidiPortal")"
		mkdir -p "$MIDIPORTAL_BUILD_DIR"
		(cd "$MIDIPORTAL_BUILD_DIR"
			cmake -D CMAKE_PREFIX_PATH="${BUILD_TOOLCHAIN_DIR}/usr/local" "${MIDIPORTAL_CMAKE_PARAMETERS[@]}" "$SOURCE_CODE_DIR"
			make VERBOSE=1 "${MIDIPORTAL_MAKE_PARAMETERS[@]}"
			make DESTDIR="$BUILD_INSTALL_DIR" install
		)
	)
)

build_midiportal release "" ""
