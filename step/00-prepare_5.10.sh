#!/bin/bash
clear
# use 02
sed -i 's/Os/O2/g' include/target.mk
#Update feed
sed -i '4s/src-git/#src-git/g' ./feeds.conf.default
sed -i '5s/src-git/#src-git/g' ./feeds.conf.default
echo 'src-git addon https://github.com/quintus-lab/openwrt-package' >> ./feeds.conf.default
./scripts/feeds update -a && ./scripts/feeds install -a

#patch jsonc
patch -p1 < ../patches/0000-use_json_object_new_int64.patch
#Add upx-ucl support
patch -p1 < ../patches/0001-tools-add-upx-ucl-support.patch

patch -p1 < ../patches/0002-rockchip-rngd.patch

# add R4S support
patch -p1 < ../patches/0004-uboot-add-r4s-support.patch
patch -p1 < ../patches/0005-target-5.10-r4s-support.patch
patch -p1 < ../patches/0006-target-5.10-rockchip-support.patch

#dnsmasq aaaa filter
patch -p1 < ../patches/1001-dnsmasq_add_filter_aaaa_option.patch
cp -f ../patches/910-mini-ttl.patch package/network/services/dnsmasq/patches/
cp -f ../patches/911-dnsmasq-filter-aaaa.patch package/network/services/dnsmasq/patches/

#Fullcone patch
patch -p1 < ../patches/1002-add-fullconenat-support.patch
patch -p1 < ../patches/1003-luci-app-firewall_add_fullcone.patch
#update curl
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/curl package/network/utils/curl

#R2S overclock to 1.6G patch
#cp -f ../patches/999-unlock-1608mhz-rk3328.patch ./target/linux/rockchip/patches-5.4/

# patch cpuinfo display modelname
patch -p1 < ../patches/3829.patch

#Max connection limite
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

exit 0
