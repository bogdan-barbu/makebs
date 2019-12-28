# MakeBS is a build system for UNIX development environments.
# Copyright 2019 Bogdan Barbu
#
# This file is part of MakeBS.
#
# MakeBS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MakeBS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MakeBS.  If not, see <https://www.gnu.org/licenses/>.

MAKEBS_DIR ::= makebs

BUILD_DIR ?= .
INSTALL_DIR ::= /usr/local

INC_DIR ::= include
SRC_DIR ::= src

DEP_DIR ::= $(BUILD_DIR)/dep
OBJ_DIR ::= $(BUILD_DIR)/obj
LIB_DIR ::= $(BUILD_DIR)/lib
BIN_DIR ::= $(BUILD_DIR)/bin

TMP_FILE = /tmp/$(*F).d
DEP_FILE = $(DEP_DIR)/$*.d

all:

include $(MAKEBS_DIR)/c.mk
include $(MAKEBS_DIR)/docbook.mk
include $(MAKEBS_DIR)/fortran.mk

.PHONY: all
all: $(BIN_FILES:%=$(BIN_DIR)/%) $(LIB_FILES:%=$(LIB_DIR)/%)

.PHONY: install
install: all
	for i in $(INC_DIR) $(LIB_DIR) $(BIN_DIR); \
	do                                         \
	    if test -d "$$i";                      \
	    then                                   \
	        cp -R -i "$$i" $(INSTALL_DIR);     \
	    fi                                     \
	done

.PHONY: clean
clean: ; rm -rf $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR)

.PHONY: distclean
distclean: clean ; rm -rf $(DEP_DIR) tags

.PHONY: TAGS
TAGS: ; find . ! -name \* $(SEARCH) | xargs ctags

-include $(DEP_FILES:%=$(DEP_DIR)/%))

$(LIB_DIR)/%.a:
	mkdir -p $(@D)
	$(AR) $(ARFLAGS) $@ $?
