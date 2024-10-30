#!/bin/bash

#######################################################
# Tocdo.net Linux Server Benchmarks v1.5
# Run speed test:
# curl -Lso- tocdo.net | bash
#######################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'

# Check if the script is run as root
[[ $EUID -ne 0 ]] && echo -e "${RED}Error:${PLAIN} This script must be run as root!" && exit 1

# Install wget, fio, and virt-what
if  [ ! -e '/usr/bin/wget' ] || [ ! -e '/usr/bin/fio' ] ||  [ ! -e '/usr/sbin/virt-what' ]; then
    echo -e "Please wait..."
    apt-get update > /dev/null 2>&1 && apt-get install -y wget fio virt-what > /dev/null 2>&1
fi

virtua=$(virt-what)

if [[ ${virtua} ]]; then
    virt="$virtua"
else
    virt="No Virt"
fi

get_opsy() {
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

speed_test() {
    local speedtest=$(wget -4O /dev/null -T300 $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}')
    local ipaddress=$(ping -c1 -n `awk -F'/' '{print $3}' <<< $1` | awk -F'[()]' '{print $2;exit}')
    local nodeName=$2
    printf "${YELLOW}%-40s${GREEN}%-16s${RED}%-14s${PLAIN}\n" "${nodeName}" "${ipaddress}" "${speedtest}"
}

speed_test_v6() {
    local speedtest=$(wget -6O /dev/null -T300 $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}')
    local ipaddress=$(ping6 -c1 -n `awk -F'/' '{print $3}' <<< $1` | awk -F'[()]' '{print $2;exit}')
    local nodeName=$2
    printf "${YELLOW}%-40s${GREEN}%-16s${RED}%-14s${PLAIN}\n" "${nodeName}" "${ipaddress}" "${speedtest}"
}

speed() {
    speed_test 'http://cachefly.cachefly.net/100mb.test' 'CacheFly'
    speed_test 'https://lax-ca-us-ping.vultr.com/vultr.com.100MB.bin' 'Vultr, Los Angeles, CA'
    speed_test 'https://wa-us-ping.vultr.com/vultr.com.100MB.bin' 'Vultr, Seattle, WA'
    speed_test 'http://speedtest.tokyo2.linode.com/100MB-tokyo.bin' 'Linode, Tokyo, JP'
    speed_test 'http://speedtest.singapore.linode.com/100MB-singapore.bin' 'Linode, Singapore, SG'
    speed_test 'http://speedtest.hkg02.softlayer.com/downloads/test100.zip' 'Softlayer, HongKong, CN'
    speed_test 'http://speedtest1.vtn.com.vn/speedtest/random4000x4000.jpg' 'VNPT, Ha Noi, VN'
    speed_test 'http://speedtest5.vtn.com.vn/speedtest/random4000x4000.jpg' 'VNPT, Da Nang, VN'
    speed_test 'http://speedtest3.vtn.com.vn/speedtest/random4000x4000.jpg' 'VNPT, Ho Chi Minh, VN'
    speed_test 'http://speedtestkv1a.viettel.vn/speedtest/random4000x4000.jpg' 'Viettel Network, Ha Noi, VN'
    speed_test 'http://speedtestkv2a.viettel.vn/speedtest/random4000x4000.jpg' 'Viettel Network, Da Nang, VN'
    speed_test 'http://speedtestkv3a.viettel.vn/speedtest/random4000x4000.jpg' 'Viettel Network, Ho Chi Minh, VN'
    speed_test 'http://speedtesthn.fpt.vn/speedtest/random4000x4000.jpg' 'FPT Telecom, Ha Noi, VN'
    speed_test 'http://speedtest.fpt.vn/speedtest/random4000x4000.jpg' 'FPT Telecom, Ho Chi Minh, VN'
}

io_test() {
    (LANG=C dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

dd_test() {
    echo "dd Test"
    io1=$( io_test )
    echo "I/O (1st run)        : $io1"
    io2=$( io_test )
    echo "I/O (2nd run)        : $io2"
    io3=$( io_test )
    echo "I/O (3rd run)        : $io3"
    ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
    [ "`echo $io1 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw1=$( awk 'BEGIN{print '$ioraw1' * 1024}' )
    ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
    [ "`echo $io2 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw2=$( awk 'BEGIN{print '$ioraw2' * 1024}' )
    ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
    [ "`echo $io3 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw3=$( awk 'BEGIN{print '$ioraw3' * 1024}' )
    ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
    ioavg=$( awk 'BEGIN{printf "%.1f", '$ioall' / 3}' )
    echo "Average              : $ioavg MB/s"
}

fio_test() {
    if [ -e '/usr/bin/fio' ]; then
        echo "Fio Test"
        local tmp=$(mktemp)
        fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test --filename=fio_test --bs=4k --numjobs=1 --iodepth=64 --size=256M --readwrite=randrw --rwmixread=75 --runtime=30 --time_based --output="$tmp"

        if [ $(fio -v | cut -d '.' -f 1) == "fio-2" ]; then
            local iops_read=`grep "iops=" "$tmp" | grep read | awk -F[=,]+ '{print $6}'`
            local iops_write=`grep "iops=" "$tmp" | grep write | awk -F[=,]+ '{print $6}'`
            local bw_read=`grep "bw=" "$tmp" | grep read | awk -F[=,B]+ '{if(match($4, /[0-9]+K$/)) {printf("%.1f", int($4)/1024);} else if(match($4, /[0-9]+M$/)) {printf("%.1f", substr($4, 0, length($4)-1))} else {printf("%.1f", int($4)/1024/1024);}}'`"MB/s"
            local bw_write=`grep "bw=" "$tmp" | grep write | awk -F[=,B]+ '{if(match($4, /[0-9]+K$/)) {printf("%.1f", int($4)/1024);} else if(match($4, /[0-9]+M$/)) {printf("%.1f", substr($4, 0, length($4)-1))} else {printf("%.1f", int($4)/1024/1024);}}'`"MB/s"

        elif [ $(fio -v | cut -d '.' -f 1) == "fio-3" ]; then
            local iops_read=`grep "IOPS" "$tmp" | grep read | awk '{print $3}'`
            local iops_write=`grep "IOPS" "$tmp" | grep write | awk '{print $3}'`
            local bw_read=`grep "READ" "$tmp" | awk '{print $2}'`
            local bw_write=`grep "WRITE" "$tmp" | awk '{print $2}'`
        fi

        echo "IOPS (Read)         : $iops_read"
        echo "IOPS (Write)        : $iops_write"
        echo "Bandwidth (Read)    : $bw_read"
        echo "Bandwidth (Write)   : $bw_write"
        rm -f "$tmp"
    fi
}

# Get Operating System
osname=$(get_opsy)
# Get Current Date
date=$(date +%Y-%m-%d\ %H:%M)

echo -e "${YELLOW}OS: ${GREEN}${osname}${PLAIN}  Date: ${date}"
next
echo "Virtualization: ${virt}"

# Run tests
speed
next
dd_test
next
fio_test
