#! /bin/sh
echo "removing previous logfiles..."
rm added_cbmroot.log errors_cbmroot.log added_MyBuild_32.log errors_MyBuild_32.log

echo "RESTORING cbmroot and MyBuild_32 (without replacing existing files)"
echo "extracting cbmroot.tar.gz"
tar -xkvzf cbmroot.tar.gz 1>>added_cbmroot.log 2>>errors_cbmroot.log
# tar -xkvzf cbmroot.tar.gz --wildcards "*.C" 1>>added_cbmroot.log 2>>errors_cbmroot.log
# tar -xkvzf cbmroot.tar.gz --wildcards "*.c" 1>>added_cbmroot.log 2>>errors_cbmroot.log
# tar -xkvzf cbmroot.tar.gz --wildcards "*.cpp" 1>>added_cbmroot.log 2>>errors_cbmroot.log
# tar -xkvzf cbmroot.tar.gz --wildcards "*.h" 1>>added_cbmroot.log 2>>errors_cbmroot.log
# tar -xkvzf cbmroot.tar.gz --wildcards "*.cxx" 1>>added_cbmroot.log 2>>errors_cbmroot.log
# tar -xkvzf cbmroot.tar.gz --wildcards "*.txt" 1>>added_cbmroot.log 2>>errors_cbmroot.log
echo "extracting MyBuild_32.tar.gz"
tar -xkvzf MyBuild_32.tar.gz 1>>added_MyBuild_32.log 2>>errors_MyBuild_32.log
# tar -xkvzf MyBuild_32.tar.gz --wildcards "*.C" 1>>added_MyBuild_32.log 2>>errors_MyBuild_32.log 
# tar -xkvzf MyBuild_32.tar.gz --wildcards "*.c" 1>>added_MyBuild_32.log 2>>errors_MyBuild_32.log 
# tar -xkvzf MyBuild_32.tar.gz --wildcards "*.cpp" 1>>added_MyBuild_32.log 2>>errors_MyBuild_32.log 
# tar -xkvzf MyBuild_32.tar.gz --wildcards "*.h" 1>>added_MyBuild_32.log 2>>errors_MyBuild_32.log 
# tar -xkvzf MyBuild_32.tar.gz --wildcards "*.cxx" 1>>added_MyBuild_32.log 2>>errors_MyBuild_32.log 
# tar -xkvzf MyBuild_32.tar.gz --wildcards "*.txt" 1>>added_MyBuild_32.log 2>>errors_MyBuild_32.log 
echo "LOGS:"
echo "added_cbmroot.log"
echo "errors_cbmroot.log"
echo "added_MyBuild_32.log"
echo "errors_MyBuild_32.log"
  
# echo "Copying files from /u/$USER_flast/u/$USER_flast to /u/$USER_flast..."
# false | cp -irv ~/u/$USER_flast/* ~/; echo
