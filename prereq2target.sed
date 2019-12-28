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

s/#.*//
s/[^:]*: *//
s/ *\\$//
/^$/d
s/^ *//
s/$/:/
