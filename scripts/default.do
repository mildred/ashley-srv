src="src/$(basename "$1.c")"
redo-ifchange "$src"
cc "$src" -o $3
