# komari-zig-agent XMZO fork

这是 `luodaoyi/komari-zig-agent` 的个人 fork，尽量保持上游源码结构和 `README.md` 不改动，方便后续同步原作者更新。

## 与上游的关系

- 上游仓库：<https://github.com/luodaoyi/komari-zig-agent>
- 本 fork：<https://github.com/XMZO/komari-zig-agent>
- `README.md` 保持跟随上游；本文件记录 fork 自己的差异和维护方式。

## 当前 fork 差异

### IPv6 与 Cloudflare 来源 IP 修复

本 fork 针对主控端套 Cloudflare、节点端运行在 systemd/Debian 环境时的 basic info IP 上报问题做了修复：

1. Linux 外部命令执行会先把 `ip` 等命令解析成绝对路径再运行，避免 systemd PATH 不包含 `/usr/sbin` 时出现“预检查找到 `/usr/sbin/ip`，实际 spawn 找不到 `ip`”的问题。
2. IPv6 探测命令异常时不再直接误判为“无可用 IPv6 路由”，而是走 provider 层的降级逻辑，允许公网 IPv6 查询继续尝试。
3. 后台 basic info 循环启动后立即执行一次，不再先等待默认 5 分钟。
4. 启动/重连的前台 basic info 如果快速本机采集后 IPv4 仍为空，会暂缓这次上传，等待后台公网 IP 刷新，避免主控端把 Cloudflare 来源 IPv4 作为节点 IP 写入。

## 自更新仓库

本 fork 支持在构建时指定自更新使用的 GitHub 仓库：

```sh
zig build -Doptimize=ReleaseSmall -Dversion=v0.1.39-xmzo.1 -Drelease-repo=XMZO/komari-zig-agent
```

GitHub Release workflow 已自动使用 `${{ github.repository }}` 注入 `-Drelease-repo`，因此从本 fork Actions 构建出的二进制会检查本 fork 的 Release，而不是回到上游仓库。

## 同步上游

保持 remote：

```text
origin   https://github.com/XMZO/komari-zig-agent
upstream https://github.com/luodaoyi/komari-zig-agent
```

同步上游推荐流程：

```sh
git fetch upstream
git checkout main
git pull --ff-only origin main
git merge --no-ff upstream/main
git push origin main
```

不要用 `git reset --hard upstream/main` 覆盖本 fork 的修复。

## 发布本 fork 版本

推荐使用带 fork 后缀的 tag，避免和上游版本混淆：

```sh
git tag -a v0.1.39-xmzo.1 -m "Release v0.1.39-xmzo.1"
git push origin v0.1.39-xmzo.1
```

也可以在 GitHub Actions 的 `Release` workflow 中手动输入同样的版本号发布。
