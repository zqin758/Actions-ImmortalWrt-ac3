#!/bin/bash
#
uci add dhcp domain
uci set "dhcp.@domain[-1].name=time.android.com"
uci set "dhcp.@domain[-1].ip=203.107.6.88"

# Modify default IP
sed -i 's/192.168.1.1/192.168.100.1/g' ./package/base-files/files/bin/config_generate
sed -i 's/hostname="ImmortalWrt"/hostname="SEED_AC3"/g' ./package/base-files/files/bin/config_generate
sed -i 's/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION="ImmortalWrt By IraXu $(date +%Y%m%d)"/g' ./package/base-files/files/etc/openwrt_release
# 更改时区
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# =============================================================
# ImmortalWrt 自定义DIY脚本 · Part1
# 作用：向 feeds.conf.default 追加 iStore / 易有云（NAS）软件源
# 执行时机：在 ./scripts/feeds update 之前
# 已按 GitHub 仓库实时核对三个源的默认分支
# =============================================================
set -e

add_feed() {
  # 幂等追加：已存在则不重复写入，避免重复执行导致重复源
  grep -qF "$1" feeds.conf.default || sed -i "\$a $1" feeds.conf.default
}

# 1) 易有云后端服务源（ddnsto / dockermanager / linkease / quickstart / unishare 等）
add_feed 'src-git nas https://github.com/linkease/nas-packages.git;master'

# 2) 易有云 LuCI 界面源（luci-app-ddnsto / luci-app-dockermanager / luci-app-linkease / luci-app-quickstart / luci-app-unishare）
add_feed 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main'

# 3) iStore 应用中心源（luci-app-store 本体所在，官方 README 推荐写法）
add_feed 'src-git istore https://github.com/linkease/istore;main'

echo "==> feeds.conf.default 中本次涉及的行："
grep -n 'src-git \(nas\|nas_luci\|istore\)' feeds.conf.default || true


# 取消Dnsmasq缓存，由smartdns负责。不修改ttl
#sed -i 's/cachesize\t8000/cachesize\t0/g' package/network/services/dnsmasq/files/dhcp.conf
#sed -i 's/mini_ttl\t3600/mini_ttl\t0/g' package/network/services/dnsmasq/files/dhcp.conf

# Remove 6in4
#sed -i 's/ +6in4//g' package/emortal/ipv6-helper/Makefile
#sed -i '/hotplug.d/d' package/emortal/ipv6-helper/Makefile
#rm -fv package/emortal/ipv6-helper/files/60-6in4

#cat >> package/mtk/drivers/mt_wifi/patches-7673/999-Increase-token-rx-cnt.patch <<EOF
#--- a/mt_wifi/chips/mt7981.c
#+++ b/mt_wifi/chips/mt7981.c
#@@ -11711,7 +11711,7 @@
# 	chip_cap->tkn_info.hw_tx_token_cnt = 8192;
# #ifdef MEMORY_SHRINK
# #ifdef MEMORY_SHRINK_AGGRESS
#-	chip_cap->tkn_info.token_rx_cnt = 4592;
#+	chip_cap->tkn_info.token_rx_cnt = 6144;
# #else
# 	chip_cap->tkn_info.token_rx_cnt = 12288;
# #endif	/* MEMORY_SHRINK_AGGRESS */
#EOF
