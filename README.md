# M1-ZEN3-CBP

## APPLE M1
The performance core (firestorm) uses a CBP similar to Intel Skylake(TAGE), however it uses mainly the target address of the branch to update PHR.
We notice that all the taken branch will modify PHR even it's unconditional or indirect branch. 
Performance core: PHR 100 bits, using all 32 bit in target address. At least bit 2 to bit 6 of branch address are used to update PHR (a potential dedicated PHR).
Efficieny core: PHR 60 bits.

## AMD ZEN 3
From the previous confimred information, Zen 2 is using a percepton as L1 CBP and a TAGE as L2 CBP.
But from the current experiment, it seems Zen 3 don't have a GHR.
We notice that only the conditional taken branch will modify PHR.
And a strange behavior observred is it seems only using lower 6 bit in branch to determine to shift a 0 or 1 into PHR.
We observe that in case of 0x3b to 0x3f (0b11 1011 to 0b11 1111), the branch shifts 1 into PHR. Otherwise, the branch shifts 0 into PHR.