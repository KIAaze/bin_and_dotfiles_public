#!/bin/bash
sudo ufw enable

sudo ufw default allow outgoing

sudo ufw delete reject out 80
sudo ufw delete reject out 443
sudo ufw delete reject out 53

sudo ufw delete allow out 9001
sudo ufw delete allow out 9030
