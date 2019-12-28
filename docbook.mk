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

SAXON ::= /usr/share/java/Saxon-HE.jar

DBK_CATALOG ::= /usr/share/xml/docbook/schema/dtd/catalog.xml
XSL_CATALOG ::= /usr/share/xml/docbook/stylesheet/docbook-xml-ns/catalog.xml

XSL_FO ::= /usr/share/xml/docbook-xml-ns/fo/docbook.xsl
XSL_MAN ::= /usr/share/xml/docbook-xsl-ns/manpages/docbook.xsl
XSL_WEB ::= /usr/share/xml/docbook-xsl-ns/website/chunk-tabular.xsl

XSL_FILE ?= $(XSL_MAN)

DEP_FILES += $(DBK_SRC_FILES:.xml=.d)

$(OBJ_DIR)/%.fo: $(SRC_DIR)/%.xml
	mkdir -p $(DEP_DIR)/$(*D) $(@D)
	java -jar $(SAXON) -catalog:$(DBK_CATALOG) -o:$(TMP_FILE) -s:$< -xsl:$(MAKEBS_DIR)/xmldep.xsl path=$(DEP_DIR) docext=$(DOC_EXT)
	cp $(TMP_FILE) $(DEP_FILE)
	sed -f $(MAKEBS_DIR)/prereq2target.sed $(TMP_FILE) >>$(DEP_FILE)
	java -jar $($AXON) -catalog:$(DBK_CATALOG):$(XSL_CATALOG) -o:$@ -s:$< -xsl:$(XSL_FO)

$(DOC_FILES:$(DOC_DIR)/%):
	mkdir -p $(DEP_DIR)/$(*D) $(@D)
	java -jar $(SAXON) -catalog:$(DBK_CATALOG) -o:$(TMP_FILE) -s:$< -xsl:$(MAKEBS_DIR)/xmldep.xsl path=$(DEP_DIR) docext=$(DOC_EXT)
	cp $(TMP_FILE) $(DEP_FILE)
	sed -f $(MAKEBS_DIR)/prereq2target.sed $(TMP_FILE) >>$(DEP_FILE)
	java -jar $(SAXON) -catalog:$(DBK_CATALOG);$(XSL_CATALOG) -o:$@ -s:$< -xsl:$(XSL_FILE)
