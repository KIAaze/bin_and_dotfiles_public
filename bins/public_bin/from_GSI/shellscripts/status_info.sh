#! /bin/bash

# 1600 MC
# 1600 params
# 1600 STS
# 4800 total =24 *200

get_values()
{
wc -l $filename

echo "=== MC: ==="
##########################################
#MC (2*8=16)
##########################################
#ML_JP_S
echo "=== #ML_JP_S ==="
grep -c /s/$USER_flast/much_large.geo/data_Jpsi/Pluto.noUrqmd.auau.25gev.centr.params. $filename
grep -c /s/$USER_flast/much_large.geo/data_Jpsi/Pluto.noUrqmd.auau.25gev.centr.mc. $filename
#ML_JP_B
echo "=== #ML_JP_B ==="
grep -c /s/$USER_flast/much_large.geo/data_Jpsi/noPluto.Urqmd.auau.25gev.centr.params. $filename
grep -c /s/$USER_flast/much_large.geo/data_Jpsi/noPluto.Urqmd.auau.25gev.centr.mc. $filename
##########################################
#ML_PP_S
echo "=== #ML_PP_S ==="
grep -c /s/$USER_flast/much_large.geo/data_Psi_prime/Pluto.noUrqmd.auau.25gev.centr.params. $filename
grep -c /s/$USER_flast/much_large.geo/data_Psi_prime/Pluto.noUrqmd.auau.25gev.centr.mc. $filename
#ML_PP_B
echo "=== #ML_PP_B ==="
grep -c /s/$USER_flast/much_large.geo/data_Psi_prime/noPluto.Urqmd.auau.25gev.centr.params. $filename
grep -c /s/$USER_flast/much_large.geo/data_Psi_prime/noPluto.Urqmd.auau.25gev.centr.mc. $filename
##########################################
#MHL_JP_S
echo "=== #MHL_JP_S ==="
grep -c /s/$USER_flast/much_half_large.geo/data_Jpsi/Pluto.noUrqmd.auau.25gev.centr.params. $filename
grep -c /s/$USER_flast/much_half_large.geo/data_Jpsi/Pluto.noUrqmd.auau.25gev.centr.mc. $filename
#MHL_JP_B
echo "=== #MHL_JP_B ==="
grep -c /s/$USER_flast/much_half_large.geo/data_Jpsi/noPluto.Urqmd.auau.25gev.centr.params. $filename
grep -c /s/$USER_flast/much_half_large.geo/data_Jpsi/noPluto.Urqmd.auau.25gev.centr.mc. $filename
##########################################
#MHL_PP_S
echo "=== #MHL_PP_S ==="
grep -c /s/$USER_flast/much_half_large.geo/data_Psi_prime/Pluto.noUrqmd.auau.25gev.centr.params. $filename
grep -c /s/$USER_flast/much_half_large.geo/data_Psi_prime/Pluto.noUrqmd.auau.25gev.centr.mc. $filename
#MHL_PP_B
echo "=== #MHL_PP_B ==="
grep -c /s/$USER_flast/much_half_large.geo/data_Psi_prime/noPluto.Urqmd.auau.25gev.centr.params. $filename
grep -c /s/$USER_flast/much_half_large.geo/data_Psi_prime/noPluto.Urqmd.auau.25gev.centr.mc. $filename

echo "=== STS: ==="
##########################################
#STS (8)
##########################################
#ML_JP_S
echo "=== #ML_JP_S ==="
grep -c /s/$USER_flast/much_large.geo/data_Jpsi/Pluto.noUrqmd.auau.25gev.centr.sts_reco. $filename
#ML_JP_B
echo "=== #ML_JP_B ==="
grep -c /s/$USER_flast/much_large.geo/data_Jpsi/noPluto.Urqmd.auau.25gev.centr.sts_reco. $filename
##########################################
#ML_PP_S
echo "=== #ML_PP_S ==="
grep -c /s/$USER_flast/much_large.geo/data_Psi_prime/Pluto.noUrqmd.auau.25gev.centr.sts_reco. $filename
#ML_PP_B
echo "=== #ML_PP_B ==="
grep -c /s/$USER_flast/much_large.geo/data_Psi_prime/noPluto.Urqmd.auau.25gev.centr.sts_reco. $filename
##########################################
#MHL_JP_S
echo "=== #MHL_JP_S ==="
grep -c /s/$USER_flast/much_half_large.geo/data_Jpsi/Pluto.noUrqmd.auau.25gev.centr.sts_reco. $filename
#MHL_JP_B
echo "=== #MHL_JP_B ==="
grep -c /s/$USER_flast/much_half_large.geo/data_Jpsi/noPluto.Urqmd.auau.25gev.centr.sts_reco. $filename
##########################################
#MHL_PP_S
echo "=== #MHL_PP_S ==="
grep -c /s/$USER_flast/much_half_large.geo/data_Psi_prime/Pluto.noUrqmd.auau.25gev.centr.sts_reco. $filename
#MHL_PP_B
echo "=== #MHL_PP_B ==="
grep -c /s/$USER_flast/much_half_large.geo/data_Psi_prime/noPluto.Urqmd.auau.25gev.centr.sts_reco. $filename
}

echo "============================================="
echo "============================================="
val=`cat ok.log | wc -l`
status=`expr 100 \* $val / 3200`
echo "status=$status%"
echo "status=$status%" >&2
echo "ok.log should have at least 3200 lines (=all MC+params files)"
wc -l ok.log
wc -l missing.log
wc -l corrupt.log
wc -l cleanup.sh
echo "============================================="
echo "============================================="

echo "============================================="
filename="ok.log"
get_values
echo "============================================="
filename="missing.log"
get_values
echo "============================================="
filename="corrupt.log"
get_values
echo "============================================="
filename="cleanup.sh"
get_values
echo "============================================="
