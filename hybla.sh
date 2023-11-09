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


run_drop_caches() {
    for ((i=1; i<=5; i++)); do
        sync; echo $i > /proc/sys/vm/drop_caches
        sleep 2
    done
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

}
sysctl_config() {
		echo -e "#Hybla optimize network traffic\n#Github: https://github.com/MrAminiNezhad/\n" > /etc/sysctl.conf
		echo "net.ipv4.tcp_congestion_control = hybla" >> /etc/sysctl.conf
		echo "net.core.default_qdisc = fq_codel" >> /etc/sysctl.conf
		echo "net.core.optmem_max = 65535" >> /etc/sysctl.conf
		echo "net.ipv4.ip_no_pmtu_disc = 1" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_ecn = 2" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_frto = 2" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_keepalive_intvl = 30" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_keepalive_probes = 3" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_keepalive_time = 300" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_low_latency = 1" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_mtu_probing = 1" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_no_metrics_save = 1" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_timestamps = 1" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_delack_min = 5" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_reordering = 3" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_early_retrans = 3" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_ssthresh = 32768" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_frto_response = 2" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_abort_on_overflow = 1" >> /etc/sysctl.conf
		echo "net.core.rmem_default = 4194304" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_max_orphans = 3276800" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_autocorking = 1" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
		echo "fs.file-max = 1000000" >> /etc/sysctl.conf
		echo "fs.inotify.max_user_instances = 8192" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
		echo "net.ipv4.ip_local_port_range = 75 65535" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_rmem = 16384 262144 8388608" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_wmem = 32768 524288 16777216" >> /etc/sysctl.conf
		echo "net.core.somaxconn = 8192" >> /etc/sysctl.conf
		echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
		echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
		echo "net.core.wmem_default = 2097152" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_max_tw_buckets = 5000" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_max_syn_backlog = 10240" >> /etc/sysctl.conf
		echo "net.core.netdev_max_backlog = 10240" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_notsent_lowat = 16384" >> /etc/sysctl.conf
		echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_fin_timeout = 25" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_mem = 65536 131072 262144" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_retries2 = 8" >> /etc/sysctl.conf
		echo "net.ipv4.udp_mem = 65536 131072 262144" >> /etc/sysctl.conf
		echo "net.unix.max_dgram_qlen = 50" >> /etc/sysctl.conf
		echo "vm.min_free_kbytes = 65536" >> /etc/sysctl.conf
		echo "vm.swappiness = 10" >> /etc/sysctl.conf
		echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
		echo "ulimit -SHn 1000000">>/etc/profile
		sudo sysctl -p
		sudo sysctl --system
}

cloner() {
		sed -i '/#Hybla optimize network traffic/,/#Github: https:\/\/github.com\/MrAminiNezhad\//d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
		sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
		sed -i '/net.core.optmem_max/d' /etc/sysctl.conf
		sed -i '/net.ipv4.ip_no_pmtu_disc/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_frto/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_keepalive_intvl/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_keepalive_probes/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_keepalive_time/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_low_latency/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_mtu_probing/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_no_metrics_save/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_window_scaling/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_sack/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_delack_min/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_reordering/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_early_retrans/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_ssthresh/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_frto_response/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_abort_on_overflow/d' /etc/sysctl.conf
		sed -i '/net.core.rmem_default/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_autocorking/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_tw_recycle/d' /etc/sysctl.conf
		sed -i '/fs.file-max/d' /etc/sysctl.conf
		sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
		sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
		sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
		sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
		sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
		sed -i '/net.core.wmem_default/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
		sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_notsent_lowat/d' /etc/sysctl.conf
		sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_mem/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
		sed -i '/net.ipv4.udp_mem/d' /etc/sysctl.conf
		sed -i '/net.unix.max_dgram_qlen/d' /etc/sysctl.conf
		sed -i '/vm.min_free_kbytes/d' /etc/sysctl.conf
		sed -i '/vm.swappiness/d' /etc/sysctl.conf
		sed -i '/vm.vfs_cache_pressure/d' /etc/sysctl.conf
		sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub
		sudo update-grub
	}

save_config() {
    sudo sysctl -p
    sudo sysctl --system
}

reboot_server() {
	clear
	echo "The kernel version is greater than 6.5.7, directly setting TCP Hybla..."
	echo "Setting TCP Hybla completed"
	echo "TCP Hybla has been successfully installed and configured."
	echo "enjoy it..."
    read -p "It is recommended to reboot the server for better performance (recommended). Do you want to restart now? [Y/n] :" yn
    [ -z "${yn}" ] && yn="y"
    if [[ $yn == [Yy] ]]; then
        echo -e "good choice ,VPS is rebooting..."
		sleep 3
        reboot
    fi
}

display_menu
run_drop_caches
cloner
check_sys
check_version
install_Hybla
sysctl_config
save_config
reboot_server
