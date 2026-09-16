RAY ?= ray

.PHONY: run dev test check native smoke

run:      ## run in the VM (needs raylang >= 1.23)
	@$(RAY) run

dev:      ## run with live reload of assets/ and src/
	@$(RAY) dev

check:
	@$(RAY) check

test:     ## unit tests of the document model
	@$(RAY) test

native:   ## native binary (./raynote)
	@$(RAY) build --native --release

smoke:    ## headless smoke: the app starts, installs menus and opens its window without a display
	@RAY_UI_BACKEND=headless RAY_UI_TRACE=1 RAY_UI_EXIT_AFTER_MS=800 $(RAY) run 2>&1 | grep -E "\[ui\] (menu|replace menu|title|intercept)" | head -8
