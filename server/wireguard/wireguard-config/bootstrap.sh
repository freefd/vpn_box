#!/usr/bin/env sh

if [ -f /etc/wireguard/configurations/server.conf ]; then
   ServerComment=$(sed '1!d' /etc/wireguard/configurations/server.conf)
   ServerPrivateKey=$(sed '2!d' /etc/wireguard/configurations/server.conf)
   ServerAddress=$(sed '3!d' /etc/wireguard/configurations/server.conf)
   sed -e "s#__ServerComment__#$ServerComment#g" \
       -e "s#__ServerPrivateKey__#$ServerPrivateKey#g" \
       -e "s#__ServerAddress__#$ServerAddress#g" /etc/wireguard/templates/server.wg0.conf > /tmp/wg0.conf

   for peer in $(ls /etc/wireguard/configurations/peer*.conf); do
     PeerComment=$(sed '1!d' $peer)
     PeerPublicKey=$(sed '2!d' $peer)
     PeerAllowedIPs=$(sed '3!d' $peer)
     sed -e "s#__PeerComment__#$PeerComment#g" \
         -e "s#__PeerPublicKey__#$PeerPublicKey#g" \
         -e "s#__PeerAllowedIPs__#$PeerAllowedIPs#g" /etc/wireguard/templates/peer.wg0.conf >> /tmp/wg0.conf
   done
   sleep 3
   wg-quick up /tmp/wg0.conf
else
   echo "Cannot find server.conf. Exiting"
fi
