# XMZO fork 说明

本 fork 的 `main` 跟随上游 `luodaoyi/komari-zig-agent`，不再保留额外脚本。

## 替换官方 agent

上游 `replace.sh` 从 [#45](https://github.com/luodaoyi/komari-zig-agent/pull/45) 起已原生不保留备份，原来的 `replace-no-backup.sh` 已移除，直接用上游脚本：

```sh
curl -fsSL https://raw.githubusercontent.com/luodaoyi/komari-zig-agent/main/replace.sh | sudo sh
```

不加 `--version` 时安装最新 Release。固定版本：

```sh
curl -fsSL https://raw.githubusercontent.com/luodaoyi/komari-zig-agent/main/replace.sh | sudo sh -s -- \
  --version v0.1.56
```

使用 GitHub 下载代理：

```sh
curl -fsSL https://raw.githubusercontent.com/luodaoyi/komari-zig-agent/main/replace.sh | sudo sh -s -- \
  --ghproxy https://gh.llkk.cc
```

指定服务名或二进制路径：

```sh
curl -fsSL https://raw.githubusercontent.com/luodaoyi/komari-zig-agent/main/replace.sh | sudo sh -s -- \
  --service komari-agent \
  --binary /opt/komari/agent
```

说明：

- 不生成 `*.go-backup.*`，也不自动回滚。
- 下载、`SHA256SUMS` 校验或二进制预检失败时，原 agent 保持不变。
- 替换后服务启动或健康检查失败时，脚本报错退出，保留新二进制，需要手动处理。
- 原服务里的 `--endpoint`、`--token`、`--month-rotate` 等参数会继续保留，脚本只替换二进制。

## 同步上游

本 fork 有自己的提交，无法 fast-forward，用普通 merge：

```sh
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

本 fork 只多了这个说明文件，和上游不会冲突。
