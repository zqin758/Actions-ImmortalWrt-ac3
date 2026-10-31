#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
git clone https://github.com/gSpotx2f/luci-app-cpu-perf.git package/luci-app-cpu-perf
git clone https://github.com/gSpotx2f/luci-app-cpu-status.git package/luci-app-cpu-status
git clone https://github.com/gSpotx2f/luci-app-temp-status.git package/luci-app-temp-status


# Replace Smartdns
#rm -rfv feeds/luci/applications/luci-app-smartdns
#rm -rfv feeds/packages/net/smartdns
#git clone --depth=1 -b PikuZheng https://github.com/Ljzkirito/smartdns-openwrt temp-smartdns
#mv -fv temp-smartdns/luci-app-smartdns feeds/luci/applications/
#mv -fv temp-smartdns/smartdns feeds/packages/net/
#rm -rf temp-smartdns

# Replace luci-theme-argon
#rm -rfv feeds/luci/themes/luci-theme-argon
#git clone https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon
#git -C feeds/luci/themes/luci-theme-argon checkout 1991a8e29ef6a086fb566517675edc85b1be629a

#https://github.com/immortalwrt/packages/issues/1607
#sed -i 's/--set=llvm\.download-ci-llvm=true/--set=llvm.download-ci-llvm=false/' feeds/packages/lang/rust/Makefile

# 删除自带的 passwall 核心库
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls,smartdns}
rm -rf package/feeds/packages/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls,smartdns}
# 拉取新的 passwall 核心库
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/chajian/passwall-packages

# 删除自带的 luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf package/feeds/luci/luci-app-passwall
# 拉取新的 luci-app-passwall
git clone https://github.com/Openwrt-Passwall/openwrt-passwall.git package/chajian/passwall-luci

# 删除自带的 open-app-filter
rm -rf feeds/packages/net/open-app-filter
rm -rf package/feeds/packages/open-app-filter
# 拉取新的 OpenAppFilter、luci-app-oaf
git clone https://github.com/destan19/OpenAppFilter.git package/chajian/OpenAppFilter
