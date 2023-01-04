build-web:
	flutter build web
	rm -r app/
	mkdir app/
	cp -R build/web/ app/
	@echo "\n\tDon't forget to change the base href to /osrs_rng/app/\n"