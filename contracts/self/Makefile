build:
	zig build-exe \
		-target wasm32-freestanding \
		-fno-entry \
		-rdynamic \
		-O ReleaseSmall \
		--dep soroban-sdk \
		--name self \
		-Mroot=self.zig \
		-Msoroban-sdk=../../src/root.zig
	cat env-meta.json \
		| stellar-xdr encode --type ScEnvMetaEntry --output stream \
		| wasm-cs self.wasm write contractenvmetav0
	cat spec.json \
		| stellar-xdr encode --type ScSpecEntry --output stream \
		| wasm-cs self.wasm write contractspecv0
	ls -lah *.wasm

deploy:
	stellar contract deploy --alias self --wasm self.wasm

test:
	stellar contract invoke --id self -- id
