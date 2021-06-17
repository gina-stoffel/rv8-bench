#
# rv8-bench
#

CFLAGS = -fPIE -g
LDFLAGS = -static

RV32 = riscv32-linux-musl-
RV64 = riscv64-unknown-linux-musl-
I386 = i386-linux-musl-
X86_64 = x86_64-linux-musl-
ARM32 = arm-linux-musleabihf-
ARM64 = aarch64-linux-musl-

PROGRAMS = aes bigint dhrystone miniz norx primes qsort sha512

RV64_PROGS = $(addprefix bin/riscv64/, $(PROGRAMS))

ALL_PROGS = $(RV64_PROGS)
O3_PROGS = $(addsuffix .O3, $(ALL_PROGS))
O2_PROGS = $(addsuffix .O2, $(ALL_PROGS))
OS_PROGS = $(addsuffix .Os, $(ALL_PROGS))

all: $(O3_PROGS) $(OS_PROGS)

clean: ; rm -fr bin


bin/riscv64/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv64/%.O3: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)g++ $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv64/%.O3.stripped: bin/riscv64/%.O3
	@echo STRIP $@ ; $(RV64)strip --strip-all $< -o $@
bin/riscv64/%.O2: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv64/%.O2: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)g++ $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv64/%.O2.stripped: bin/riscv64/%.O2
	@echo STRIP $@ ; $(RV64)strip --strip-all $< -o $@
bin/riscv64/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv64/%.Os: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)g++ $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv64/%.Os.stripped: bin/riscv64/%.Os
	@echo STRIP $@ ; $(RV64)strip --strip-all $< -o $@

