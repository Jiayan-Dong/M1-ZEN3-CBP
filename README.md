# M1-ZEN3-CBP


## APPLE M1
The performance core (firestorm) uses a CBP similar to Intel Skylake (TAGE); however, it uses mainly the target address of the branch to update PHR.
We notice that all the taken branches will modify PHR, whether they're unconditional or indirect.
Performance core: PHR 100 bits, using all 32 bits in the target address. At least bits 2 to 6 of the branch address are used to update the PHR (a potential dedicated PHR).
Efficiency core: PHR 60 bits.


## AMD ZEN 3
From the previous confirmed information, Zen 2 is using a percepton as L1 CBP and a TAGE as L2 CBP.
But from the current experiment, it seems Zen 3 doesn't have a GHR.
We notice that only the conditional taken branch will modify PHR.
And a strange behavior observed is that it seems to only use the lower 6 bits in the branch to determine whether to shift a 0 or 1 into PHR.
We observe that in the case of 0x3b to 0x3f (0b11 1011 to 0b11 1111), the branch shifts 1 into PHR. Otherwise, the branch shifts 0 into PHR. (Check script 11).