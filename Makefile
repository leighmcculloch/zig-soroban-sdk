all: build run

build:
	zig build
	cargo run --manifest-path=custom-sections/Cargo.toml -- --wasm zig-out/lib/adder.wasm
	cd zig-out/lib/ && ls -lah *.wasm

run:
	soroban invoke --wasm zig-out/lib/adder.wasm --id 1 --fn add --arg true --arg 1 --arg 2
	soroban invoke --wasm zig-out/lib/adder.wasm --id 1 --fn add --arg false --arg 1 --arg 2

test:
	zig test src/val.zig
