all: build run

build:
	zig build-exe \
		-target wasm32-freestanding \
		-fno-entry \
		-rdynamic \
		-O ReleaseSmall \
		--name adder \
		src/contract.zig
	cargo run \
		--manifest-path=custom-sections/Cargo.toml \
		-- \
		--wasm adder.wasm
	rm *.o
	ls -lah *.wasm

deploy:
	stellar contract deploy --alias adder --wasm adder.wasm

run:
	stellar contract invoke --id adder -- add --a true --b 1 --c 2
	stellar contract invoke --id adder -- add --a false --b 1 --c 2

test:
	zig test src/val.zig
