#!/usr/bin/env bash
# Detect the tools this phase needs and install only what is missing.
# Official archives are unpacked into ~/.local. Package managers are not used.
# Does not install MySQL, Redis, or Elasticsearch.
set -u

need_go=0
need_node=0
need_docker=0
fail=0
path_note=""

usage() {
  printf 'usage: setup-env.sh [--server] [--web] [--admin] [--docker]\n'
}

record() {
  printf '%s\t%s\t%s\n' "$1" "$2" "$3"
  if [[ "$2" == "fail" ]]; then
    fail=1
  fi
}

for arg in "$@"; do
  case "$arg" in
    --server) need_go=1 ;;
    --web|--admin) need_node=1 ;;
    --docker) need_docker=1 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'unknown argument: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

add_path() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0
  case ":$PATH:" in
    *":$dir:"*) ;;
    *) PATH="$dir:$PATH" ;;
  esac
}

prepend_known_paths() {
  local nvm_root nvm_ver
  if [[ -x /opt/homebrew/bin/brew ]]; then
    add_path /opt/homebrew/bin
  elif [[ -x /usr/local/bin/brew ]]; then
    add_path /usr/local/bin
  fi
  add_path "$HOME/.local/bin"
  add_path "$HOME/.local/go/bin"
  add_path "$HOME/.local/node/bin"
  add_path /usr/local/go/bin
  add_path "$HOME/sdk/go/bin"
  add_path "$HOME/.volta/bin"
  add_path "$HOME/.asdf/shims"
  add_path "/Applications/Docker.app/Contents/Resources/bin"
  add_path "$HOME/.docker/bin"
  add_path "$HOME/Library/Application Support/fnm/aliases/default/bin"
  add_path "$HOME/.local/share/fnm/aliases/default/bin"
  add_path "/c/Program Files/Git/cmd"
  add_path "/c/Program Files/Go/bin"
  add_path "/c/Program Files/nodejs"
  add_path "/c/Program Files/Docker/Docker/resources/bin"
  nvm_root="${NVM_DIR:-$HOME/.nvm}"
  if [[ -f "$nvm_root/alias/default" ]]; then
    nvm_ver=$(tr -d '\r\n' < "$nvm_root/alias/default")
    add_path "$nvm_root/versions/node/$nvm_ver/bin"
  fi
  export PATH
}

remember_path() {
  local dir="$1"
  case ":$path_note:" in
    *":$dir:"*) ;;
    *) path_note="${path_note:+$path_note:}$dir" ;;
  esac
}

has() {
  command -v "$1" >/dev/null 2>&1
}

version_of() {
  local out
  out=$("$@" 2>/dev/null | head -n 1 | tr -d '\r') || true
  printf '%s' "$out"
}

manual() {
  record sudo manual "在本机终端执行: $1"
}

ensure_curl() {
  has curl && return 0
  manual "本机没有 curl，装好后重新运行脚本"
  return 1
}

machine() {
  uname -s
}

cpu() {
  uname -m
}

go_arch() {
  case "$(cpu)" in
    x86_64|amd64) printf 'amd64' ;;
    arm64|aarch64) printf 'arm64' ;;
    *) return 1 ;;
  esac
}

node_arch() {
  case "$(cpu)" in
    x86_64|amd64) printf 'x64' ;;
    arm64|aarch64) printf 'arm64' ;;
    *) return 1 ;;
  esac
}

install_go_tarball() {
  local ver os arch url tmp
  ensure_curl || return 1
  ver=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n 1 | tr -d '\r')
  case "$(machine)" in
    Darwin) os=darwin ;;
    Linux) os=linux ;;
    *) return 1 ;;
  esac
  arch=$(go_arch) || return 1
  url="https://go.dev/dl/${ver}.${os}-${arch}.tar.gz"
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "$tmp/go.tgz" || return 1
  rm -rf "$HOME/.local/go"
  mkdir -p "$HOME/.local"
  tar -C "$HOME/.local" -xzf "$tmp/go.tgz" || return 1
  rm -rf "$tmp"
  PATH="$HOME/.local/go/bin:$PATH"
  export PATH
  remember_path "$HOME/.local/go/bin"
}

install_node_tarball() {
  local ver os arch url tmp chunk
  ensure_curl || return 1
  case "$(machine)" in
    Darwin) os=darwin ;;
    Linux) os=linux ;;
    *) return 1 ;;
  esac
  arch=$(node_arch) || return 1
  chunk=$(curl -fsSL https://nodejs.org/dist/index.json | tr '}' '\n' | grep '"lts":"' | head -n 1)
  ver=$(printf '%s' "$chunk" | sed -n 's/.*"version":"\(v[0-9][^"]*\)".*/\1/p')
  [[ -n "$ver" ]] || return 1
  url="https://nodejs.org/dist/${ver}/node-${ver}-${os}-${arch}.tar.xz"
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "$tmp/node.txz" || return 1
  rm -rf "$HOME/.local/node"
  mkdir -p "$HOME/.local"
  tar -C "$tmp" -xJf "$tmp/node.txz" || return 1
  mv "$tmp"/node-* "$HOME/.local/node"
  rm -rf "$tmp"
  PATH="$HOME/.local/node/bin:$PATH"
  export PATH
  remember_path "$HOME/.local/node/bin"
}

latest_version() {
  printf '%s\n' "$1" | sed 's/^git-//;s/^docker-//;s/\.tgz$//;s/\.tar\.gz$//' | sort -t. -k1,1n -k2,2n -k3,3n | tail -n 1
}

docker_arch() {
  case "$(cpu)" in
    x86_64|amd64) printf 'x86_64' ;;
    arm64|aarch64) printf 'aarch64' ;;
    *) return 1 ;;
  esac
}

install_git_source() {
  local ver url tmp
  ensure_curl || return 1
  if ! has cc && ! has gcc && ! has clang; then
    manual "Git 从官方源码安装，本机没有 C 编译器。装好编译器后重新运行脚本"
    return 1
  fi
  if ! has make; then
    manual "Git 从官方源码安装，本机没有 make。装好 make 后重新运行脚本"
    return 1
  fi
  ver=$(latest_version "$(curl -fsSL https://mirrors.edge.kernel.org/pub/software/scm/git/ | grep -o 'git-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.tar\.gz')")
  [[ -n "$ver" ]] || return 1
  url="https://mirrors.edge.kernel.org/pub/software/scm/git/git-${ver}.tar.gz"
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "$tmp/git.tgz" || return 1
  tar -C "$tmp" -xzf "$tmp/git.tgz" || return 1
  if ! ( cd "$tmp"/git-* && make prefix="$HOME/.local" NO_GETTEXT=1 NO_TCLTK=1 NO_INSTALL_HARDLINKS=1 all && make prefix="$HOME/.local" NO_GETTEXT=1 NO_TCLTK=1 NO_INSTALL_HARDLINKS=1 install ); then
    rm -rf "$tmp"
    manual "make prefix=$HOME/.local NO_GETTEXT=1 NO_TCLTK=1 install"
    return 1
  fi
  rm -rf "$tmp"
  PATH="$HOME/.local/bin:$PATH"
  export PATH
  remember_path "$HOME/.local/bin"
}

install_git() {
  case "$(machine)" in
    Darwin|Linux) install_git_source ;;
    *)
      manual "Windows 请运行 setup-env.ps1，它把 MinGit 解压到用户目录"
      return 1
      ;;
  esac
}

install_go() {
  case "$(machine)" in
    Darwin|Linux) install_go_tarball ;;
    *)
      manual "Windows 请运行 setup-env.ps1，它把 Go 官方 zip 解压到用户目录"
      return 1
      ;;
  esac
}

install_node() {
  case "$(machine)" in
    Darwin|Linux) install_node_tarball ;;
    *)
      manual "Windows 请运行 setup-env.ps1，它把 Node.js 官方 zip 解压到用户目录"
      return 1
      ;;
  esac
}

install_docker() {
  local os arch ver url tmp cos carch compose_ver
  ensure_curl || return 1
  case "$(machine)" in
    Darwin) os=mac; cos=darwin ;;
    Linux) os=linux; cos=linux ;;
    *)
      manual "Windows 请运行 setup-env.ps1，它把 Docker 客户端解压到用户目录"
      return 1
      ;;
  esac
  arch=$(docker_arch) || return 1
  ver=$(latest_version "$(curl -fsSL "https://download.docker.com/${os}/static/stable/${arch}/" | grep -o 'docker-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.tgz')")
  [[ -n "$ver" ]] || return 1
  url="https://download.docker.com/${os}/static/stable/${arch}/docker-${ver}.tgz"
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "$tmp/docker.tgz" || return 1
  tar -C "$tmp" -xzf "$tmp/docker.tgz" || return 1
  mkdir -p "$HOME/.local/bin" "$HOME/.docker/cli-plugins"
  cp "$tmp/docker/docker" "$HOME/.local/bin/docker"
  chmod +x "$HOME/.local/bin/docker"
  if [[ "$os" == linux && -f "$tmp/docker/dockerd" ]]; then
    cp "$tmp/docker/dockerd" "$HOME/.local/bin/dockerd"
    chmod +x "$HOME/.local/bin/dockerd"
  fi
  rm -rf "$tmp"
  carch=$(docker_arch) || return 1
  compose_ver=$(curl -fsSL https://api.github.com/repos/docker/compose/releases/latest | sed -n 's/.*"tag_name": *"\(v[^"]*\)".*/\1/p' | head -n 1)
  if [[ -n "$compose_ver" ]] && curl -fsSL "https://github.com/docker/compose/releases/download/${compose_ver}/docker-compose-${cos}-${carch}" -o "$HOME/.docker/cli-plugins/docker-compose"; then
    chmod +x "$HOME/.docker/cli-plugins/docker-compose"
  else
    manual "把 docker-compose 放到 $HOME/.docker/cli-plugins/docker-compose：https://github.com/docker/compose/releases/latest"
  fi
  PATH="$HOME/.local/bin:$PATH"
  export PATH
  remember_path "$HOME/.local/bin"
}

prepend_known_paths

if has git; then
  record git keep "$(version_of git --version)"
else
  install_git || true
  prepend_known_paths
  if has git; then
    record git install "$(version_of git --version)"
  else
    record git fail "install Git from https://git-scm.com/downloads"
  fi
fi

if [[ "$need_go" -eq 1 ]]; then
  if has go; then
    record go keep "$(version_of go version)"
  else
    install_go || true
    prepend_known_paths
    if has go; then
      record go install "$(version_of go version)"
    else
      record go fail "install the current stable Go from https://go.dev/dl/"
    fi
  fi
else
  record go skip ""
fi

if [[ "$need_node" -eq 1 ]]; then
  if has node && has npm; then
    record node keep "$(version_of node -v)"
    record npm keep "$(version_of npm -v)"
  else
    install_node || true
    prepend_known_paths
    if has node; then
      record node install "$(version_of node -v)"
    else
      record node fail "install the current Node.js LTS from https://nodejs.org/"
    fi
    if has npm; then
      record npm install "$(version_of npm -v)"
    else
      record npm fail "npm is missing after the Node.js install"
    fi
  fi
else
  record node skip ""
  record npm skip ""
fi

if [[ "$need_docker" -eq 1 ]]; then
  docker_state=keep
  if ! has docker; then
    install_docker || true
    prepend_known_paths
    docker_state=install
  fi
  if has docker; then
    client=$(version_of docker version --format '{{.Client.Version}}')
    if docker info >/dev/null 2>&1; then
      record docker "$docker_state" "${client:-installed}"
      if docker compose version >/dev/null 2>&1; then
        record compose "$docker_state" "$(version_of docker compose version)"
      else
        record compose fail "docker compose plugin is missing"
      fi
    else
      if [[ -x "$HOME/.local/bin/dockerd" ]]; then
        record docker daemon-down "客户端已在用户目录。启动守护进程需要系统权限，在本机终端执行: sudo $HOME/.local/bin/dockerd"
      elif [[ "$(uname -s)" == Darwin ]]; then
        record docker daemon-down "客户端已可用。macOS 的守护进程不随压缩包启动，打开已安装的 Docker"
      else
        record docker daemon-down "start Docker"
      fi
      if docker compose version >/dev/null 2>&1; then
        record compose "$docker_state" "$(version_of docker compose version)"
      else
        record compose daemon-down "先启动 Docker 守护进程"
      fi
    fi
  else
    record docker fail "install Docker from https://docs.docker.com/get-docker/"
    record compose fail "docker compose is missing"
  fi
else
  record docker skip ""
  record compose skip ""
fi

if [[ -n "$path_note" ]]; then
  printf 'path\tadd\texport PATH="%s:$PATH"\n' "$path_note"
fi

if [[ "$fail" -eq 0 ]]; then
  printf 'setup-env\tok\n'
  exit 0
fi
printf 'setup-env\tfailed\n'
exit 1
