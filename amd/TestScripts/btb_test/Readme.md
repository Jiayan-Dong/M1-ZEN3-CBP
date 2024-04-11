# Results:

Intel 13th Gen


P-core (Goldencove):

PC Bits that are used   : B[23:0]   ->  24 bits

BTB Tag bits            : B[23:15]  ->  9 bits

BTB Index bits          : B[14:5]   ->  10 bits

BTB Offset bits         : B[4:0]    ->  5 bits

Number of ways per set  : 12


E-core (Gracemont):

PC Bits that are used   : B[24:0]   ->  25 bits

BTB Tag bits            : B[24:15]  ->  10 bits

BTB Index bits          : B[14:5]   ->  10 bits

BTB Offset bits         : B[4:0]    ->  5  bits

Number of ways per set  : 5


Intel 6th Gen (Skylake)

PC Bits that are used   : B[29:0]   ->  30 bits

BTB Tag bits            : B[29:14]  ->  16 bits

BTB Index bits          : B[13:5]   ->  9  bits

BTB Offset bits         : B[4:0]    ->  5  bits

Number of ways per set  : 8 (far jump can only use at most 4 ways per set?)