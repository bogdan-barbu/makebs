MakeBS
======

*MakeBS* is a modular, flexible, general-purpose build system for UNIX development environments.

Usage
-----

In order to build a project with *MakeBS*, the build system must reside in a subdirectory named `makebs`. The project's root
directory should contain one or more wrapper makefiles, used as *make*'s input when building, which include `makebs/main.mk`.

By default, *MakeBS* will attempt to build a project in the current directory, but it supports multiple binary trees. The
`BUILD_DIR` macro informs *MakeBS* where it should attempt to build.

### Project Directory Structure

* `include`: Header files
* `makebs`: Build system
* `src`: Source code

### Targets

The following targets are supported by *MakeBS*:

* `all`: Builds a project
* `install`: Builds and installs a project
* `clean`: Deletes binary files
* `distclean`: Deletes generated files
* `TAGS`: Generates a tagsfile

### Examples

The following examples show *MakeBS* in action.

#### Building a simple program

##### makefile

    C_OBJ_FILES ::= foo.o bar.o
    C_BIN_FILES ::= foobar

    include makebs/main.mk

    $(BIN_DIR)/$(C_BIN_FILES): $(C_OBJ_FILES:%=$(OBJ_DIR)/%)

#### Building a more complex program

##### makefile

    FOO_DIR ::= foo
    FOO_OBJ_FILES ::= $(FOO_DIR)/foo.o
    FOO_BIN_FILE ::= $(FOO_DIR)/foo
    foo_LINK ::= mylib1

    C_OBJ_FILES ::= $(FOO_OBJ_FILES)
    C_BIN_FILES ::= $(FOO_BIN_FILE)

    BAR_DIR ::= bar
    BAR_OBJ_FILES ::= $(BAR_DIR)/bar.o
    BAR_BIN_FILE ::= $(BAR_DIR)/bar
    bar_LINK ::= mylib2

    C_OBJ_FILES += $(BAR_OBJ_FILES)
    C_BIN_FILES += $(BAR_BIN_FILE)

    include makebs/main.mk

    $(BIN_DIR)/$(FOO_BIN_FILE): $(FOO_OBJ_FILES:%=$(OBJ_DIR)/%)
    $(BIN_DIR)/$(BAR_BIN_FILE): $(BAR_OBJ_FILES:%=$(OBJ_DIR)/%)

#### Building a library

##### makefile

    C_OBJ_FILES ::= foo.o
    LIB_FILES ::= $(LIB_FILE)

    include makebs/main.mk

    $(LIB_DIR)/$(LIB_FILE): $(C_OBJ_FILES:%=$(OBJ_DIR)/%)
