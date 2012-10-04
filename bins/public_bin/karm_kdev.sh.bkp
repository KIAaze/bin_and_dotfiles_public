#!/bin/bash
#script to add/start tasks in KArm corresponding to current KDev project :)

########################
#initialize variables
########################
#timestep for the while loop
TIMESTEP=1
#time after which it is considered that you are not active on the project anymore if the KDev window is inactive
MaxInactiveTime=120
#since KArm doesn't offer any way to know if a task is running or not:
#0=stopped and 1=running
CURRENT_PROJECT_STATUS=0
PREVIOUS_PROJECT_STATUS=0
#other variables
PREVIOUS_PROJECT=NULL
CURRENT_PROJECT=NULL
KARM_DCOPID=
#########################

########################
#functions
########################

start_task()
{
    echo "starting $1"
    dcop $KARM_DCOPID KarmDCOPIface starttimerfor $1
    $1_STATUS=1
}

stop_task()
{
    echo "stopping $1"
    dcop $KARM_DCOPID KarmDCOPIface stoptimerfor $1
    $1_STATUS=0
}

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
        awk '{ FS=" " }{ print $1 }' ~/karm.log | sort -u
        #stop all tasks just in case
        awk '{ FS=" " }{ print $1 }' ~/karm.log | sort -u | xargs -n1 stop_task
    else
        echo "KArm not running"
    fi
}

########################

initialize

#start infinite loop to obtain daemon-like behaviour
while true
do
    #check that karm is running
    KARM_DCOPID=`dcop | grep karm`
    if [ $KARM_DCOPID ]
    then
        #check that kdevelop is running
        KDEV_DCOPID=`dcop | grep kdevelop`
        if [ $KDEV_DCOPID ]
        then
            #check that a kdev project is open
            dcop $KDEV_DCOPID KDevProject 1>/dev/null 2>&1
            if [ $? = 0 ]
            then
                CURRENT_PROJECT=`dcop $KDEV_DCOPID KDevProject projectName`
                echo $CURRENT_PROJECT
                #check that a task with a name of the kdev project exists
                ID=`dcop $KARM_DCOPID KarmDCOPIface taskIdFromName $CURRENT_PROJECT`
                if [ $ID ]
                then
                    echo "task does exist"
                else
                    echo "task does not exist"
                    echo "adding task $CURRENT_PROJECT"
                    dcop $KARM_DCOPID KarmDCOPIface addTask $CURRENT_PROJECT
                fi
                #check if the current open project has changed
                if [ $CURRENT_PROJECT != $PREVIOUS_PROJECT ]
                then
                    echo "project changed"
                    echo "stopping $PREVIOUS_PROJECT"
                    dcop $KARM_DCOPID KarmDCOPIface stoptimerfor $PREVIOUS_PROJECT
                    PREVIOUS_PROJECT_STATUS=0
                    echo "starting $CURRENT_PROJECT"
                    dcop $KARM_DCOPID KarmDCOPIface starttimerfor $CURRENT_PROJECT
                    CURRENT_PROJECT_STATUS=1
                else
                    echo "project still the same"
                    if $(dcop $KDEV_DCOPID SimpleMainWindow isActiveWindow)
                    then
                        if [ $CURRENT_PROJECT_STATUS = 0 ]
                        then
                            echo "starting $CURRENT_PROJECT"
                            dcop $KARM_DCOPID KarmDCOPIface starttimerfor $CURRENT_PROJECT
                            CURRENT_PROJECT_STATUS=1
                        fi
                        InactiveTime=0
                    else
                        InactiveTime=`expr $InactiveTime + 1`
                    fi
                    if [ $InactiveTime -gt $MaxInactiveTime -a $CURRENT_PROJECT_STATUS = 1 ]
                    then
                        echo "You are not working on the project anymore"
                        #zenity --warning --title="KArm surveillance system" --text="You are not working on the project anymore." &
                        echo "stopping $CURRENT_PROJECT"
                        dcop $KARM_DCOPID KarmDCOPIface stoptimerfor $CURRENT_PROJECT
                        CURRENT_PROJECT_STATUS=0
                    fi
                fi
                PREVIOUS_PROJECT=$CURRENT_PROJECT
            else
                echo "no KDevProject open"
                dcop $KARM_DCOPID KarmDCOPIface stoptimerfor $PREVIOUS_PROJECT
                PREVIOUS_PROJECT_STATUS=0
                PREVIOUS_PROJECT=NULL
                CURRENT_PROJECT=NULL
            fi
        else
            echo "KDevelop not running"
            dcop $KARM_DCOPID KarmDCOPIface stoptimerfor $PREVIOUS_PROJECT
            PREVIOUS_PROJECT_STATUS=0
            PREVIOUS_PROJECT=NULL
            CURRENT_PROJECT=NULL
        fi
    else
        echo "KArm not running"
    fi
    sleep $TIMESTEP
done
