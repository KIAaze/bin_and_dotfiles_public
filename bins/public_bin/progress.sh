#!/bin/bash
# to check remote progress:
# ssh $HOST_SF '( cd $SOMEPATH && progress.sh )'
# :)

Ndebug=$(ls -1 debug/*.o | wc -l)
Nrelease=$(ls -1 release/*.o | wc -l)
Ntotal=$(ls -1 *.h | wc -l)

echo "Ndebug/Ntotal = $Ndebug/$Ntotal"
echo "Nrelease/Ntotal = $Nrelease/$Ntotal"
