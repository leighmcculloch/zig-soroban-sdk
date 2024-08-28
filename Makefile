build:
	$(MAKE) -C contracts/adder build

math:
	$(MAKE) -C contracts/math build deploy test

self:
	$(MAKE) -C contracts/self build deploy test

