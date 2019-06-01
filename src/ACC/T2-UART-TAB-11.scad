// Holder for matching FTDI 6 pin 0.1" header to the T2 case debug
// uart cutout

// External base measurements
// debug uart case cutout
cutoutXMM =  3.53;
cutoutYMM = 19.00;
cutoutZMM = 21.09;  // To base of male header

// FTDI 6 pin 0.1" measurements
serialXMM =  2.58;
serialYMM = 15.28;
serialZMM = 14.05;

// Internal base measurements
serialExtraYMM = 0.0;

cutoutReliefYMM = 1.0;

flangeExtraXMM = 0.35;
flangeExtraYMM = 3.00;
flangeExtraZMM = 0.00;

shoeBoxZMM = 2.50;

grabTabXMM = 10.00;
grabTabYMM =  3.00;
grabTabZMM = 14.00;

module handle() {
     effectiveCutoutYMM = cutoutYMM-cutoutReliefYMM;
     init = [cutoutXMM,effectiveCutoutYMM,cutoutZMM];
     hdr =  [serialXMM,serialYMM+serialExtraYMM,serialZMM];

     flangeSize=[2*flangeExtraXMM,
                 cutoutYMM+flangeExtraYMM,
                 cutoutZMM+flangeExtraZMM];
     flangePos=[cutoutXMM,-flangeExtraYMM/2,0];

     wireBoxSize = [cutoutXMM,
                    .90*hdr[1],
                    .70*(cutoutZMM-serialZMM)];
     wireBoxPos = [0,(hdr[1]-wireBoxSize[1])/2,serialZMM];

     shoeBoxSize = [cutoutXMM+2*flangeExtraXMM,effectiveCutoutYMM,shoeBoxZMM];
     shoeBoxPos = [0,0,cutoutZMM];

     wireExitSize = [cutoutXMM,
                     wireBoxSize[1]/3,
                     (cutoutZMM-shoeBoxSize[2]-0*serialZMM)-wireBoxSize[2]];
     wireExitPos = [0,wireBoxPos[1]+wireBoxSize[1]-wireExitSize[1],cutoutZMM-wireBoxSize[2]];

     grabTabSize = [grabTabXMM,grabTabYMM,grabTabZMM];
     grabTabPos = [cutoutXMM+flangeSize[0]-grabTabSize[0],
                   wireExitPos[1]-grabTabSize[1],
                   cutoutZMM];

     grabTabNotchSize = [grabTabXMM/2,grabTabYMM,grabTabZMM/3];
     grabTabNotchPos = [cutoutXMM+flangeSize[0]-grabTabNotchSize[0],
                   wireExitPos[1]-grabTabNotchSize[1],
                   cutoutZMM+shoeBoxZMM];

     difference () {
          union() {
               cube(init);
               translate(flangePos)
                    cube(flangeSize);
               translate(shoeBoxPos)
                    cube(shoeBoxSize);
               translate(grabTabPos)
                    cube(grabTabSize);
          }
          cube(hdr);
          translate(wireBoxPos)
               cube(wireBoxSize);
          translate(wireExitPos)
               cube(wireExitSize);
          translate(grabTabNotchPos)
               #cube(grabTabNotchSize);

     }
}

rotate([0,90,0])
handle();

