# rust
if ! command -v rustup 2>&1 >/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
rustup update

# taplo - lsp for toml
cargo install taplo-cli --locked

# nushell
cargo install nu
# cargo install nu_plugin_formats
# cargo install nu_plugin_gstat
# cargo install nu_plugin_query
# cargo install nu_plugin_inc
# cargo install nu_plugin_file
# cargo install nu_plugin_bash_env

# common lisp
ros install sbcl-bin
ros install qlot

# starship
cargo install starship --locked

# bun
if ! command -v bun 2>&1 >/dev/null; then
  curl -fsSL https://bun.sh/install | bash
fi

# javascript/typescript lsp
bun install -g typescript-language-server
bun install -g typescript

# json lsp
bun install -g vscode-json-languageserver

# git delta
cargo install git-delta --locked

# bat
cargo install bat --locked

# onefetch
cargo install onefetch --locked
