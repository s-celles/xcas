builddir := "builddir"

# Show available recipes
default:
    @just --list

# Configure the build
setup:
    meson setup {{builddir}}

# Build xcas
build:
    meson compile -C {{builddir}}

# Run xcas
run: build
    ./{{builddir}}/src/xcas

# Clean build directory
clean:
    rm -rf {{builddir}}

# Reconfigure from scratch
reconfigure: clean setup

# Install xcas
install:
    meson install -C {{builddir}}
