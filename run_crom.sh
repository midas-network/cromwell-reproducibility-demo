#!/bin/bash

echo ""
echo "********************************************************"
echo "*            MIDAS Cromwell / SEIRSPLUS Demo           *"
echo "*                                                      *"
echo "* This script demonstrates the execution of the        *"
echo "* SEIRSPLUS disease model (a Python library) using     *"
echo "* a WDL file run via the Cromwell workflow engine.     *"
echo "*                                                      *"
echo "* Cromwell: https://github.com/broadinstitute/cromwell *"
echo "* SEIRSPLUS: https://github.com/ryansmcgee/seirsplus   *"
echo "*                                                      *"
echo "* author: John Levander, jdl50@pitt.edu                *"
echo "********************************************************"
echo ""

if ! command -v conda &> /dev/null
then
    echo "Error: conda command not found"
    echo "This script requires Anaconda or Miniconda to be installed."
    exit 1
fi

checksum="faf6e7996e1c2e9e4e71f2256f984e3a7782df9377fd2ccd32546f622d05cb2b  cromwell-84.jar"
echo "Looking for cromwell-84.jar..."
if [[ -f "cromwell-84.jar" ]]; then
  echo "  cromwell-84.jar found."
else
  echo "  cromwell-84.jar not found..."
  if which wget >/dev/null; then
    echo "  Downloading cromwell-84.jar via wget."
    wget -q --show-progress https://github.com/broadinstitute/cromwell/releases/download/84/cromwell-84.jar
 else
    echo "  Error: Cannot download cromwell-84.jar, wget is not available."
    echo "    Please install wget or download the following file to this directory:"
    echo "      https://github.com/broadinstitute/cromwell/releases/download/84/cromwell-84.jar "
    echo "    Rerun this script once you've either installed wget or downloaded cromwell-84.jar"
    exit 1
  fi
fi

echo "Verifying cromwell-84.jar..."
if [[ $(shasum -a 256 cromwell-84.jar) = $checksum ]]; then
  echo "  cromwell-84.jar verified!";
else
  echo "  Error: Couldn't verify cromwell-84.jar, please delete the .jar and run this script again."
  exit 1
fi
echo ""
echo ""
echo "Creating new seirs-conda environment."
conda env create --force -f environment.yml
echo ""
eval "$(conda shell.bash hook)"
echo "Activating seirs-conda environment."
conda activate seirs-conda
echo ""
echo "Running cromwell."
java -jar cromwell-84.jar run myWorkflow.wdl -i inputs.json
conda deactivate
