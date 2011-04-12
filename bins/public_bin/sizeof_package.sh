#!/bin/bash
dpkg-query --show --showformat='${Installed-Size}\t${Package}\n' $@
