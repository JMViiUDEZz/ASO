#!/bin/bash

color() {
    case $1 in
        bold)
            echo -e "\e[0;1m$2 \e[0m"
        ;;
        dim)
            echo -e "\e[0;2m$2 \e[0m"
        ;;
        underlined)
            echo -e "\e[0;4m$2 \e[0m"
        ;;
        blink)
            echo -e "\e[0;5m$2 \e[0m"
        ;;
        hidden)
            echo -e "\e[0;8m$2 \e[0m"
        ;;
        red)
            echo -e "\e[0;31m$2 \e[0m"
        ;;
        green)
            echo -e "\e[0;32m$2 \e[0m"
        ;;
        yellow)
            echo -e "\e[0;33m$2 \e[0m"
        ;;
        blue)
            echo -e "\e[0;34m$2 \e[0m"
        ;;
        magenta)
            echo -e "\e[0;35m$2 \e[0m"
        ;;
        cyan)
            echo -e "\e[0;36m$2 \e[0m"
        ;;
        *)
            echo -e "$2"
        ;;
    esac
}

color "$2" "$1"