build:
	$(MAKE) -C contracts/adder build

math:
	$(MAKE) -C contracts/math build deploy test
