build:
	gcc Main.c Error.c Program.c Mesh.c -o OpenGL_Test -ggdb -std=c11 -Wall -Wextra -Wshadow -lGL -lGLEW -lSDL2 -lSDL2 -lm

run:
	./OpenGL_Test

debug:
	gdb ./OpenGL_Test
