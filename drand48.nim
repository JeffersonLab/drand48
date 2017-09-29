##
## drand48
##
## Nim implementation of the standard unix drand48 pseudo random number generator.
##
## All the routines work by generating a sequence of 48-bit integer values, Xi , 
## according to the linear congruential formula:
## 
## Xn+1 = (aXn + c) mod m   n>= 0
## 
## The parameter m = 248; hence 48-bit integer arithmetic is performed. Unless lcong48() is 
## invoked, the multiplier value a and the addend value c are given by:
## 
## a = 0x5DEECE66D = 0c273673163155
## c = 0xB = oc13
## 
## The value returned by any of the drand48() is computed by first
## generating the next 48-bit Xi in the sequence. Then the appropriate
## number of bits, according to the type of data item to be returned, are
## copied from the high-order (leftmost) bits of Xi and transformed into the returned value.
##  
## The drand48() function stores the last 48-bit Xi generated in an 
## internal buffer; that is why they must be initialised prior to being invoked. 
## 
## The initialiser function srand48() sets the high-order 32 bits of Xi to 
## the low-order 32 bits contained in its argument. The low-order 16 bits 
## of Xi are set to the arbitrary value 0x330E .
## 
## The initialiser function seed48() sets the value of Xi to the 48-bit value 
## specified in the argument array. The low-order 16 bits of Xi are set to the 
## low-order 16 bits of seed16v[0]. The mid-order 16 bits of Xi are set to the 
## low-order 16 bits of seed16v[1]. The high-order 16 bits of Xi are set to the
## low-order 16 bits of seed16v[2]. 
## There is a function savern48() that returns the current random number seed.
##

# The multiplier a = 0x5 DE EC E6 6D = 0c2736 7316 3155
const
  m1 = 0
  m2 = 0c2736
  m3 = 0c7316
  m4 = 0c3155
  incr = 0c13
  twom12 = 1.0/4096.0

# The seed
var
  l1 = 0
  l2 = 0
  l3 = 0
  l4 = 0x330E


proc drand48*(): float =
  ## Return a random number in the interval [0,1)
  var i1 = l1*m4 + l2*m3 + l3*m2 + l4*m1
  var i2 = l2*m4 + l3*m3 + l4*m2
  var i3 = l3*m4 + l4*m3
  var i4 = l4*m4 + incr
  l4 = i4 and 4095
  i3 = i3 + (i4 shr 12)
  l3 = i3 and 4095
  i2 = i2 + (i3 shr 12)
  l2 = i2 and 4095
  l1 = (i1 + (i2 shr 12)) and 4095
  result = twom12*(float(l1)+
                   twom12*(float(l2)+
                           twom12*(float(l3)+
                                   twom12*(float(l4)))))


proc split12(lseed: int): array[4,int] =
  ## Split a 48bit int into four 12bit chunks
  var iseed = lseed
  result[3] = iseed and 4095
  iseed = iseed shr 12
  result[2] = iseed and 4095
  iseed = iseed shr 12
  result[1] = iseed and 4095
  iseed = iseed shr 12
  result[0] = iseed and 4095

  
proc build48(iseed: array[4,int]): int =
  ## Build a 48bit int from four 12bit chunks
  result = iseed[0] and 4095
  result = result shl 12
  result = result or (iseed[1] and 4095)
  result = result shl 12
  result = result or (iseed[2] and 4095)
  result = result shl 12
  result = result or (iseed[3] and 4095)
  #echo "build48= ", result
  

proc srand48*(lseed: int) =
  ## Set the seed. Will only use the lowest 32bits.
  ##
  ## Will take the lowest 32 bits of `lseed` and use them for the upper
  ## 32 bits of the seed. The lowest 16 bits of the seed are set to 0x330E
  ##
  var iseed = lseed and 0xFFFFFFFF
  iseed = (iseed shl 16) or 0x330E
  #echo "srand48: iseed= ", iseed
  let seed = split12(iseed)
  l1 = seed[0]
  l2 = seed[1]
  l3 = seed[2]
  l4 = seed[3]
  #echo "input seed= ", @[l1,l2,l3,l4]

  
proc srand48*(iseed: array[4,int]) = 
  ## Set the seed. Can be even or odd
  srand48(build48(iseed))


proc seed12*(iseed: array[4,int]) = 
  ## Set the seed using four 12bit chunks. Can be even or odd
  l1 = iseed[0]
  l2 = iseed[1]
  l3 = iseed[2]
  l4 = iseed[3]


proc seed48*(iseed: int) = 
  ## Set the 48bit seed. Can be even or odd
  let lseed = split12(iseed)
  l1 = lseed[0]
  l2 = lseed[1]
  l3 = lseed[2]
  l4 = lseed[3]


proc savern12*(): array[4,int] =
  ## Return the seed in 12bit chunks
  result = [l1, l2, l3, l4]


proc savern48*(): int =
  ## Return the seed
  return build48([l1,l2,l3,l4])



#------------------------------------------------------------------------
when isMainModule:
  proc getTimeOrigin(Lt: int, traj: int): int =
    ## Return the randomly shift time-origin
    srand48(traj)
    for i in 1..20:
      discard drand48()
    result = int(float(Lt)*drand48())

  ## Test the rng
  echo "t_origin= ", getTimeOrigin(256, 1000)

  var seed = 11
  echo "initial seed= ", repr(seed)
  srand48(seed)
  for n in 1..10:
    echo "ran[", n, "]= ", drand48()

  echo "final seed= ", repr(savern12())
