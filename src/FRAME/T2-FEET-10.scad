// T2-FEET-10+ snap connectors for tile<->frame attachment
// Copyright (C) 2019 The T2 Tile Project
// Licensed under GPL-3

m3ScrewNominalHoleDiameterMM=3.4 + 0.1;  // According to internet, plus 0.1
m3ScrewNominalHeadDiameterMM=5.5 + 0.2;  // 5.5: socket cap; 5.6: narrow 'cheese head'; 5.7: +socket cap; 6: philips
m3ScrewNominalHeadCountersinkDepthMM=3.0 + 0.1;  // Makes 25mm screw into 28mm

m3ScrewNominalThreadOuterDiameterMM=2.9; // Outer edge of thread
m3ScrewNominalThreadInnerDiameterMM=2.7; // Inner edge of thread

m3NutNominalHeightMM = 2.5;
m3NutNominalDiameterMM = 5.41;

// Parameters
fOuterShellDiameterMM=10;
fOuterShellHeightMM=8;
fOuterShellBaseThicknessMM=2;
fInnerShellDiameterMM=6;

fmDefaultClearanceMM=0.2;

// Derived measurements
m3ScrewNominalHoleRadiusMM=m3ScrewNominalHoleDiameterMM/2;
m3ScrewNominalHeadRadiusMM=m3ScrewNominalHeadDiameterMM/2;

m3ScrewNominalThreadOuterRadiusMM=m3ScrewNominalThreadOuterDiameterMM/2;
m3ScrewNominalThreadInnerRadiusMM=m3ScrewNominalThreadInnerDiameterMM/2;

m3NutNominalRadiusMM = m3NutNominalDiameterMM/2;

fOuterShellRadiusMM=fOuterShellDiameterMM/2;
fInnerShellRadiusMM=fInnerShellDiameterMM/2;

module hexNut(removeHole=true) {
     difference() {
          cylinder(h=m3NutNominalHeightMM,
                   r1 = m3NutNominalRadiusMM,
                   r2 = m3NutNominalRadiusMM,
                   center = false,
                   $fn=6);
          cylinder(h=m3NutNominalHeightMM,
                   r1 = m3ScrewNominalThreadRadiusMM,
                   r2 = m3ScrewNominalThreadRadiusMM,
                   $fn=128);
     }
}

module femaleConnector() {
     difference() {
          cylinder(h=fOuterShellHeightMM, r1 = fOuterShellRadiusMM, r2 = fOuterShellRadiusMM, center = false, $fn=128);
          // hex shaft
          translate([0,0,fOuterShellBaseThicknessMM]) {
               cylinder(h=fOuterShellHeightMM-fOuterShellBaseThicknessMM,
                        r1 = m3NutNominalRadiusMM,
                        r2 = m3NutNominalRadiusMM,
                        center = false,
                        $fn=6);
          }

          // screw shaft
               cylinder(h=fOuterShellBaseThicknessMM,
                        r1 = m3ScrewNominalThreadOuterRadiusMM,
                        r2 = m3ScrewNominalThreadOuterRadiusMM,
                        center = false,
                        $fn=128);
     }
}

femaleConnector();
