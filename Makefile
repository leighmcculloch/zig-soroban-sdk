PROTO_VERSION=21

build:
	$(MAKE) -C contracts/math build
	$(MAKE) -C contracts/self build

math:
	$(MAKE) -C contracts/math build deploy test

self:
	$(MAKE) -C contracts/self build deploy test

generate-env:
	cd scripts && deno task generate-env --protocol 21 | zig fmt --stdin > ../src/env.zig
