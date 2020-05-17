set USER=cloudqq
set WORKDIR=/mnt/workspace
set VOL_DEV_VOLUME=vol_rust_runtime6
set VOL_DEV_PATH=/usr/local/rust


docker run -it --rm  ^
 -v %VOL_DEV_VOLUME%:%VOL_DEV_PATH% ^
 -v C:\Users\cloudq\Downloads:/backup ^
 -e UNAME="%USER%"^
 -e GNAME="%USER%"^
 -e UID="1000"^
 -e GID="1000"^
 -e UHOME="/home/%USER%" ^
 -e RUST_VERSION=1.40.0 ^
 -e CARGO_HOME=/usr/local/rust/.cargo ^
 -e RUSTUP_HOME=/usr/local/rust/.rustup ^
 busybox sh
REM busybox:latest sh -c "mkdir -p /usr/local; cd /usr/local; tar xvf /backup/rust-env.tar"

