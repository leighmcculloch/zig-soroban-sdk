build:
	zig build-exe \
		-target wasm32-freestanding \
		-fno-entry \
		-rdynamic \
		-O ReleaseSmall \
		math.zig
	cat env-meta.json \
		| stellar-xdr encode --type ScEnvMetaEntry --output stream \
		| wasm-cs math.wasm write contractenvmetav0
	cat spec.json \
		| stellar-xdr encode --type ScSpecEntry --output stream \
		| wasm-cs math.wasm write contractspecv0
	ls -lah *.wasm

deploy:
	stellar contract deploy --alias math --wasm math.wasm

test:
	stellar contract invoke --id math -- add --x 1 --y 2
	stellar contract invoke --id math -- sub --x 3 --y 1
