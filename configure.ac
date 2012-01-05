AC_INIT(rtx-create.pl, 1.0)

AC_PROG_INSTALL
AC_ARG_VAR([PERL],[Perl interpreter command])
AC_PATH_PROG([PERL], [perl], [not found])
if test "$PERL" = 'not found'; then
	AC_MSG_ERROR([cannot use $PACKAGE_NAME without perl])
fi

AC_PREFIX_DEFAULT([/opt/rt4])

dnl BIN_OWNER
AC_ARG_WITH(bin-owner,
	    AC_HELP_STRING([--with-bin-owner=OWNER],
	    		   [user that will own RT binaries (default root)]),
            BIN_OWNER=$withval,
            BIN_OWNER=root)
AC_SUBST(BIN_OWNER)

PERL_LIBDIR=${prefix}$(echo ${libdir} | sed -e 's/\${.\+}//g')
AC_SUBST(PERL_LIBDIR)

AC_CONFIG_FILES([
	Makefile
	rtx-create.pl
])

AC_OUTPUT

