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

DEP_FILES += $(C_OBJ_FILES:.o=.d)
BIN_FILES += $(C_BIN_FILES)

SEARCH += -o -name \*.[ch]

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(DEP_DIR)/$(*D) $(@D)
	printf '$(@D)/' >$(TMP_FILE)
	$(CC) $(CFLAGS) -M $< -I $(INC_DIR) >>$(TMP_FILE)
	cp $(TMP_FILE) $(DEP_FILE)
	sed -f $(MAKEBS_DIR)/prereq2target.sed $(TMP_FILE) >>$(DEP_FILE)
	$(CC) $(CFLAGS) -c -o $@ $< -I $(INC_DIR)

$(C_BIN_FILES:%=$(BIN_DIR)/%):
	mkdir -p $(@D)
	$(CC) $(LDFLAGS) -o $@ $^ -L $(LIB_DIR) $($(@F)_LINK:%=-l %)
