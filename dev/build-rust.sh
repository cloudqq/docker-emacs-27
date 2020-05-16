#!/usr/bin/env bash

sudo chown 1000:1000 /usr/local/rust
curl https://sh.rustup.rs -sSf  | sh -s -- -y

source /usr/local/rust/.cargo/env
rustup default nightly && rustup update
cargo install racer
rustup component add rust-src
