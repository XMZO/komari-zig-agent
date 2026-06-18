# XMZO fork helper

本 fork 的 `main` 保持跟随上游 `luodaoyi/komari-zig-agent`。当前只额外保留一个辅助脚本：不保留 `*.go-backup.*` 的替换方式。

## 不保留备份替换官方 agent

默认仍然下载和安装上游官方 Release：

```sh
curl -fsSL https://raw.githubusercontent.com/XMZO/komari-zig-agent/main/replace-no-backup.sh | sudo sh
```

指定上游版本：

```sh
curl -fsSL https://raw.githubusercontent.com/XMZO/komari-zig-agent/main/replace-no-backup.sh | sudo sh -s -- \
  --version v0.1.42
```

使用 GitHub 下载代理：

```sh
curl -fsSL https://raw.githubusercontent.com/XMZO/komari-zig-agent/main/replace-no-backup.sh | sudo sh -s -- \
  --ghproxy https://gh.llkk.cc
```

指定服务名或二进制路径：

```sh
curl -fsSL https://raw.githubusercontent.com/XMZO/komari-zig-agent/main/replace-no-backup.sh | sudo sh -s -- \
  --service komari-agent \
  --binary /opt/komari/agent
```

说明：

- 这个脚本会调用上游官方 `replace.sh`，因此下载地址、Release、自更新仓库都保持原作者默认值：`luodaoyi/komari-zig-agent`。
- 替换失败时不会删除备份，方便上游脚本回滚。
- 替换成功后，会删除本次上游脚本输出的 `backup: ...` 对应 `*.go-backup.*` 文件。
- 原服务里的 `--endpoint`、`--token`、`--month-rotate` 等参数会继续保留；替换脚本只替换二进制。

## 同步上游

```sh
git fetch upstream
git checkout main
git merge --ff-only upstream/main
git push origin main
```

如果上游和本 fork 的辅助脚本无冲突，保持 `main` 跟随上游即可。
