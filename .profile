#-------------------------------------------------------------------------------
#
# SOURCE FILE: .profile
#
# DESCRIPTION: LES environment setup script.
#
# NOTE(S): This script should *not* be edited.
#          Any customizations should be made in the ".profile.local" script 
#          instead, which this script calls.
#
#-------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Display a setup message for the user.
# ------------------------------------------------------------------------------

echo
echo "Setting up the LES cv_upg environment..."
echo

# ------------------------------------------------------------------------------
# Setup the LES directory.
# ------------------------------------------------------------------------------

LESDIR=/opt/redprairie/cv_upgrade/les
export LESDIR

# ------------------------------------------------------------------------------
# Setup the MOCA environment name and registry pathname.
# ------------------------------------------------------------------------------

MOCA_ENVNAME=cv_upg

# The following would be the precedence for setting the MOCA_REGISTRY:
#
# The third (Windows) or fifth (Unix) field from the rptab file if one is provided
# LESDIR/data/registry.<users logname>
# LESDIR/data/registry.<environment name>
# LESDIR/data/registry

IFS=:
while read var1 var2 var3 var4 var5
do
    if [[ "$var1" = "$MOCA_ENVNAME" ]]; then

        if [[ "$var5" != "" ]]; then
            MOCA_REGISTRY=$var5
        elif [[ "$LOGNAME" != "" &&  -f $LESDIR/data/registry.$LOGNAME ]]; then
            MOCA_REGISTRY=$LESDIR/data/registry.$LOGNAME
        elif [[ -f $LESDIR/data/registry.$MOCA_ENVNAME ]]; then
            MOCA_REGISTRY=$LESDIR/data/registry.$MOCA_ENVNAME
        else
            MOCA_REGISTRY=$LESDIR/data/registry
        fi;

        break;
    fi;
done < "/etc/rptab"

export MOCA_ENVNAME MOCA_REGISTRY

# ------------------------------------------------------------------------------
# Setup the Java runtime environment directory.
# ------------------------------------------------------------------------------

JREDIR=/usr/lib/jvm/java-11-openjdk-11.0.17.0.8-2.el8_2.x86_64
export JREDIR

# ------------------------------------------------------------------------------
# Setup the Java Development Kit directory.
# ------------------------------------------------------------------------------

JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.17.0.8-2.el8_2.x86_64
export JAVA_HOME

# ------------------------------------------------------------------------------
# Setup the default language and locale.
# ------------------------------------------------------------------------------

LANG=C
LOCALE_ID=US_ENGLISH
export LANG LOCALE_ID

# ------------------------------------------------------------------------------
# Setup the search path.
# ------------------------------------------------------------------------------

SYSPATH=$PATH

PATH=/usr/local/bin

case $(/usr/bin/uname -s | /usr/bin/tr -d - | /usr/bin/tr '[A-Z]' '[a-z]') in 
sunos)	PATH=$PATH:/opt/SUNWspro/bin:/usr/xpg4/bin:/usr/ccs/bin:/bin
        ;;
esac

if [ -d ${JREDIR}/bin ]; then
    PATH=$JREDIR/bin:$PATH
fi

if [ "${JAVA_HOME}" != "" ]; then
    if [ -d ${JAVA_HOME}/bin ]; then
        PATH=$JAVA_HOME/bin:$PATH
    fi
fi

PATH=$PATH:$LESDIR/bin:$LESDIR/scripts
export PATH

# ------------------------------------------------------------------------------
# Setup the cd search path.
# ------------------------------------------------------------------------------

CDPATH=.:$LESDIR:$LESDIR/src/appsrc:$LESDIR/src/libsrc:$LESDIR/src
export CDPATH

# ------------------------------------------------------------------------------
# Setup the search path for shared libraries.
# ------------------------------------------------------------------------------

case $(/usr/bin/uname -s | /usr/bin/tr -d - | /usr/bin/tr '[A-Z]' '[a-z]') in 
aix)	LIBPATH=$LIBPATH:/usr/local/lib
        LIBPATH=$LIBPATH:$LESDIR/lib
        LIBPATH=$LIBPATH:$JREDIR/lib
        LIBPATH=$LIBPATH:$JREDIR/lib/j9vm
	export LIBPATH
	;;
darwin) DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/lib
        DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$LESDIR/lib
        DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$JREDIR/lib
        DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$JREDIR/lib/server
        export DYLD_LIBRARY_PATH
        ;;
linux)	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
        LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LESDIR/lib
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JREDIR/lib
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JREDIR/lib/server
	export LD_LIBRARY_PATH
	;;
sunos)  LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
        LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LESDIR/lib
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JREDIR/lib/sparcv9
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JREDIR/lib/sparcv9/server
	export LD_LIBRARY_PATH
        ;;
esac

# -----------------------------------------------------------------------------
# Setup terminal line settings.
# ------------------------------------------------------------------------------

case $(/usr/bin/uname -s | /usr/bin/tr -d - | /usr/bin/tr '[A-Z]' '[a-z]') in 
sunos)  stty erase "^H" kill "^K"
        ;;
esac

# ------------------------------------------------------------------------------
# Setup ksh variables.
# ------------------------------------------------------------------------------

umask 002

ENV=$LESDIR/.kshrc
PS1="`/usr/bin/tput bold 2>/dev/null`cv_upg `/usr/bin/tput sgr0 2>/dev/null`\${PWD#$LESDIR}:>"
EDITOR=vi
VISUAL=vi
export ENV PS1 EDITOR VISUAL

# ------------------------------------------------------------------------------
# Setup the environment for each product.
# ------------------------------------------------------------------------------


if [ -r /opt/redprairie/cv_upgrade/dcs/.profile ]; then
    . /opt/redprairie/cv_upgrade/dcs/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/dcs/.profile"
fi
if [ -r /opt/redprairie/cv_upgrade/slotting/.profile ]; then
    . /opt/redprairie/cv_upgrade/slotting/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/slotting/.profile"
fi
if [ -r /opt/redprairie/cv_upgrade/seamles/.profile ]; then
    . /opt/redprairie/cv_upgrade/seamles/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/seamles/.profile"
fi
if [ -r /opt/redprairie/cv_upgrade/mtf/.profile ]; then
    . /opt/redprairie/cv_upgrade/mtf/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/mtf/.profile"
fi
if [ -r /opt/redprairie/cv_upgrade/sal/.profile ]; then
    . /opt/redprairie/cv_upgrade/sal/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/sal/.profile"
fi
if [ -r /opt/redprairie/cv_upgrade/mcs/.profile ]; then
    . /opt/redprairie/cv_upgrade/mcs/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/mcs/.profile"
fi
if [ -r /opt/redprairie/cv_upgrade/moca/.profile ]; then
    . /opt/redprairie/cv_upgrade/moca/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/moca/.profile"
fi
if [ -r /opt/redprairie/cv_upgrade/ems/.profile ]; then
    . /opt/redprairie/cv_upgrade/ems/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/ems/.profile"
fi
if [ -r /opt/redprairie/cv_upgrade/reporting/.profile ]; then
    . /opt/redprairie/cv_upgrade/reporting/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/reporting/.profile"
fi
if [ -r /opt/redprairie/cv_upgrade/parcelhandler/.profile ]; then
    . /opt/redprairie/cv_upgrade/parcelhandler/.profile
else
    echo "ERROR: Could not read /opt/redprairie/cv_upgrade/parcelhandler/.profile"
fi


# ------------------------------------------------------------------------------
# Change the directory back to $LESDIR in case something changed it.
# ------------------------------------------------------------------------------

cd $LESDIR

# ------------------------------------------------------------------------------
# Setup any local ksh stuff.
# ------------------------------------------------------------------------------

if [ -r $LESDIR/.profile.local ]; then
    . $LESDIR/.profile.local
fi

# ------------------------------------------------------------------------------
# Setup any user ksh stuff.
# ------------------------------------------------------------------------------

if [ -r $LESDIR/.profile.$LOGNAME ]; then
    . $LESDIR/.profile.$LOGNAME
fi

# ------------------------------------------------------------------------------
# Append the original system path to the local path.
# ------------------------------------------------------------------------------

PATH=$PATH:$SYSPATH

# ------------------------------------------------------------------------------
# Setup the class path, ensuring LES is at the front of the class path
# ------------------------------------------------------------------------------

CLASSPATH=$LESDIR/mtfclient/lib/*:$CLASSPATH
CLASSPATH=$LESDIR/mtfclient/build/classes:$CLASSPATH
CLASSPATH=$LESDIR/javalib/*:$CLASSPATH
CLASSPATH=$LESDIR/lib/*:$CLASSPATH
CLASSPATH=$LESDIR/build/classes:$CLASSPATH
export CLASSPATH

# ------------------------------------------------------------------------------
# Post profile executions.
# ------------------------------------------------------------------------------
if [ -r /opt/redprairie/cv_upgrade/mtf/.post.profile ]; then
    . /opt/redprairie/cv_upgrade/mtf/.post.profile
fi
