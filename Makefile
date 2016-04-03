build:
	gcc Main.m Base.m String.m Error.m Program.m Mesh.m Texture.m -o Program -Wall -Wextra -Wshadow -Wformat=2 -Wpedantic -Wconversion -Wunreachable-code -std=c11 -fconstant-string-class=String -ggdb -lobjc -lSDL2 -lGL -lGLEW -lSDL2_image

run:
	./Program

debug:
	gdb ./Program
