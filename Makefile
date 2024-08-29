PROTOCOL=21

build:
	zig build
	$(MAKE) -C examples/math build
	$(MAKE) -C examples/self build

test-math:
	$(MAKE) -C examples/math build deploy test

test-self:
	$(MAKE) -C examples/self build deploy test

generate-env:
	cd scripts && deno task generate-env --protocol $(PROTOCOL) | zig fmt --stdin > ../src/env.zig
