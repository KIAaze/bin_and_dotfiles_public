#!/bin/bash
sudo ufw enable

sudo ufw default reject outgoing

sudo ufw reject out 80
sudo ufw reject out 443
sudo ufw reject out 53

sudo ufw allow out 9001
sudo ufw allow out 9030
