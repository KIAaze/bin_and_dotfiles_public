initialize()
{
    #make sure karm is running before continuing
    while [ ! $KARM_DCOPID ]
    do
        echo "KArm not running"
        KARM_DCOPID=`dcop | grep karm`
    done
    echo "Karm running"
    
    #make sure karm is hidden and all tasks stopped
    KARM_DCOPID=`dcop | grep karm`
    if [ $KARM_DCOPID ]
    then
        #hide karm window
        dcop $KARM_DCOPID karm-mainwindow#1 hide
        #export CSV file to ~/karm.log
        dcop $KARM_DCOPID KarmDCOPIface exportcsvfile ~/karm.log "" "" 0 true true " " ""
        #display all tasks :)
        LIST=`awk '{ FS=" " }{ print $1 }' ~/karm.log | sort -u`
    else
        echo "KArm not running"
    fi
}

########################

initialize
LIST="toto"
LIST+=" titi"
LIST+=" tata"
echo $LIST
for i in $LIST;
do
echo $i
done
