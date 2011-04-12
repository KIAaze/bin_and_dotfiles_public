#!/bin/bash

        DCOPID=`dcop | grep karm`
        if [ $DCOPID ]
        then
                VERS=`dcop $DCOPID KarmDCOPIface version`
                echo "KArm version is $VERS"
                #export CSV file to karm.log
                dcop $DCOPID KarmDCOPIface exportcsvfile ~/karm.log "" "" 0 true true " " ""
                #display all tasks :)
                awk '{ FS=" " }{ print $1 }' ~/karm.log | sort -u
                #stop all tasks :)
                awk '{ FS=" " }{ print $1 }' ~/karm.log | sort -u | xargs -n1 dcop $DCOPID KarmDCOPIface stoptimerfor
        else
                echo "KArm not running"
        fi

        DCOPID=`dcop | grep karm`
        if [ $DCOPID ]
        then
                dcop $DCOPID KarmDCOPIface
        else
                echo "KArm not running"
        fi

        DCOPID=`dcop | grep kdevelop`
        if [ $DCOPID ]
        then
            dcop $DCOPID KDevProject
            if [ $? = 0 ]
            then
                    CURRENT_PROJECT=`dcop $DCOPID KDevProject projectName`
                    echo $CURRENT_PROJECT
            else
                    echo "no KDevProject open"
            fi
        else
                echo "KDevelop not running"
        fi

#         add task for current project
        DCOPID=`dcop | grep karm`
        if [ $DCOPID ]
        then
                dcop $DCOPID KarmDCOPIface addTask $CURRENT_PROJECT
        else
                echo "KArm not running"
        fi

#check if task exists
        ID=`dcop $DCOPID KarmDCOPIface taskIdFromName $CURRENT_PROJECT`
        if [ $ID ]
        then
            echo "task does exist"
        else
            echo "task does not exist"
        fi

        ID=`dcop $DCOPID KarmDCOPIface taskIdFromName foobar`
        if [ $ID ]
        then
            echo "task does exist"
        else
            echo "task does not exist"
        fi
