# Drand48 [![Build Status](https://travis-ci.org/JeffersonLab/drand48.svg?branch=master)](https://travis-ci.org/JeffersonLab/drand48)

Nim implementation of the standard unix drand48 pseudo random number generator.

All the routines work by generating a sequence of 48-bit integer values, Xi , 
according to the linear congruential formula:

Xn+1 = (aXn + c) mod m   n>= 0

The parameter m = 248; hence 48-bit integer arithmetic is performed. 
The multiplier value a and the addend value c are given by:

a = 0x5DEECE66D = 0c273673163155
c = 0xB = oc13

The value returned by any of the drand48() is computed by first
generating the next 48-bit Xi in the sequence. Then the appropriate
number of bits, according to the type of data item to be returned, are
copied from the high-order (leftmost) bits of Xi and transformed into the returned value.
 
The drand48() function stores the last 48-bit Xi generated in an 
internal buffer; that is why they must be initialised prior to being invoked. 

The initializer function srand48() sets the high-order 32 bits of Xi to 
the low-order 32 bits contained in its argument. The low-order 16 bits 
of Xi are set to the arbitrary value 0x330E .

The initializer function seed48() sets the value of Xi to the 48-bit value 
specified in the argument array. The seed can be set with the 48-bit
seed split into four 12-bit chunks, or as a 48-bit int.

There are functions savern12() and savern48() that returns the current random number seed.

