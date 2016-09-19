#!/bin/bash

#
# Monero Simplewallet Launcher, (c) 2016 bigreddmachine.
# https://github.com/Monero-Monitor/monero-wallet-chrome
#
# This script allows simplewallet to be run in rpc mode easily and quickly. User passwords
# are secured by passing them as a terminal input, rather than requiring them to be stored
# as clear text in the script.
#
# This script is released under the MIT License.
#

clear

echo "===================================================================================="
echo "                       Monero Simplewallet Launcher for Linux"
echo ""
echo "Copyright (c) 2016 bigreddmachine."
echo "Released under the MIT License as part of Monero Wallet for Chrome."
echo "https://github.com/monero-monitor/monero-wallet-chrome"
echo "===================================================================================="
echo ""

mkdir -p ~/.MoneroWalletChrome

sleep 1

cd ~/.MoneroWalletChrome
FILE="wallet.bin"

echo "Which Monero daemon would you like to connect to?"
echo "  1. remote (node.moneroclub.com:8880)"
echo "  2. local  (127.0.0.1:18081)"
echo "  3. custom"
echo ""
read -p "Please make a selection: " DAEMON

if [ $DAEMON -ne 1 ] && [ $DAEMON -ne 2 ] && [ $DAEMON -ne 3 ]; then
    read -p "Invalid daemon selection. Press enter to quit."
    exit
fi

if [ $DAEMON -eq 3 ]; then
    echo "Please enter custom daemon in quotes (example: \"192.168.0.1:18081\"):"
    read CUSTOM_DAEMON
fi

echo ""
echo "----------------------"
echo ""

if [ -f "$FILE" ]; then
    # If this script has been run previously, a wallet should already exist. Start it in RPC mode.
    echo "  Launching simplewallet in RPC mode, listening on localhost (127.0.0.1), port 18082."
    echo ""
    echo "  Please enter your password: "
    read -s PASS

    echo ""
    echo "  Choose a 'User Agent'. You can use a new User Agent each time you use your wallet."
    echo "  Please enter a User Agent: "
    read -s USER

    echo ""
    echo "  Launching simplewallet..."
    echo ""

    if [ $DAEMON -eq 1 ]; then
        screen -S SimpleWalletRPC -d -m ~/MoneroWallet/simplewallet --wallet-file $FILE --password $PASS --user-agent $USER --rpc-bind-ip 127.0.0.1 --rpc-bind-port 18082 --daemon-address node.moneroclub.com:8880
    elif [$DAEMON -eq 2 ]; then
        screen -S SimpleWalletRPC -d -m ~/MoneroWallet/simplewallet --wallet-file $FILE --password $PASS --user-agent $USER --rpc-bind-ip 127.0.0.1 --rpc-bind-port 18082
    else
        screen -S SimpleWalletRPC -d -m ~/MoneroWallet/simplewallet --wallet-file $FILE --password $PASS --user-agent $USER --rpc-bind-ip 127.0.0.1 --rpc-bind-port 18082 --daemon-address $CUSTOM_DAEMON
    fi

    sleep 1
    echo "----------------------"

    echo ""
    echo "  Simplewallet should now running in RPC mode. If you have trouble logging into the extension, you may have typed the wrong password or wrong User Agent."
    echo ""
    echo "  When you access your wallet in the extension, your 'User Agent' acts as your login credentials. You can change a new User Agent each time your open your wallet."
    echo ""
    echo "  To shutdown simplewallet, choose 'Stop Wallet' in the extension's menu."
    echo ""
    read -p "  Thank you for using Monero Wallet for Chrome! Press 'enter' to close this dialog. Simplewallet will continue running in the background."


else
    # The first time this script is run, open the command line wallet.
    echo "  You have not created a wallet yet. This script will help you do that."
    echo ""
    echo "  To create a wallet, follow the prompts. Enter a password, then pick a"
    echo "  language for your wallet."
    echo ""
    echo "  Once you have created a wallet, simplewallet will open and a prompt"
    echo "  line will appear. Type 'refresh', then once it is done type 'exit'."
    echo "  You are then ready to use Monero Wallet for Chrome."
    echo ""
    read -p "  When you are ready to begin, press enter... "

    echo ""
    echo "----------"
    echo "  Please pick a password for your new wallet: "
    read -s NEWPASS
    echo ""
    echo "  Confirm password: "
    read -s CONFIRM_NEWPASS
    echo ""

    if [ "$NEWPASS" != "$CONFIRM_NEWPASS" ]; then
        echo "  Your passwords do not match. Please restart the script and try again."
        echo ""
        read -p "  Press 'enter' to exit."
        exit
    fi

    echo "----------"
    echo ""

    if [ $DAEMON -eq 1 ]; then
        ~/MoneroWallet/simplewallet --generate-new-wallet $FILE --password $NEWPASS --daemon-address node.moneroclub.com:8880
    elif [ $DAEMON -eq 2 ]; then
        ~/MoneroWallet/simplewallet --generate-new-wallet $FILE --password $NEWPASS
    else
        ~/MoneroWallet/simplewallet --generate-new-wallet $FILE --password $NEWPASS --daemon-address $CUSTOM_DAEMON
    fi

    echo ""
    echo "----------"
    echo ""

    if [ -e "$FILE" ]; then
        echo "  Everything looks good. You can now start your wallet in RPC mode at any time by re-running this script."
        echo ""
        read -p "  Press 'enter' to close Monero Simplewallet Launcher."
    else
        read -p "  There seems to have been an issue creating your wallet. Press 'enter' to close this dialog."
    fi
fi

echo ""
