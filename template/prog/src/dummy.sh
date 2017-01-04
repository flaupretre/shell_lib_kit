#
# Template for a file containing your library functions
#
# For an example of a library built from shell_lib_kit, see the sysfunc library
# at https://github.com/flaupretre/sysfunc.
#
# This dummy file must be removed once you have used it as a model to
# implement your own script(s).
#============================================================================

#=============================================================================
# Section: Dummy features
#
# <Note> In this example the section string (short section name) is
#   'dum'. It is a random string which will, by convention, prefix every
#   function defined in this file.
#=============================================================================

##----------------------------------------------------------------------------
# Dummy check
#
# More info about this function. This
# can be contained on several lines. Mark paragraph end with an empty line.
#
#- This will appear in a bulleted list
#- This too...
#
# Args: none
# or
# Args:
#	$1: <text>
#	$2: ...
# or
#	$*: ...
# Returns: <What does this function return ?>
# Displays: Nothing|A lot...
#----------------------------------------------------------------------------

function @SLK_PREFIX@_dum_check
{
echo 'Check OK !'

}

##----------------------------------------------------------------------------
# Another function...
#
# Args:
#	$*: String to display
# Returns: Always 0
# Displays: Something *very* interesting
#-----------------------------------------------------------------------------

function @SLK_PREFIX@_dum_cmd2
{
echo "Received <$*>..."
}

#=============================================================================
