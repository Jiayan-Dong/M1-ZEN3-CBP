# CPU:

12th Gen Intel(R) Core(TM) i9-12900

Microarchitecture: Alder Lake

# Results:

PC bits that are used   :   B[23:0]     ->  24   lower bits

BTB Tag bits            :   B[23:16]    ->  8    bits   (They are not folded and all them are used independently!)

BTB Index bits          :   B[15](?) + B[14:5]     ->  11   bits = 2048 sets

BTB Offset bits         :   B[4:0]      ->  5    bits


Number of ways per set  :   6

BTB Size                :   2048 sets * 6 ways/set = 12k entries

Possible branches using the BTB for the target prediction: direct calls, branches, and conditional branches