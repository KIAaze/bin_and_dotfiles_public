#!/usr/bin/env python3

# 12 visually indistinguishable balls:
# - 11 identical ones
# - 1 with a different mass
# Find ball with different mass, using only 3 comparative scale measurements.

N = 12
alpha = 1.5
N_known = 0
relative_weight = 0 # -1: lighter, 0: unknown, +1: heavier

N_unknown = (N-1) - N_known
all_balls = [[1,True] for i in range(N_known)] + [[1,False] for i in range(N_unknown)] + [[alpha,False]]

def getComplementaryIndices(idx_list):
  return [idx for idx in range(N) if idx not in idx_list]

def getBallsFromIndex(idx_list):
  return [all_balls[idx] for idx in idx_list]

def getBallsFromIndex_complementary(idx_list):
  return [all_balls[idx] for idx in range(N) if idx not in idx_list]

def countAllBalls():
  return countBalls(range(N))

def countBalls(idx_list):
  N_known = 0
  for (mass,known) in getBallsFromIndex(idx_list):
    if known:
      N_known += 1
  N_unknown = N - N_known
  return (N_known, N_unknown)

def calculateMass(idx_list):
  mass_total = 0
  mass_known = 0
  N_known = 0
  for (mass,known) in getBallsFromIndex(idx_list):
    mass_total += mass
    if known:
      mass_known += mass
      N_known += 1
  return (mass_total, mass_known, N_known)

def setToKnown(idx_list):
  for idx in idx_list:
    all_balls[idx][1] = True

def setToUnknown(idx_list):
  for idx in idx_list:
    all_balls[idx][1] = False
  
def compare(left_balls, right_balls):
  global relative_weight
  left_balls = list(left_balls)
  right_balls = list(right_balls)
  if len(left_balls) == len(right_balls):
    (mass_total_left, mass_known_left, N_known_left) = calculateMass(left_balls)
    (mass_total_right, mass_known_right, N_known_right) = calculateMass(right_balls)
    if mass_total_left == mass_total_right:
      setToKnown(left_balls + right_balls)
    else:
      if N_known_left + N_known_right == len(left_balls) + len(right_balls) - 1:
        setToKnown(range(N))
      elif relative_weight == 0:
        if N_known_left == len(left_balls):
          setToKnown(getComplementaryIndices(left_balls + right_balls))
          if mass_total_left > mass_total_right:
            relative_weight = -1
          else:
            relative_weight = 1
        elif N_known_right == len(right_balls):
          setToKnown(getComplementaryIndices(left_balls + right_balls))
          if mass_total_left > mass_total_right:
            relative_weight = 1
          else:
            relative_weight = -1
      elif relative_weight == 1:
        if mass_total_left > mass_total_right:
          if N_known_left == len(left_balls) - 1:
            setToKnown(range(N))
          else:
            setToKnown(right_balls)
        else:
          if N_known_right == len(right_balls) - 1:
            setToKnown(range(N))
          else:
            setToKnown(left_balls)        
      elif relative_weight == -1:
        if mass_total_left > mass_total_right:
          if N_known_right == len(right_balls) - 1:
            setToKnown(range(N))
          else:
            setToKnown(left_balls)
        else:
          if N_known_left == len(left_balls) - 1:
            setToKnown(range(N))
          else:
            setToKnown(right_balls)
  (N_known, N_unknown) = countAllBalls()
  if N_known == N - 1:
    setToKnown(range(N))
  (N_known, N_unknown) = countAllBalls()
  return (N_known, N_unknown)

left_balls = []
right_balls = []
for K in range(1,N//2+1):
  print(K)
  #for k_left in range(1,K):
    
#print(__globals__)
print('relative_weight =',relative_weight, 'all_balls =',all_balls)
print(compare(range(0,3),range(3,6)))
print('relative_weight =',relative_weight, 'all_balls =',all_balls)
print(compare(range(0,3),[9,10,11]))
print('relative_weight =',relative_weight, 'all_balls =',all_balls)

#print(compare([9],[10]))
#print('relative_weight =',relative_weight, 'all_balls =',all_balls)

print(compare([9],[11]))
print('relative_weight =',relative_weight, 'all_balls =',all_balls)
