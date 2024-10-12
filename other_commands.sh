# rust
if ! command -v rustup 2>&1 >/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# taplo - lsp for toml
cargo install taplo-cli --locked

# nushell
cargo install nu
cargo install nu_plugin_formats
cargo install nu_plugin_gstat
cargo install nu_plugin_query
cargo install nu_plugin_inc
cargo install nu_plugin_file
cargo install nu_plugin_bash_env

