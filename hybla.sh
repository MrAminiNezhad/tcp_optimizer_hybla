#!/bin/bash
#
# Auto install latest kernel for TCP Hybla
#
# System Required:  CentOS 6+, Debian8+, Ubuntu16+
#
# Copyright (C) 2023 Mr.Amini Nezhad
#
# my Github: https://github.com/MrAminiNezhad/


display_menu() {
    if [ $EUID -ne 0 ]; then
        _error "This script must be run as root"
    fi
    opsy=$(_os_full)
    arch=$(uname -m)
    lbit=$(getconf LONG_BIT)
    kern=$(uname -r)

    clear
    echo "---------- System Information ----------"
    echo " OS      : $opsy"
    echo " Arch    : $arch ($lbit Bit)"
    echo " Kernel  : $kern"
    echo "----------------------------------------"
    echo "Automatically enable TCP Hybla script"
    echo
    echo "Coded By: https://github.com/MrAminiNezhad/"
    echo "----------------------------------------"
    echo "Press any key to start...or Press Ctrl+C to cancel"
    read -s -n 1 key
}


_os_full() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

# Function to check the system
check_sys() {
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -q -E -i "debian"; then
        release="debian"
    elif cat /etc/issue | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -q -E -i "debian"; then
        release="debian"
    elif cat /proc/version | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    fi
}

# Function to check the system version and bit
check_version() {
    if [[ -s /etc/redhat-release ]]; then
        version=$(grep -oE "[0-9.]+" /etc/redhat-release | cut -d . -f 1)
    else
        version=$(grep -oE "[0-9.]+" /etc/issue | cut -d . -f 1)
    fi
    bit=$(uname -m)
    if [[ ${bit} == "x86_64" ]]; then
        bit="x64"
    else
        bit="x32"
    fi
}

install_Hybla() {
    kernel_version="6.5.7"
    if [[ "${release}" == "centos" ]]; then
        if [[ "${version}" == "6" && "${bit}" == "x32" ]]; then
            rpm --import https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/RPM-GPG-KEY-elrepo.org
            yum install -y https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/6/x32/kernel-ml-4.11.8.rpm
            yum remove -y kernel-headers
            yum install -y https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/6/x32/kernel-ml-devel-4.11.8.rpm
            yum install -y https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/6/x32/kernel-ml-headers-4.11.8.rpm
        elif [[ "${version}" == "6" && "${bit}" == "x64" ]]; then
            rpm --import https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/RPM-GPG-KEY-elrepo.org
            yum install -y https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/6/x64/kernel-ml-4.11.8.rpm
            yum remove -y kernel-headers
            yum install -y https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/6/x64/kernel-ml-devel-4.11.8.rpm
            yum install -y https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/6/x64/kernel-ml-headers-4.11.8.rpm
        elif [[ "${version}" == "7" && "${bit}" == "x64" ]]; then
            rpm --import https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/RPM-GPG-KEY-elrepo.org
            yum install -y https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/7/x64/kernel-ml-4.11.8.rpm
            yum remove -y kernel-headers
            yum install -y https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/7/x64/kernel-ml-devel-4.11.8.rpm
            yum install -y https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/centos/7/x64/kernel-ml-headers-4.11.8.rpm
        else
            _error "This version is not supported"
        fi
    elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
        mkdir Hybla && cd Hybla
        wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl3_3.0.11-1~deb12u2_amd64.deb
        if [[ "${bit}" == "x64" ]]; then
		    wget -N --no-check-certificate https://kernel.ubuntu.com/mainline/v6.5.7/amd64/linux-headers-6.5.7-060507_6.5.7-060507.202310102154_all.deb
            wget -N --no-check-certificate https://kernel.ubuntu.com/mainline/v6.5.7/amd64/linux-headers-6.5.7-060507-generic_6.5.7-060507.202310102154_amd64.deb
            wget -N --no-check-certificate https://kernel.ubuntu.com/mainline/v6.5.7/amd64/linux-modules-6.5.7-060507-generic_6.5.7-060507.202310102154_amd64.deb
			dpkg -i linux-headers-6.5.7-060507_6.5.7-060507.202310102154_all.deb
			dpkg -i linux-headers-6.5.7-060507-generic_6.5.7-060507.202310102154_amd64.deb
			dpkg -i linux-modules-6.5.7-060507-generic_6.5.7-060507.202310102154_amd64.deb
		else
		    wget -N --no-check-certificate https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/debian-ubuntu/x32/linux-headers-4.11.8-all.deb
            wget -N --no-check-certificate https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/debian-ubuntu/x32/linux-headers-4.11.8.deb
            wget -N --no-check-certificate https://raw.githubusercontent.com/MrAminiNezhad/tcp_optimizer_hybla/main/hybla/debian-ubuntu/x32/linux-image-4.11.8.deb
		    dpkg -i linux-headers-4.11.8-all.deb
			dpkg -i linux-headers-4.11.8.deb
			dpkg -i linux-image-4.11.8.deb
		fi
        dpkg -i libssl3_3.0.11-1~deb12u2_amd64.deb
        cd .. && rm -rf Hybla
    fi

	clear
	echo "The kernel version is greater than 6.5.7, directly setting TCP Hybla..."
	echo "Setting TCP Hybla completed"
	echo "TCP Hybla has been successfully installed and configured."
	echo "enjoy it..."
    read -p "It is recommended to reboot the server for better performance (recommended). Do you want to restart now? [Y/n] :" yn
    [ -z "${yn}" ] && yn="y"
    if [[ $yn == [Yy] ]]; then
        echo -e "good choice ,VPS is rebooting..."
        reboot
    fi
}
sysctl_config() {
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = hybla" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_ecn = 2" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_frto = 2" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_low_latency = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_mtu_probing = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_no_metrics_save = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_timestamps = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_wmem = 4096 16384 4194304" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_rmem = 4096 87380 4194304" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_delack_min = 5" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_reordering = 3" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_early_retrans = 3" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_ssthresh = 32768" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_frto_response = 2" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_abort_on_overflow = 1" >> /etc/sysctl.conf
    echo "net.core.netdev_max_backlog = 250000" >> /etc/sysctl.conf
    echo "net.core.rmem_default = 4194304" >> /etc/sysctl.conf
    echo "net.core.wmem_default = 4194304" >> /etc/sysctl.conf
    echo "net.core.rmem_max = 4194304" >> /etc/sysctl.conf
    echo "net.core.wmem_max = 4194304" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_max_tw_buckets = 5000" >> /etc/sysctl.conf
	echo "*               soft    nofile           1000000
*               hard    nofile          1000000">/etc/security/limits.conf
    echo "ulimit -SHn 1000000">>/etc/profile
    sysctl -p >/dev/null 2>&1
}
display_menu
check_sys
check_version
install_Hybla
sysctl_config
