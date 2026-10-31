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
