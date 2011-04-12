#!/bin/bash
set -eux

cmake -DBUILD_SHARED_LIBS:BOOL=ON -DVTK_USE_GUISUPPORT:BOOL=ON -DVTK_USE_QVTK:BOOL=ON -DDESIRED_QT_VERSION:STRING=4  .
chmod 644 Utilities/vtktiff/tif_fax3sm.c
make -j4 && sudo make install
echo SUCCESS

