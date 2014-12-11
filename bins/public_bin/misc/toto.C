check_job()
{
  jobname=$1;
  var=`bjobs -J $jobname 2>&1 | grep -c "not found"`;
  if [ $var -eq 0 ]
    then
    if [ $VERBOSE == "1" ]
      then echo "$jobname does exist.";
  fi;
  return 1;
  else
    if [ $VERBOSE == "1" ]
      then echo "$jobname does not exist.";
  fi;
  return 0;
  fi
}
