#!/bin/bash

# Layer: Core:Server

#. /usr/lib/floflis/./config
. "$FLOPREFIX"usr/lib/floflis/./config #expecting $FLOPREFIX has been successfuly imported from DNA's installer
#export FLOPREFIX
#fi
#export flofmach && export flofdistro && export flofarch && export osfullname && export osname && export osversion && export osbuild && export osbuildcodename && export updatepatch && export year && export layer && export nxtlayer && export distrobase && export user && export specialbuildattempt
# <---- load definitions & settings

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# would detect fakeroot 
#for path in ${LD_LIBRARY_PATH//:/ }; do
#   if [[ "$path" == *libfakeroot ]]
#      then
#         echo "You're using fakeroot. Floflis won't work."
#         exit
#fi
#done

is_root=false

if [ "$([[ $UID -eq 0 ]] || echo "Not root")" = "Not root" ]
   then
      is_root=false
   else
      is_root=true
fi

$maysudo=""

if [ "$is_root" = "false" ]
   then
      $maysudo="sudo"
   else
      $maysudo=""
fi

cat << "EOF"
-. .-.   .-. .-.   .-. .-.   .
  \   \ /   \   \ /   \   \ /
 / \   \   / \   \   / \   \
~   `-~ `-`   `-~ `-`   `-~ `-
  _            _           
 |_  |   _   _|_  |  o   _ 
 |   |  (_)   |   |  |  _> 
                           
  ___               _            _   _             
 |_ _|  _ _    ___ | |_   __ _  | | | |  ___   _ _ 
  | |  | ' \  (_-< |  _| / _` | | | | | / -_) | '_|
 |___| |_||_| /__/  \__| \__,_| |_| |_| \___| |_|  

                  for Floflis Server
EOF
echo "- Detecting if Floflis Core is installed..."
if [ -e /usr/lib/floflis/layers/core ]
then
echo "- Installing Floflis Server as init program..."
$maysudo echo "$(cat /usr/lib/floflis/layers/server/flo-init)" >> /etc/init.d/flo-init && $maysudo rm -f /usr/lib/floflis/layers/server/flo-init
$maysudo chmod 755 /etc/init.d/flo-init && $maysudo update-rc.d flo-init defaults

   echo "- Installing programs..."
   $maysudo apt-get install ufw openssl certbot python-certbot-nginx nginx php php-fpm php-mysql phpmyadmin ftp ssh mysql-server sqlite
# ufw firewall maybe will be used in other layers if it doesnt conflicts

   echo "- Cleanning install, saving settings..."
   $maysudo rm /usr/lib/floflis/layers/server/install.sh
   $maysudo sed -i 's/soil//g' /usr/lib/floflis/config && $maysudo sed -i 's/core/server/g' /usr/lib/floflis/config
   . /usr/lib/floflis/./config
   contents="$(jq ".layer = \"$layer\"" /1/Floflis/system/os.json)" && \
   echo "${contents}" > /1/Floflis/system/os.json
   contents="$(jq ".nxtlayer = \"$nxtlayer\"" /1/Floflis/system/os.json)" && \
   echo "${contents}" > /1/Floflis/system/os.json
   echo "(✓) Floflis Core: POWERUP with Floflis Server!"
else
   echo "(X) Floflis Core isn't found. Please install Floflis DNA before installing Floflis Server."
   echo ""
   echo "Floflis DNA at IPFS:"
   echo "Normal version: https://gateway.pinata.cloud/ipfs/QmdweQW6FUjvMHCKSz5h7WpMifgzFvh2SFm9T4hiZ6rY4h"
   echo "Lite version: https://gateway.pinata.cloud/ipfs/QmXSiq2atUQeisoiV3PDisNP4LecBCNLv6p6nymvn6JyRL"
fi
