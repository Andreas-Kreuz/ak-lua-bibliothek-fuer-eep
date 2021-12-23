/* eslint-disable max-len */
export const mySvg = `
  <svg id="svg" xmlns="http://www.w3.org/2000/svg" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ev="http://www.w3.org/2001/xml-events" style="overflow: hidden" width="100%" viewBox="0 0 963 908">
    <title id="svgTitle">Die-Moderne-EEP-17</title>
    <desc id="svgDesc">EEP Gleisplan</desc>
    <defs id="style">
        <!-- style -->
        <style type="text/css" id="css-track-colors">
              svg {
                --Eisenbahn-color: #ff0000;
                --Strassenbahn-color: #a9a9a9;
                --Strasse-color: #808080;
                --Wasserwege-color: #0000ff;
                --Steuerstrecken-color: #800080;
                --GBS-color: #a52a2a;
                --Kamera-color: #00ff00;
                --Hintergrund-color: #ffffff;
              }
            </style>

        <style type="text/css" id="css-marker-colors">
              svg {
                --Eisenbahn-marker-color: none;
                --Strassenbahn-marker-color: none;
                --Strasse-marker-color: none;
                --Wasserwege-marker-color: none;
                --Steuerstrecken-marker-color: none;
                --GBS-marker-color: none;
                --Kamera-marker-color: none;
              }
            </style>

        <style type="text/css" id="css-strokeWidth-variables">
              svg {
                --normal-stroke-width: 0.38145px;
                --narrow-stroke-width: 0.19072px;
              }
            </style>

        <style type="text/css" id="css-fontSize-variables">
              svg {
                --normal-font-size: 1.20478px;
              }
            </style>

        <style type="text/css">
              /*  */
              svg {
                background: var(--Hintergrund-color);
                border: 0; /* 1px dotted #3983ab; */
                padding: 0;
                box-sizing: border-box;
                /* transform: scale(1,-1);     		not useful as it would mirror the text, too */
              }

              /* Texte für Signale, Weichen etc. */
              text {
                font-size: var(--normal-font-size);
                font-family: Arial;
                stroke-width: 0;
              }

              /* not used */
              textPath {
              }

              text.GleisID {
                text-anchor: start;
              }

              text.CurveType {
                text-anchor: end;
              }

              text.Stil {
                text-anchor: end;
                font-style: italic;
              }

              text.Hoehe {
                text-anchor: start;
                font-style: italic;
              }

              text.WeicheText {
              }

              text.text-anchor-end {
                text-anchor: end;
              }

              .Signal text,
              .Kontakt text {
                text-anchor: middle;
              }

              #Kamera text {
                text-anchor: start;
              }

              /* Box zur Anzeige der verwendeten Groesse der Anlage */
              .box {
                stroke-width: 0.1;
                stroke: black;
                fill: none;
                stroke-dasharray: 1;
              }

              /* Zusätzliche Markierung des Zentrums */
              #center {
                stroke-width: 0;
                stroke: grey;
                fill: grey;
              }

              /* Individuelle Formatierung je Gleissystem */

              .Eisenbahn {
                stroke-width: var(--normal-stroke-width);
                stroke: var(--Eisenbahn-color);
                fill: none;
                marker-start: url(#EisenbahnMarkerCircle);
                marker-end: url(#EisenbahnMarkerArrow);
                /* stroke-dasharray: 0.2 0.4; */ /* Schwellenabstand von 60cm */
              }
              #EisenbahnMarkerCircle,
              #EisenbahnMarkerArrow {
                fill: var(--Eisenbahn-marker-color);
              }
              .Eisenbahn text {
                fill: var(--Eisenbahn-color);
              }

              .Strassenbahn {
                stroke-width: var(--normal-stroke-width);
                stroke: var(--Strassenbahn-color);
                fill: none;
                marker-start: url(#StrassenbahnMarkerCircle);
                marker-end: url(#StrassenbahnMarkerArrow);
              }
              #StrassenbahnMarkerCircle,
              #StrassenbahnMarkerArrow {
                fill: var(--Strassenbahn-marker-color);
              }
              .Strassenbahn text {
                fill: var(--Strassenbahn-color);
              }

              .Strasse {
                stroke-width: var(--normal-stroke-width);
                stroke: var(--Strasse-color);
                fill: none;
                marker-start: url(#StrasseMarkerCircle);
                marker-end: url(#StrasseMarkerArrow);
              }
              #StrasseMarkerCircle,
              #StrasseMarkerArrow {
                fill: var(--Strasse-marker-color);
              }
              .Strasse text {
                fill: var(--Strasse-color);
              }

              .Wasserwege {
                stroke-width: var(--narrow-stroke-width);
                stroke: var(--Wasserwege-color);
                fill: none;
                marker-start: url(#WasserwegeMarkerCircle);
                marker-end: url(#WasserwegeMarkerArrow);
              }
              #WasserwegeMarkerCircle,
              #WasserwegeMarkerArrow {
                fill: var(--Wasserwege-marker-color);
              }
              .Wasserwege text {
                fill: var(--Wasserwege-color);
              }

              .Steuerstrecken {
                stroke-width: var(--narrow-stroke-width);
                stroke: var(--Steuerstrecken-color);
                fill: none;
                marker-start: url(#SteuerstreckenMarkerCircle);
                marker-end: url(#SteuerstreckenMarkerArrow);
              }
              #SteuerstreckenMarkerCircle,
              #SteuerstreckenMarkerArrow {
                fill: var(--Steuerstrecken-marker-color);
              }
              .Steuerstrecken text {
                fill: var(--Steuerstrecken-color);
              }

              .GBS {
                stroke-width: var(--narrow-stroke-width);
                stroke: var(--GBS-color);
                fill: none;
                marker-start: url(#GBSMarkerCircle);
                marker-end: url(#GBSMarkerArrow);
              }
              #GBSMarkerCircle,
              #GBSMarkerArrow {
                fill: var(--GBS-marker-color);
              }
              .GBS text {
                fill: var(--GBS-color);
              }

              #Kamera {
                stroke-width: calc(var(--normal-stroke-width) * 1.5);
                stroke: var(--Kamera-color);
                fill: none;
                /* marker-start: url(#KameraMarkerCircle); */
                marker-end: url(#KameraMarkerArrow);
              }
              #KameraMarkerCircle,
              #KameraMarkerArrow {
                fill: var(--Kamera-marker-color);
              }
              #Kamera text {
                fill: var(--Kamera-color);
              }

              /* Gleisobjekte werden als transparente Flächen in der Farbe der jeweiligen Gleissysteme dargestellt */

              .Gleisobjekt * {
                stroke: none;
                marker-start: none;
                marker-end: none;
              }

              .Gleisobjekt rect {
                fill-opacity: 0; /* hide it */
                filter: url(#blur); /* #blur #dilate #dilate+blur */
              }
              .Gleisobjekt path {
                fill-opacity: 0.2;
                filter: url(#blur); /* #blur #dilate #dilate+blur */
              }

              .Gleisobjekt .Eisenbahn {
                fill: var(--Eisenbahn-color);
              }

              .Gleisobjekt .Strassenbahn {
                fill: var(--Strassenbahn-color);
              }

              .Gleisobjekt .Strasse {
                fill: var(--Strasse-color);
              }

              .Gleisobjekt .Wasserwege {
                fill: var(--Wasserwege-color);
              }

              .Gleisobjekt .Steuerstrecken {
                fill: var(--Steuerstrecken-color);
              }

              .Gleisobjekt .GBS {
                fill: var(--GBS-color);
              }

              /* Besondere Objekte */

              .Prellbock {
                marker-end: url(#Prellbock);
              }

              /* Symbole */

              #SymbolSignal,
              #SymbolPreSignal,
              #SymbolFStart,
              #SymbolFZiel,
              #SymbolKontakt {
                marker-start: none;
                marker-end: none;
                stroke-width: var(--narrow-stroke-width);
                fill: none;
              }

              /* Individuelle Formatierung je Gleisstil */

              .stil-1353 {
                /* Gleis mit Betonschwellen */
              }

              .stil-5146 {
                /* Farm track */
                stroke: brown;
              }

              .unsichtbar {
                /* unsichtbare Gleisstile */
                stroke-dasharray: 0.6 0.2;
              }

              .virtual {
                /* virtuelle Gleisstile */
                stroke-dasharray: 0.3 0.2;
                stroke-opacity: 0.5;
              }

              .inactive {
                /* inaktive Gleisstile */
                stroke-opacity: 0.5;
              }

              /* versteckte Elemente */

              .hidden,
              .hiddenZ {
                display: none !important;
              }
              /*  */
            </style>
    </defs>

    <defs id="symbols">
        <!-- Filters, Symbols and Markers -->
        <!-- Dilate and blur Gleisobjekte -->
        <filter id="dilate">
            <feMorphology operator="dilate" radius="3" />
        </filter>
        <filter id="blur">
            <feGaussianBlur stdDeviation="0.2" />
        </filter>
        <filter id="dilate+blur">
            <feMorphology operator="dilate" radius="2" />
            <feGaussianBlur stdDeviation="1" />
        </filter>

        <!-- Use of symbols requires translate(-10 0) to move the origin M 0 0 to the correct position -->
        <!-- <path d="M 0 0 L 4 3 A 12 12  0 0 1  -4 3 z" /> -->
        <!-- Kreissegment -->
        <!-- <path d="M 0 0 L 0 1.2 L 4.8 1.2 L 4.8 5.8 L -4.8 5.8 L -4.8 1.2 L 0 1.2" /> -->
        <!-- Box -->
        <!-- <path d="M 0 0 L 0 0.9" /><circle cx="0" cy="1.5" r="0.6" /> -->
        <!-- Linie mit Kreis -->
        <symbol id="SymbolSignal" width="20" height="10" viewBox="-10 0 20 10">
            <path d="M 0 0 L 0 0.9  M 0.25 0.9 L 0.6 1.25 L 0.6 1.75 L 0.25 2.1  L -0.25 2.1 L -0.6 1.75 L -0.6 1.25 L -0.25 0.9 Z" />
            <!-- Linie mit Achteck -->
        </symbol>
        <symbol id="SymbolPreSignal" width="20" height="10" viewBox="-10 0 20 10">
            <path d="M 0 0 L 0 0.9" />
            <circle cx="0" cy="1.3" r="0.4" />
            <!-- Linie mit kleinem Kreis -->
        </symbol>
        <symbol id="SymbolKontakt" width="20" height="10" viewBox="-10 0 20 10">
            <path d="M 0 0 L 0 0.9  M 0 0.9 L 0.7 2.1 L -0.7 2.1 Z" />
            <!-- Linie mit Dreieck -->
        </symbol>
        <symbol id="SymbolFStart" width="20" height="10" viewBox="-10 0 20 10">
            <path d="M 0 0 L 0 1.1  M 0 1.1 L 0.41 0.83 L 0.29 1.3 L 0.67 1.6 L 0.17 1.65 L 0 2.1  L -0.17 1.65 L -0.67 1.6 L -0.29 1.3 L -0.41 0.83 Z" />
            <!-- Linie mit 5er Stern -->
        </symbol>
        <symbol id="SymbolFZiel" width="20" height="10" viewBox="-10 0 20 10">
            <path d="M 0 0 L 0 0.9  M 0 0.9 L -1.2 0.9 L -1.2 2.1 L 0 2.1 Z  M -0.6 0.9 L -0.6 2.1  M 0 1.5 L -1.2 1.5" />
            <!-- Linie mit Flagge -->
        </symbol>

        <!-- Prellbock: Querbalken -->
        <marker id="Prellbock" markerWidth="2" markerHeight="4" refX="2" refY="2" orient="auto">
            <rect x="0" y="0" width="2" height="4" />
        </marker>

        <!-- We need individual markers to be able to apply CSS -->
        <marker id="EisenbahnMarkerCircle" markerWidth="5" markerHeight="5" refX="2" refY="3">
            <circle cx="3" cy="3" r="1" />
        </marker>
        <marker id="StrassenbahnMarkerCircle" markerWidth="5" markerHeight="5" refX="2" refY="3">
            <circle cx="3" cy="3" r="1" />
        </marker>
        <marker id="StrasseMarkerCircle" markerWidth="5" markerHeight="5" refX="2" refY="3">
            <circle cx="3" cy="3" r="1" />
        </marker>
        <marker id="WasserwegeMarkerCircle" markerWidth="5" markerHeight="5" refX="2" refY="3">
            <circle cx="3" cy="3" r="1" />
        </marker>
        <marker id="SteuerstreckenMarkerCircle" markerWidth="5" markerHeight="5" refX="2" refY="3">
            <circle cx="3" cy="3" r="1" />
        </marker>
        <marker id="GBSMarkerCircle" markerWidth="5" markerHeight="5" refX="2" refY="3">
            <circle cx="3" cy="3" r="1" />
        </marker>
        <marker id="KameraMarkerCircle" markerWidth="5" markerHeight="5" refX="2" refY="3">
            <circle cx="3" cy="3" r="1" />
        </marker>

        <marker id="EisenbahnMarkerArrow" markerWidth="5" markerHeight="5" refX="2" refY="3" orient="auto">
            <path d="M0,1 L0,5 L3,3 L0,1" />
        </marker>
        <marker id="StrassenbahnMarkerArrow" markerWidth="5" markerHeight="5" refX="2" refY="3" orient="auto">
            <path d="M0,1 L0,5 L3,3 L0,1" />
        </marker>
        <marker id="StrasseMarkerArrow" markerWidth="5" markerHeight="5" refX="2" refY="3" orient="auto">
            <path d="M0,1 L0,5 L3,3 L0,1" />
        </marker>
        <marker id="WasserwegeMarkerArrow" markerWidth="5" markerHeight="5" refX="2" refY="3" orient="auto">
            <path d="M0,1 L0,5 L3,3 L0,1" />
        </marker>
        <marker id="SteuerstreckenMarkerArrow" markerWidth="5" markerHeight="5" refX="2" refY="3" orient="auto">
            <path d="M0,1 L0,5 L3,3 L0,1" />
        </marker>
        <marker id="GBSMarkerArrow" markerWidth="5" markerHeight="5" refX="2" refY="3" orient="auto">
            <path d="M0,1 L0,5 L3,3 L0,1" />
        </marker>
        <marker id="KameraMarkerArrow" markerWidth="5" markerHeight="5" refX="2" refY="3" orient="auto">
            <path d="M0,1 L0,5 L3,3 L0,1" />
        </marker>
    </defs>

    <g id="sutrackpSVG" class="svg-pan-zoom_viewport" transform="matrix(11.08704,0,0,11.08704,688.90212,-1333.59195)" style="transform: matrix(11.087, 0, 0, 11.087, 688.902, -1333.59)">
        <!-- hier werden dynamisch die weiteren svg-Elemente der EEP Anlage eingefügt -->
        <g id="Gleisobjekt" class="Gleisobjekt">
            <g id="GO13" class="Strasse height=2.53">
                <path d="M-20.02146 141.42479 L-20.02146 139.42479 L-11.02851 135.0514 L-9.02851 135.0514 L-6.68940 135.8597 L-2.31595 144.8527 L-2.31595 146.8527 L-11.29286 147.39146 L-13.29286 147.39146Z" />
            </g>
            <g id="GO24" class="Strasse height=2.53">
                <path d="M-27.23840 177.46009 L-27.23840 175.46009 L-18.26149 174.92133 L-16.26149 174.92133 L-9.53289 180.88800 L-9.53289 182.88800 L-18.52583 187.26139 L-20.52583 187.26139 L-22.86495 186.453Z" />
            </g>
            <g id="GO25" class="Strasse height=2.53">
                <path d="M-2.62907 169.31909 L-2.62907 167.31909 L3.33759 160.59049 L5.33759 160.59049 L9.71103 169.5834 L9.71103 171.5834 L8.90261 173.9225 L-0.09030 178.296 L-2.09030 178.296Z" />
            </g>
            <g id="GO26" class="Strasse height=2.53">
                <path d="M0.97110 184.59105 L0.97110 182.59105 L1.01416 178.6781 L6.90262 171.9225 L8.90261 171.9225 L11.65790 177.58804 L14.41318 183.2536 L14.41318 185.2536 L5.42023 189.62709 L3.42023 189.62709 L2.19567 187.10907Z" />
            </g>
            <g id="GO30" class="Strasse height=2.53">
                <path d="M-20.52583 187.2615 L-20.52583 185.2615 L-11.57595 184.8009 L-9.57595 184.8009 L-6.47147 187.18310 L-4.02234 192.21914 L-4.02234 194.21914 L-13.01529 198.59259 L-15.01529 198.59259 L-17.77056 192.92704Z" />
            </g>
            <g id="GO66" class="Strasse height=2.53">
                <path d="M-11.57595 186.8009 L-11.57595 184.8009 L-8.42842 183.27019 L-6.42842 183.27019 L-6.42842 185.27019 L-8.00218 186.03554 L-9.57595 186.8009Z" />
            </g>
            <g id="GO74" class="Strasse height=2.53">
                <path d="M-58.05872 165.76104 L-58.05872 163.76104 L-49.06579 159.3876 L-47.06579 159.3876 L-42.69235 168.38060 L-42.69235 170.38060 L-47.18881 172.56732 L-51.68528 174.75404 L-53.68528 174.75404Z" />
            </g>
            <g id="GO85" class="Strasse height=2.54">
                <path d="M-5.28 183.74 L-5.28 181.74 L-3.70617 180.97477 L-2.13234 180.20954 L-0.13234 180.20954 L-0.13234 182.20954 L-3.28000 183.74Z" />
            </g>
            <g id="GO86" class="Strasse height=2.53">
                <path d="M-2.13335 182.2088 L-2.13335 180.2088 L-0.55958 179.44344 L1.01417 178.67809 L3.01417 178.67809 L3.01417 180.67809 L-0.13335 182.2088Z" />
            </g>
            <g id="GO87" class="Strasse height=2.54">
                <path d="M-8.42765 185.27045 L-8.42765 183.27045 L-5.28 181.74 L-3.28000 181.74 L-3.28000 183.74 L-4.85382 184.50522 L-6.42765 185.27045Z" />
            </g>
            <g id="GO91" class="Strasse height=2.53">
                <path d="M-32.68201 174.2695 L-32.68201 172.2695 L-30.68201 172.2695 L-29.15130 175.41702 L-29.15130 177.41702 L-31.15130 177.41702 L-31.91665 175.84326Z" />
            </g>
            <g id="GO93" class="Strasse height=2.53">
                <path d="M-31.15131 177.4171 L-31.15131 175.4171 L-29.15131 175.4171 L-27.62060 178.56462 L-27.62060 180.56462 L-29.62060 180.56462 L-30.38595 178.99086Z" />
            </g>
            <g id="GO94" class="Strasse height=2.54">
                <path d="M-34.21 171.12 L-34.21 169.12 L-32.21 169.12 L-30.67954 172.26765 L-30.67954 174.26765 L-32.67954 174.26765 L-33.44477 172.69382Z" />
            </g>
            <g id="GO95" class="Strasse height=2.54">
                <path d="M-35.74 167.97 L-35.74 165.97 L-33.74 165.97 L-32.20954 169.11765 L-32.20954 171.11765 L-34.20954 171.11765 L-34.97477 169.54382Z" />
            </g>
            <g id="GO96" class="Strasse height=2.53">
                <path d="M-37.27411 164.8269 L-37.27411 162.8269 L-35.27411 162.8269 L-33.74341 165.97442 L-33.74341 167.97442 L-35.74341 167.97442 L-36.50876 166.40066Z" />
            </g>
            <g id="GO115" class="Strasse height=2.53">
                <path d="M-32.56854 143.63479 L-32.56854 141.63479 L-29.42101 140.10409 L-27.42101 140.10409 L-27.42101 142.10409 L-30.56854 143.63479Z" />
            </g>
            <g id="GO116" class="Strasse height=2.53">
                <path d="M-29.42101 142.1041 L-29.42101 140.1041 L-26.27348 138.57339 L-24.27348 138.57339 L-24.27348 140.57339 L-27.42101 142.1041Z" />
            </g>
            <g id="GO117" class="Strasse height=2.53">
                <path d="M-26.27348 140.5734 L-26.27348 138.5734 L-23.12595 137.04269 L-21.12595 137.04269 L-21.12595 139.04269 L-24.27348 140.5734Z" />
            </g>
            <g id="GO125" class="Strasse height=2.53">
                <path d="M-8.68940 137.8598 L-8.68940 135.8598 L-3.02385 133.10452 L2.64170 130.3493 L4.64170 130.3493 L9.01515 139.3422 L9.01515 141.3422 L3.97910 143.79133 L1.97910 143.79133 L-1.93377 143.7483Z" />
            </g>
            <g id="GO126" class="Strasse height=2.53">
                <path d="M-23.12595 139.0427 L-23.12595 137.0427 L-21.55218 136.27734 L-19.97842 135.51199 L-17.97842 135.51199 L-17.97842 137.51199 L-21.12595 139.0427Z" />
            </g>
            <g id="GO127" class="Strasse height=2.53">
                <path d="M-1.93377 143.7483 L-1.93377 141.7483 L0.06622 141.7483 L1.59693 144.89582 L1.59693 146.89582 L-0.40306 146.89582 L-1.16842 145.32206Z" />
            </g>
            <g id="GO128" class="Strasse height=2.53">
                <path d="M-0.40306 146.8958 L-0.40306 144.8958 L1.59693 144.8958 L3.12763 148.04332 L3.12763 150.04332 L1.12763 150.04332 L0.36228 148.46956Z" />
            </g>
            <g id="GO129" class="Strasse height=2.54">
                <path d="M2.66045 153.1876 L2.66045 151.1876 L4.66045 151.1876 L6.19091 154.33525 L6.19091 156.33525 L4.19091 156.33525Z" />
            </g>
            <g id="GO130" class="Strasse height=2.54">
                <path d="M1.13 150.04 L1.13 148.04 L3.13 148.04 L4.66045 151.18765 L4.66045 153.18765 L2.66045 153.18765Z" />
            </g>
            <g id="GO131" class="Strasse height=2.53">
                <path d="M4.18905 156.3384 L4.18905 154.3384 L6.18905 154.3384 L7.71976 157.48592 L7.71976 159.48592 L5.71976 159.48592 L4.95440 157.91216Z" />
            </g>
            <g id="GO132" class="Strasse height=2.53">
                <path d="M7.25047 162.6335 L7.25047 160.6335 L9.63265 157.529 L14.66869 155.07986 L16.66869 155.07986 L21.04214 164.0728 L21.04214 166.0728 L18.20936 167.45043 L15.37658 168.82807 L9.71103 171.5833 L7.71103 171.5833Z" />
            </g>
            <g id="GO133" class="Strasse height=2.53">
                <path d="M-25.53201 130.09375 L-25.53201 128.09375 L-16.53908 123.72030 L-14.53907 123.72030 L-11.78380 129.38584 L-9.02853 135.0514 L-9.02853 137.0514 L-17.97841 137.512 L-19.97841 137.512 L-23.08288 135.1298 L-24.30744 132.61177Z" />
            </g>
            <g id="GO134" class="Strasse height=2.53">
                <path d="M-43.96755 139.0593 L-43.96755 137.0593 L-34.97461 132.6859 L-32.97461 132.6859 L-31.75004 135.20392 L-30.52547 137.72194 L-30.52547 139.72194 L-30.56854 143.63479 L-36.457 150.3904 L-38.457 150.3904 L-41.21227 144.72485Z" />
            </g>
            <g id="GO135" class="Strasse height=2.53">
                <path d="M-38.56953 182.9707 L-38.56953 180.9707 L-33.53348 178.52156 L-31.53348 178.52156 L-27.62061 178.56459 L-20.86498 184.453 L-20.86498 186.453 L-26.53052 189.20832 L-32.19608 191.9636 L-34.19608 191.9636Z" />
            </g>
            <g id="GO136" class="Strasse height=2.53">
                <path d="M-49.06579 161.3877 L-49.06579 159.3877 L-43.40024 156.63237 L-40.56746 155.25473 L-37.73469 153.87709 L-35.73469 153.87709 L-35.27411 162.827 L-35.27411 164.827 L-37.6563 167.9314 L-42.69234 170.38053 L-44.69234 170.38053Z" />
            </g>
            <g id="GO137" class="Strasse height=2.53">
                <path d="M5.71976 159.48590 L5.71976 157.48590 L7.71976 157.48590 L9.25046 160.63342 L9.25046 162.63342 L7.25046 162.63342 L6.48511 161.05966Z" />
            </g>
            <g id="GO141" class="Strasse height=2.53">
                <path d="M-37.73463 155.8772 L-37.73463 153.8772 L-36.92623 151.5381 L-27.93328 147.16459 L-25.93328 147.16459 L-25.39451 156.14150 L-25.39451 158.14150 L-31.36118 164.87010 L-33.36118 164.87010Z" />
            </g>
            <g id="GO151" class="Strasse height=2.53">
                <path d="M-34.73956 158.0344 L-34.73956 156.0344 L-32.73956 156.0344 L-30.55283 160.53086 L-30.55283 162.53086 L-32.55283 162.53086 L-33.64619 160.28263Z" />
            </g>
            <g id="GO152" class="Strasse height=2.53">
                <path d="M-17.68233 142.23312 L-17.68233 140.23312 L-13.18587 138.0464 L-11.18587 138.0464 L-11.18587 140.0464 L-13.43410 141.13976 L-15.68233 142.23312Z" />
            </g>
            <g id="GO206" class="Strasse height=2.53">
                <path d="M16.17942 210.53289 L16.17942 208.53289 L18.58903 195.93560 L20.58903 195.93560 L25.35147 205.74010 L26.44378 207.98885 L27.53608 210.2376 L27.53608 212.2376 L18.5411 216.6068 L16.5411 216.6068Z" />
            </g>
            <g id="GO211" class="Strasse height=2.53">
                <path d="M23.3352 204.46830 L23.3352 202.46830 L32.33019 198.09907 L34.33019 198.09907 L34.33019 200.09907 L34.20191 211.27868 L29.70442 213.4633 L27.70442 213.4633Z" />
            </g>
            <g id="GO225" class="Strasse height=2.53">
                <path d="M2.52917 164.92963 L2.52917 162.92963 L4.52917 162.92963 L6.71589 167.42610 L6.71589 169.42610 L4.71589 169.42610 L3.62253 167.17786Z" />
            </g>
            <g id="GO226" class="Strasse height=2.53">
                <path d="M-18.36847 184.2663 L-18.36847 182.2663 L-16.12024 181.17293 L-13.87201 180.07957 L-11.87201 180.07957 L-11.87201 182.07957 L-16.36847 184.2663Z" />
            </g>
        </g>
        <g id="Strasse" class="Strasse">
            <g id="G3-30" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00001 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -34.06418 176.37400)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50000" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -34.06418 176.37400) scale(1 -1)">
                  30
                </text>
            </g>
            <g id="G3-34" class="Normal EEPCurve stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 A 121.66564 121.66564 0 0 1 21.61167 1.93484" transform="matrix(-0.96277 0.27029 0.27029 0.96277 40.46 126.72399)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="10.84905" y="-0.48467" transform="matrix(-0.96277 0.27029 0.27029 0.96277 40.46 126.72399) rotate(5.11592 10.84905 0.48467) scale(1 -1)">
                  34
                </text>
            </g>
            <g id="G3-63" class="Normal EEPCurve stil-3450 active height=2.64 sichtbar">
                <path d="M 0 0 A 18.73666 18.73666 0 0 1 18.73666 18.74398" transform="matrix(-0.89946 0.43699 0.43699 0.89946 -0.261 152.149)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="13.25140" y="-5.49042" transform="matrix(-0.89946 0.43699 0.43699 0.89946 -0.261 152.149) rotate(45.01118 13.25140 5.49042) scale(1 -1)">
                  63
                </text>
            </g>
            <g id="G3-64" class="Normal EEPCurve stil-3450 active height=1.54 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43727 0.89932 0.89932 -0.43727 -33.21 170.12)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43727 0.89932 0.89932 -0.43727 -33.21 170.12) scale(1 -1)">
                  64
                </text>
            </g>
            <g id="G3-76" class="Normal EEPCurve stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 L 13.52301 0" transform="matrix(-0.89945 0.43701 0.43701 0.89945 20.17597 134.4282)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="6.76150" y="0" transform="matrix(-0.89945 0.43701 0.43701 0.89945 20.17597 134.4282) scale(1 -1)">
                  76
                </text>
            </g>
            <g id="G3-110" class="Normal EEPCurve stil-3452 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 1.273 190.158)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 1.273 190.158) scale(1 -1)">
                  110
                </text>
            </g>
            <g id="G3-127" class="Normal EEPCurve stil-3458 active height=2.63 sichtbar">
                <path d="M 0 0 A 114.42303 114.42303 0 0 1 50.04257 11.52322" transform="matrix(-1 0 0 1 73.28 129.2)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="25.67608" y="-2.91801" transform="matrix(-1 0 0 1 73.28 129.2) rotate(12.96736 25.67608 2.91801) scale(1 -1)">
                  127
                </text>
            </g>
            <g id="G3-137" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -7.68940 136.8598)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -7.68940 136.8598) scale(1 -1)">
                  137
                </text>
            </g>
            <g id="G3-140" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00000 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 2.97910 142.79129)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50000" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 2.97910 142.79129) scale(1 -1)">
                  140
                </text>
            </g>
            <g id="G3-141" class="Normal EEPCurve stil-3458 active height=2.63 sichtbar">
                <path d="M 0 0 L 20 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 23.237 140.72299)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="10" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 23.237 140.72299) scale(1 -1)">
                  141
                </text>
            </g>
            <g id="G3-142" class="Weiche EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00000 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -22.08289 134.1298)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50000" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -22.08289 134.1298) scale(1 -1)">
                  142
                </text>
            </g>
            <g id="G3-143" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 8.01515 140.3422)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 8.01515 140.3422) scale(1 -1)">
                  143
                </text>
            </g>
            <g id="G3-144" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -0.93377 142.7483)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -0.93377 142.7483) scale(1 -1)">
                  144
                </text>
            </g>
            <g id="G3-145" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 3.64170 131.3493)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 3.64170 131.3493) scale(1 -1)">
                  145
                </text>
            </g>
            <g id="G3-146" class="Normal EEPCurve stil-3419 active height=1.54 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43727 0.89932 0.89932 -0.43727 2.13 149.04)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43727 0.89932 0.89932 -0.43727 2.13 149.04) scale(1 -1)">
                  146
                </text>
            </g>
            <g id="G3-147" class="Normal EEPCurve stil-3419 active height=1.54 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43727 0.89932 0.89932 -0.43727 3.66045 152.1876)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43727 0.89932 0.89932 -0.43727 3.66045 152.1876) scale(1 -1)">
                  147
                </text>
            </g>
            <g id="G3-148" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 6.71976 158.48590)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 6.71976 158.48590) scale(1 -1)">
                  148
                </text>
            </g>
            <g id="G3-150" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 5.18905 155.3384)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 5.18905 155.3384) scale(1 -1)">
                  150
                </text>
            </g>
            <g id="G3-151" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 0.59693 145.8958)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 0.59693 145.8958) scale(1 -1)">
                  151
                </text>
            </g>
            <g id="G3-152" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 20.04214 165.0728)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 20.04214 165.0728) scale(1 -1)">
                  152
                </text>
            </g>
            <g id="G3-153" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 10.63265 158.529)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 10.63265 158.529) scale(1 -1)">
                  153
                </text>
            </g>
            <g id="G3-154" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 8.25047 161.6335)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 8.25047 161.6335) scale(1 -1)">
                  154
                </text>
            </g>
            <g id="G3-155" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 8.71103 170.5833)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 8.71103 170.5833) scale(1 -1)">
                  155
                </text>
            </g>
            <g id="G3-156" class="3-Weg-Weiche EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00001 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -32.53347 179.5215)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50000" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -32.53347 179.5215) scale(1 -1)">
                  156
                </text>
            </g>
            <g id="G3-161" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -15.53907 124.72030)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -15.53907 124.72030) scale(1 -1)">
                  161
                </text>
            </g>
            <g id="G3-162" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -22.08288 134.1298)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -22.08288 134.1298) scale(1 -1)">
                  162
                </text>
            </g>
            <g id="G3-163" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -18.97841 136.512)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -18.97841 136.512) scale(1 -1)">
                  163
                </text>
            </g>
            <g id="G3-164" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -10.02853 136.0514)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -10.02853 136.0514) scale(1 -1)">
                  164
                </text>
            </g>
            <g id="G3-165" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -37.457 149.3904)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -37.457 149.3904) scale(1 -1)">
                  165
                </text>
            </g>
            <g id="G3-166" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -33.97461 133.6859)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -33.97461 133.6859) scale(1 -1)">
                  166
                </text>
            </g>
            <g id="G3-167" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -31.56854 142.63479)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -31.56854 142.63479) scale(1 -1)">
                  167
                </text>
            </g>
            <g id="G3-168" class="Normal EEPCurve stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 A -300.91939 -300.91939 0 0 0 2.99988 -0.01495" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -24.53201 129.0937)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.49996" y="0.00373" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -24.53201 129.0937) rotate(-0.28559 1.49996 -0.00373) scale(1 -1)">
                  168
                </text>
            </g>
            <g id="G3-169" class="Normal EEPCurve stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 A -300.98026 -300.98026 0 0 0 3.00004 -0.01495" transform="matrix(-0.42833 -0.90358 -0.90361 0.42835 -25.83055 126.38940)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.50003" y="0.00373" transform="matrix(-0.42833 -0.90358 -0.90361 0.42835 -25.83055 126.38940) rotate(-0.28555 1.50003 -0.00373) scale(1 -1)">
                  169
                </text>
            </g>
            <g id="G3-170" class="Normal EEPCurve stil-3417 active height=2.61 sichtbar">
                <path d="M 0 0 A -301.54432 -301.54432 0 0 0 3.00037 -0.01492" transform="matrix(-0.41925 -0.90771 -0.90784 0.41931 -27.10205 123.67219)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.50020" y="0.00373" transform="matrix(-0.41925 -0.90771 -0.90784 0.41931 -27.10205 123.67219) rotate(-0.28505 1.50020 -0.00373) scale(1 -1)">
                  170
                </text>
            </g>
            <g id="G3-172" class="Normal EEPCurve stil-3417 active height=2.56 sichtbar">
                <path d="M 0 0 A -300.96993 -300.96993 0 0 0 3.00104 -0.01496" transform="matrix(-0.41008 -0.91165 -0.91198 0.41023 -28.34642 120.9425)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.50054" y="0.00374" transform="matrix(-0.41008 -0.91165 -0.91198 0.41023 -28.34642 120.9425) rotate(-0.28565 1.50054 -0.00374) scale(1 -1)">
                  172
                </text>
            </g>
            <g id="G3-183" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A -11.75000 -11.75000 0 0 0 11.75000 -11.75000" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -3.31595 145.8527)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="8.30850" y="3.44149" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -3.31595 145.8527) rotate(-45.00000 8.30850 -3.44149) scale(1 -1)">
                  183
                </text>
            </g>
            <g id="G3-190" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -7.68940 136.8597)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -7.68940 136.8597) scale(1 -1)">
                  190
                </text>
            </g>
            <g id="G3-198" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.99999 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -10.02851 136.0514)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.49999" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -10.02851 136.0514) scale(1 -1)">
                  198
                </text>
            </g>
            <g id="G3-199" class="Normal EEPCurve stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 L 3.50011 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -28.46406 145.017)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75005" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -28.46406 145.017) scale(1 -1)">
                  199
                </text>
            </g>
            <g id="G3-208" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A 117.92304 117.92304 0 0 1 51.57330 11.87570" transform="matrix(-1 0 0 1 73.27999 125.7)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="26.46147" y="-3.00727" transform="matrix(-1 0 0 1 73.27999 125.7) rotate(12.96736 26.46147 3.00727) scale(1 -1)">
                  208
                </text>
            </g>
            <g id="G3-209" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 26.12266 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 21.70668 137.57569)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="13.06133" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 21.70668 137.57569) scale(1 -1)">
                  209
                </text>
            </g>
            <g id="G3-210" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 3.50011 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -20.63823 145.1032)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75005" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -20.63823 145.1032) scale(1 -1)">
                  210
                </text>
            </g>
            <g id="G3-212" class="Normal EEPCurve stil-3458 active height=2.63 sichtbar">
                <path d="M 0 0 L 20 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 6.782 152.61700)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="10" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 6.782 152.61700) scale(1 -1)">
                  212
                </text>
            </g>
            <g id="G3-216" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -25.23 135.66)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -25.23 135.66) scale(1 -1)">
                  216
                </text>
            </g>
            <g id="G3-226" class="Normal Line stil-3452 active height=2.63 sichtbar">
                <path d="M 0 0 L 30 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -1.875 191.688)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="15" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -1.875 191.688) scale(1 -1)">
                  226
                </text>
            </g>
            <g id="G3-228" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A -7.94916 -7.94916 0 0 0 7.94916 -7.95043" transform="matrix(-0.89949 0.43692 0.43692 0.89949 21.21898 204.982)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="5.62135" y="2.32870" transform="matrix(-0.89949 0.43692 0.43692 0.89949 21.21898 204.982) rotate(-45.00455 5.62135 -2.32870) scale(1 -1)">
                  228
                </text>
            </g>
            <g id="G3-234" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A -11.75000 -11.75000 0 0 0 11.75000 -11.75000" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -26.23840 176.46009)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="8.30850" y="3.44149" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -26.23840 176.46009) rotate(-45.00000 8.30850 -3.44149) scale(1 -1)">
                  234
                </text>
            </g>
            <g id="G3-238" class="Normal EEPCurve stil-3420 active height=2.63 sichtbar">
                <path d="M 0 0 A -346.96741 -346.96741 0 0 0 60.02148 -5.23095" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -52.68529 173.7541)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="30.12449" y="1.31021" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -52.68529 173.7541) rotate(-4.98082 30.12449 -1.31021) scale(1 -1)">
                  238
                </text>
            </g>
            <g id="G3-246" class="Normal EEPCurve stil-3458 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -37.126 170.079)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -37.126 170.079) scale(1 -1)">
                  246
                </text>
            </g>
            <g id="G3-247" class="Normal EEPCurve stil-3458 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -40.63093 175.6756)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -40.63093 175.6756) scale(1 -1)">
                  247
                </text>
            </g>
            <g id="G3-248" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -39.10022 178.8231)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -39.10022 178.8231) scale(1 -1)">
                  248
                </text>
            </g>
            <g id="G3-249" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 33.99997 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -1.78524 149.0004)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="16.99998" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -1.78524 149.0004) scale(1 -1)">
                  249
                </text>
            </g>
            <g id="G3-250" class="Weiche EEPCurve stil-3450 active height=2.64 sichtbar">
                <path d="M 0 0 L 7.00002 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -30.83 167.018)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50001" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -30.83 167.018) scale(1 -1)">
                  250
                </text>
            </g>
            <g id="G3-251" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -21.86495 185.453)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -21.86495 185.453) scale(1 -1)">
                  251
                </text>
            </g>
            <g id="G3-252" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 6.9 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -23.78574 146.63389)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.45" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -23.78574 146.63389) scale(1 -1)">
                  252
                </text>
            </g>
            <g id="G3-253" class="Weiche EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00001 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -38.6563 166.9314)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50000" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -38.6563 166.9314) scale(1 -1)">
                  253
                </text>
            </g>
            <g id="G3-256" class="Weiche EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 7 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 9.102 155.382)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.5" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 9.102 155.382) scale(1 -1)">
                  256
                </text>
            </g>
            <g id="G3-257" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00001 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -31.52547 138.7219)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50000" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -31.52547 138.7219) scale(1 -1)">
                  257
                </text>
            </g>
            <g id="G3-258" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 A 18.85015 18.85015 0 0 1 18.84988 18.75000" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -20.76806 152.8391)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="13.29361" y="-5.48572" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -20.76806 152.8391) rotate(44.84779 13.29361 5.48572) scale(1 -1)">
                  258
                </text>
            </g>
            <g id="G3-259" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 7 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -20.63823 145.1032)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.5" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -20.63823 145.1032) scale(1 -1)">
                  259
                </text>
            </g>
            <g id="G3-260" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 A 15.25040 15.25040 0 0 1 15.25040 15.24982" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -17.57681 151.3983)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="10.78345" y="-4.46653" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -17.57681 151.3983) rotate(44.99891 10.78345 4.46653) scale(1 -1)">
                  260
                </text>
            </g>
            <g id="G3-261" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 33.99996 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -26.23840 176.46009)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="16.99998" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -26.23840 176.46009) scale(1 -1)">
                  261
                </text>
            </g>
            <g id="G3-262" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A 74.18595 74.18595 0 0 1 11.43002 0.88581" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -26.23840 176.46009)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="5.73215" y="-0.22178" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -26.23840 176.46009) rotate(4.43150 5.73215 0.22178) scale(1 -1)">
                  262
                </text>
            </g>
            <g id="G3-263" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 11.4 0" transform="matrix(0.82180 -0.56976 -0.56976 -0.82180 -16.34685 170.66459)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="5.7" y="0" transform="matrix(0.82180 -0.56976 -0.56976 -0.82180 -16.34685 170.66459) scale(1 -1)">
                  263
                </text>
            </g>
            <g id="G3-264" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A -73.89355 -73.89355 0 0 0 11.30396 -0.86973" transform="matrix(0.82180 -0.56976 -0.56976 -0.82180 -6.97826 164.1693)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="5.66868" y="0.21775" transform="matrix(0.82180 -0.56976 -0.56976 -0.82180 -6.97826 164.1693) rotate(-4.39972 5.66868 -0.21775) scale(1 -1)">
                  264
                </text>
            </g>
            <g id="G3-265" class="Normal EEPCurve stil-3450 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00801 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -35.59489 173.22639)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50400" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -35.59489 173.22639) scale(1 -1)">
                  265
                </text>
            </g>
            <g id="G3-266" class="Normal EEPCurve stil-3450 active height=2.64 sichtbar">
                <path d="M 0 0 L 34 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -0.255 152.148)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="17" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -0.255 152.148) scale(1 -1)">
                  266
                </text>
            </g>
            <g id="G3-267" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A 22.24997 22.24997 0 0 1 22.24997 22.24996" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -27.76911 173.31259)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="15.73310" y="-6.51686" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -27.76911 173.31259) rotate(44.99998 15.73310 6.51686) scale(1 -1)">
                  267
                </text>
            </g>
            <g id="G3-268" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 3.50003 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -17.49075 143.5724)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75001" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -17.49075 143.5724) scale(1 -1)">
                  268
                </text>
            </g>
            <g id="G3-269" class="Normal EEPCurve stil-3458 active height=2.63 sichtbar">
                <path d="M 0 0 A -350.46745 -350.46745 0 0 0 60.62694 -5.28372" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -51.155 176.90200)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="30.42837" y="1.32342" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -51.155 176.90200) rotate(-4.98082 30.42837 -1.32342) scale(1 -1)">
                  269
                </text>
            </g>
            <g id="G3-270" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A 357.46751 357.46751 0 0 1 61.83786 5.38925" transform="matrix(0.96139 -0.27518 -0.27518 -0.96139 -106.06049 205.3945)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="31.03612" y="-1.34986" transform="matrix(0.96139 -0.27518 -0.27518 -0.96139 -106.06049 205.3945) rotate(4.98081 31.03612 1.34986) scale(1 -1)">
                  270
                </text>
            </g>
            <g id="G3-271" class="Normal EEPCurve stil-3458 active height=2.63 sichtbar">
                <path d="M 0 0 A 353.96751 353.96751 0 0 1 61.23240 5.33648" transform="matrix(0.96139 -0.27518 -0.27518 -0.96139 -107.0237 202.0296)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="30.73225" y="-1.33664" transform="matrix(0.96139 -0.27518 -0.27518 -0.96139 -107.0237 202.0296) rotate(4.98081 30.73225 1.33664) scale(1 -1)">
                  271
                </text>
            </g>
            <g id="G3-272" class="Normal EEPCurve stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 A 360.96743 360.96743 0 0 1 62.44333 5.44202" transform="matrix(0.96139 -0.27518 -0.27518 -0.96139 -105.0974 208.7594)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="31.34001" y="-1.36307" transform="matrix(0.96139 -0.27518 -0.27518 -0.96139 -105.0974 208.7594) rotate(4.98082 31.34001 1.36307) scale(1 -1)">
                  272
                </text>
            </g>
            <g id="G3-277" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 10 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -43.69235 169.38060)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="5" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -43.69235 169.38060) scale(1 -1)">
                  277
                </text>
            </g>
            <g id="G3-278" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 10 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -48.06579 160.3876)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="5" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -48.06579 160.3876) scale(1 -1)">
                  278
                </text>
            </g>
            <g id="G3-279" class="Normal EEPCurve stil-3437 active height=1.53 sichtbar">
                <path d="M 0 0 A -336.96741 -336.96741 0 0 0 58.29158 -5.08019" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -57.05873 164.7611)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="29.25626" y="1.27245" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -57.05873 164.7611) rotate(-4.98081 29.25626 -1.27245) scale(1 -1)">
                  279
                </text>
            </g>
            <g id="G3-280" class="Normal EEPCurve stil-3458 active height=2.63 sichtbar">
                <path d="M 0 0 L 9.99997 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -49.62399 180.049)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="4.99998" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -49.62399 180.049) scale(1 -1)">
                  280
                </text>
            </g>
            <g id="G3-281" class="Normal EEPCurve stil-3458 active height=2.63 sichtbar">
                <path d="M 0 0 L 10.00001 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -42.16201 172.528)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="5.00000" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -42.16201 172.528) scale(1 -1)">
                  281
                </text>
            </g>
            <g id="G3-282" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 9.99992 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -48.09310 183.19650)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="4.99996" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -48.09310 183.19650) scale(1 -1)">
                  282
                </text>
            </g>
            <g id="G3-283" class="Normal EEPCurve stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 L 10 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -46.56229 186.3445)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="5" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -46.56229 186.3445) scale(1 -1)">
                  283
                </text>
            </g>
            <g id="G3-347" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -33.73956 157.0344)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -33.73956 157.0344) scale(1 -1)">
                  347
                </text>
            </g>
            <g id="G3-348" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -12.18587 139.0464)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -12.18587 139.0464) scale(1 -1)">
                  348
                </text>
            </g>
            <g id="G3-349" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A -11.75000 -11.75000 0 0 0 11.75000 -11.75000" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -26.93328 148.16459)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="8.30850" y="3.44149" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -26.93328 148.16459) rotate(-45.00000 8.30850 -3.44149) scale(1 -1)">
                  349
                </text>
            </g>
            <g id="G3-354" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.99999 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -19.52583 186.26139)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.49999" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -19.52583 186.26139) scale(1 -1)">
                  354
                </text>
            </g>
            <g id="G3-355" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 A -11.75000 -11.75000 0 0 0 11.75000 -11.75000" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -1.09030 177.296)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="8.30850" y="3.44149" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -1.09030 177.296) rotate(-45.00000 8.30850 -3.44149) scale(1 -1)">
                  355
                </text>
            </g>
            <g id="G3-356" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 7.90262 172.9225)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 7.90262 172.9225) scale(1 -1)">
                  356
                </text>
            </g>
            <g id="G3-357" class="Normal EEPCurve stil-3440 active height=2.48 sichtbar">
                <path d="M 0 0 A 307.96995 307.96995 0 0 1 3.07084 0.01531" transform="matrix(0.40098 0.91571 0.91602 -0.40112 -35.97563 121.0083)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.53544" y="-0.00382" transform="matrix(0.40098 0.91571 0.91602 -0.40112 -35.97563 121.0083) rotate(0.28565 1.53544 0.00382) scale(1 -1)">
                  357
                </text>
            </g>
            <g id="G3-361" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.99999 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 8.71103 170.5834)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.49999" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 8.71103 170.5834) scale(1 -1)">
                  361
                </text>
            </g>
            <g id="G3-362" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 7.90262 172.9225)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 7.90262 172.9225) scale(1 -1)">
                  362
                </text>
            </g>
            <g id="G3-363" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 4.42023 188.62709)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 4.42023 188.62709) scale(1 -1)">
                  363
                </text>
            </g>
            <g id="G3-364" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 2.01416 179.6781)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 2.01416 179.6781) scale(1 -1)">
                  364
                </text>
            </g>
            <g id="G3-365" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 13.41318 184.2536)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 13.41318 184.2536) scale(1 -1)">
                  365
                </text>
            </g>
            <g id="G3-366" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -35.92623 152.5381)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -35.92623 152.5381) scale(1 -1)">
                  366
                </text>
            </g>
            <g id="G3-368" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.99999 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -36.73463 154.8772)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.49999" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -36.73463 154.8772) scale(1 -1)">
                  368
                </text>
            </g>
            <g id="G3-376" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -14.01529 197.59259)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -14.01529 197.59259) scale(1 -1)">
                  376
                </text>
            </g>
            <g id="G3-377" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -7.47147 188.18310)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -7.47147 188.18310) scale(1 -1)">
                  377
                </text>
            </g>
            <g id="G3-378" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -10.57595 185.8009)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -10.57595 185.8009) scale(1 -1)">
                  378
                </text>
            </g>
            <g id="G3-379" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -19.52583 186.2615)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -19.52583 186.2615) scale(1 -1)">
                  379
                </text>
            </g>
            <g id="G3-380" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -10.57595 185.8009)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -10.57595 185.8009) scale(1 -1)">
                  380
                </text>
            </g>
            <g id="G3-381" class="Normal EEPCurve stil-3419 active height=1.54 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.89932 -0.43727 -0.43727 -0.89932 -4.28 182.74)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.89932 -0.43727 -0.43727 -0.89932 -4.28 182.74) scale(1 -1)">
                  381
                </text>
            </g>
            <g id="G3-382" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -1.13335 181.2088)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -1.13335 181.2088) scale(1 -1)">
                  382
                </text>
            </g>
            <g id="G3-383" class="Normal EEPCurve stil-3419 active height=1.54 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(-0.89932 0.43727 0.43727 0.89932 -4.28 182.74)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(-0.89932 0.43727 0.43727 0.89932 -4.28 182.74) scale(1 -1)">
                  383
                </text>
            </g>
            <g id="G3-384" class="Normal EEPCurve stil-3450 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -31.68201 173.2695)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -31.68201 173.2695) scale(1 -1)">
                  384
                </text>
            </g>
            <g id="G3-385" class="Normal EEPCurve stil-3450 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -30.15131 176.4171)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -30.15131 176.4171) scale(1 -1)">
                  385
                </text>
            </g>
            <g id="G3-386" class="Normal EEPCurve stil-3450 active height=1.54 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43727 0.89932 0.89932 -0.43727 -34.74 166.97)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43727 0.89932 0.89932 -0.43727 -34.74 166.97) scale(1 -1)">
                  386
                </text>
            </g>
            <g id="G3-387" class="Normal EEPCurve stil-3450 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -36.27411 163.8269)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -36.27411 163.8269) scale(1 -1)">
                  387
                </text>
            </g>
            <g id="G3-388" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -31.56854 142.63479)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -31.56854 142.63479) scale(1 -1)">
                  388
                </text>
            </g>
            <g id="G3-393" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -28.42101 141.1041)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -28.42101 141.1041) scale(1 -1)">
                  393
                </text>
            </g>
            <g id="G3-394" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -25.27348 139.5734)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -25.27348 139.5734) scale(1 -1)">
                  394
                </text>
            </g>
            <g id="G3-395" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -22.12595 138.0427)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -22.12595 138.0427) scale(1 -1)">
                  395
                </text>
            </g>
            <g id="G3-396" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 3.5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -0.93377 142.7483)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -0.93377 142.7483) scale(1 -1)">
                  396
                </text>
            </g>
            <g id="G3-400" class="Normal EEPCurve stil-3450 active height=2.64 sichtbar">
                <path d="M 0 0 A -15.25319 -15.25319 0 0 0 15.25319 -15.25316" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -5.767 175.68099)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="10.78562" y="4.46754" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -5.767 175.68099) rotate(-44.99994 10.78562 -4.46754) scale(1 -1)">
                  400
                </text>
            </g>
            <g id="G3-402" class="Normal Line stil-3452 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -1.875 191.688)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -1.875 191.688) scale(1 -1)">
                  402
                </text>
            </g>
            <g id="G3-403" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00000 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 1.97110 183.5911)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50000" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 1.97110 183.5911) scale(1 -1)">
                  403
                </text>
            </g>
            <g id="G3-404" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00005 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -7.47147 188.18310)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50002" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -7.47147 188.18310) scale(1 -1)">
                  404
                </text>
            </g>
            <g id="G3-405" class="Normal EEPCurve stil-3450 active height=2.63 sichtbar">
                <path d="M 0 0 L 6.9655 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -4.324 186.65200)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.48275" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -4.324 186.65200) scale(1 -1)">
                  405
                </text>
            </g>
            <g id="G3-406" class="Normal EEPCurve stil-3450 active height=2.63 sichtbar">
                <path d="M 0 0 L 6.99074 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -1.176 185.122)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.49537" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -1.176 185.122) scale(1 -1)">
                  406
                </text>
            </g>
            <g id="G3-408" class="Weiche EEPCurve stil-3450 active height=2.63 sichtbar">
                <path d="M 0 0 L 6.11769 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 6.782 152.61700)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.05884" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 6.782 152.61700) scale(1 -1)">
                  408
                </text>
            </g>
            <g id="G3-409" class="Normal EEPCurve stil-3450 active height=2.64 sichtbar">
                <path d="M 0 0 L 3.49788 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -5.767 175.68099)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.74894" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -5.767 175.68099) scale(1 -1)">
                  409
                </text>
            </g>
            <g id="G3-410" class="Weiche EEPCurve stil-3450 active height=2.63 sichtbar">
                <path d="M 0 0 L 6.12692 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 5.251 149.47)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.06346" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 5.251 149.47) scale(1 -1)">
                  410
                </text>
            </g>
            <g id="G3-411" class="Normal EEPCurve stil-3450 active height=2.64 sichtbar">
                <path d="M 0 0 L 3.54924 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -8.92300 177.196)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.77462" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -8.92300 177.196) scale(1 -1)">
                  411
                </text>
            </g>
            <g id="G3-433" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -42.96755 138.0593)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -42.96755 138.0593) scale(1 -1)">
                  433
                </text>
            </g>
            <g id="G3-471" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -21.86498 185.453)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -21.86498 185.453) scale(1 -1)">
                  471
                </text>
            </g>
            <g id="G3-472" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -37.56953 181.9707)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -37.56953 181.9707) scale(1 -1)">
                  472
                </text>
            </g>
            <g id="G3-477" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -28.62061 179.56459)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -28.62061 179.56459) scale(1 -1)">
                  477
                </text>
            </g>
            <g id="G3-482" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -33.19608 190.9636)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -33.19608 190.9636) scale(1 -1)">
                  482
                </text>
            </g>
            <g id="G3-484" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -48.06579 160.3877)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -48.06579 160.3877) scale(1 -1)">
                  484
                </text>
            </g>
            <g id="G3-485" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -38.6563 166.9314)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -38.6563 166.9314) scale(1 -1)">
                  485
                </text>
            </g>
            <g id="G3-501" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -36.27411 163.827)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -36.27411 163.827) scale(1 -1)">
                  501
                </text>
            </g>
            <g id="G3-502" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 6.3 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -36.73469 154.87709)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.15" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 -36.73469 154.87709) scale(1 -1)">
                  502
                </text>
            </g>
            <g id="G3-511" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 19.123 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 9.10167 155.3817)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="9.5615" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 9.10167 155.3817) scale(1 -1)">
                  511
                </text>
            </g>
            <g id="G3-512" class="Normal EEPCurve stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 L 13.51041 0" transform="matrix(0.89913 -0.43766 -0.43766 -0.89913 15.67418 156.0786)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="6.75520" y="0" transform="matrix(0.89913 -0.43766 -0.43766 -0.89913 15.67418 156.0786) scale(1 -1)">
                  512
                </text>
            </g>
            <g id="G3-521" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 A 307.91931 307.91931 0 0 1 3.06966 0.01530" transform="matrix(0.42835 0.90360 0.90360 -0.42835 -32.15582 129.3879)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.53485" y="-0.00382" transform="matrix(0.42835 0.90360 0.90360 -0.42835 -32.15582 129.3879) rotate(0.28559 1.53485 0.00382) scale(1 -1)">
                  521
                </text>
            </g>
            <g id="G3-522" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 A -304.41937 -304.41937 0 0 0 3.03477 -0.01512" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -27.67954 130.6244)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.51740" y="0.00378" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 -27.67954 130.6244) rotate(-0.28559 1.51740 -0.00378) scale(1 -1)">
                  522
                </text>
            </g>
            <g id="G3-523" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 A -304.48027 -304.48027 0 0 0 3.03492 -0.01512" transform="matrix(-0.42833 -0.90358 -0.90361 0.42835 -28.99319 127.88860)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.51748" y="0.00378" transform="matrix(-0.42833 -0.90358 -0.90361 0.42835 -28.99319 127.88860) rotate(-0.28555 1.51748 -0.00378) scale(1 -1)">
                  523
                </text>
            </g>
            <g id="G3-524" class="Normal EEPCurve stil-3440 active height=2.61 sichtbar">
                <path d="M 0 0 A -305.04433 -305.04433 0 0 0 3.03519 -0.01510" transform="matrix(-0.41925 -0.90771 -0.90784 0.41931 -30.27949 125.1398)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.51761" y="0.00377" transform="matrix(-0.41925 -0.90771 -0.90784 0.41931 -30.27949 125.1398) rotate(-0.28505 1.51761 -0.00377) scale(1 -1)">
                  524
                </text>
            </g>
            <g id="G3-525" class="Normal EEPCurve stil-3440 active height=2.56 sichtbar">
                <path d="M 0 0 A -304.46989 -304.46989 0 0 0 3.03594 -0.01513" transform="matrix(-0.41009 -0.91166 -0.91198 0.41023 -31.53835 122.3783)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.51799" y="0.00378" transform="matrix(-0.41009 -0.91166 -0.91198 0.41023 -31.53835 122.3783) rotate(-0.28566 1.51799 -0.00378) scale(1 -1)">
                  525
                </text>
            </g>
            <g id="G3-541" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 5.6 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -30.82666 132.1547)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.8" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -30.82666 132.1547) scale(1 -1)">
                  541
                </text>
            </g>
            <g id="G3-542" class="Normal EEPCurve stil-3440 active height=2.61 sichtbar">
                <path d="M 0 0 A 307.98029 307.98029 0 0 1 3.06981 0.01529" transform="matrix(0.41931 0.90781 0.90783 -0.41932 -33.45694 126.6075)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.53492" y="-0.00382" transform="matrix(0.41931 0.90781 0.90783 -0.41932 -33.45694 126.6075) rotate(0.28555 1.53492 0.00382) scale(1 -1)">
                  542
                </text>
            </g>
            <g id="G3-543" class="Normal EEPCurve stil-3440 active height=2.56 sichtbar">
                <path d="M 0 0 A 307.50695 307.50695 0 0 1 3.07027 0.01532" transform="matrix(0.41017 0.91185 0.91198 -0.41023 -34.73026 123.8142)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.53515" y="-0.00383" transform="matrix(0.41017 0.91185 0.91198 -0.41023 -34.73026 123.8142) rotate(0.28603 1.53515 0.00383) scale(1 -1)">
                  543
                </text>
            </g>
            <g id="G3-545" class="Normal EEPCurve stil-3440 active height=2.36 sichtbar">
                <path d="M 0 0 A 307.72620 307.72620 0 0 1 3.07185 0.01533" transform="matrix(0.39169 0.91936 0.91998 -0.39195 -37.19295 118.1902)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.53594" y="-0.00383" transform="matrix(0.39169 0.91936 0.91998 -0.39195 -37.19295 118.1902) rotate(0.28598 1.53594 0.00383) scale(1 -1)">
                  545
                </text>
            </g>
            <g id="G3-561" class="Normal EEPCurve stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 A 311.41937 311.41937 0 0 1 3.10456 0.01547" transform="matrix(0.42835 0.90360 0.90360 -0.42835 -35.31845 130.8872)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.55230" y="-0.00386" transform="matrix(0.42835 0.90360 0.90360 -0.42835 -35.31845 130.8872) rotate(0.28559 1.55230 0.00386) scale(1 -1)">
                  561
                </text>
            </g>
            <g id="G3-562" class="Normal EEPCurve stil-3417 active height=2.61 sichtbar">
                <path d="M 0 0 A 311.48029 311.48029 0 0 1 3.10470 0.01547" transform="matrix(0.41931 0.90781 0.90783 -0.41932 -36.63437 128.0751)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.55236" y="-0.00386" transform="matrix(0.41931 0.90781 0.90783 -0.41932 -36.63437 128.0751) rotate(0.28555 1.55236 0.00386) scale(1 -1)">
                  562
                </text>
            </g>
            <g id="G3-563" class="Normal EEPCurve stil-3417 active height=2.56 sichtbar">
                <path d="M 0 0 A 312.04431 312.04431 0 0 1 3.10484 0.01544" transform="matrix(0.41020 0.91184 0.91196 -0.41026 -37.92209 125.2502)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.55244" y="-0.00386" transform="matrix(0.41020 0.91184 0.91196 -0.41026 -37.92209 125.2502) rotate(0.28505 1.55244 0.00386) scale(1 -1)">
                  563
                </text>
            </g>
            <g id="G3-564" class="Normal EEPCurve stil-3417 active height=2.48 sichtbar">
                <path d="M 0 0 A 311.46991 311.46991 0 0 1 3.10574 0.01548" transform="matrix(0.40098 0.91572 0.91602 -0.40112 -39.1817 122.4122)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.55289" y="-0.00387" transform="matrix(0.40098 0.91572 0.91602 -0.40112 -39.1817 122.4122) rotate(0.28566 1.55289 0.00387) scale(1 -1)">
                  564
                </text>
            </g>
            <g id="G3-565" class="Normal EEPCurve stil-3417 active height=2.36 sichtbar">
                <path d="M 0 0 A 311.43634 311.43634 0 0 1 3.10678 0.01549" transform="matrix(0.39169 0.91938 0.91997 -0.39197 -40.41287 119.56209)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.55341" y="-0.00387" transform="matrix(0.39169 0.91938 0.91997 -0.39197 -40.41287 119.56209) rotate(0.28578 1.55341 0.00387) scale(1 -1)">
                  565
                </text>
            </g>
            <g id="G3-582" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 7 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -25.23 135.66)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.5" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -25.23 135.66) scale(1 -1)">
                  582
                </text>
            </g>
            <g id="G3-584" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 3.50011 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -25.31650 143.4863)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="1.75005" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -25.31650 143.4863) scale(1 -1)">
                  584
                </text>
            </g>
            <g id="G3-585" class="Normal EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 7.00027 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -28.37753 137.1907)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.50013" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -28.37753 137.1907) scale(1 -1)">
                  585
                </text>
            </g>
            <g id="G3-622" class="Normal EEPCurve stil-3452 active height=2.63 sichtbar">
                <path d="M 0 0 L 30 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 14.39299 217.136)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="15" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 14.39299 217.136) scale(1 -1)">
                  622
                </text>
            </g>
            <g id="G3-623" class="Normal Line stil-3417 active height=2.63 sichtbar">
                <path d="M 0 0 L 29.99618 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -5.02234 193.2192)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="14.99809" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 -5.02234 193.2192) scale(1 -1)">
                  623
                </text>
            </g>
            <g id="G3-662" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 15.90054 0" transform="matrix(-0.43692 -0.89949 -0.89949 0.43692 17.5411 215.6068)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="7.95027" y="0" transform="matrix(-0.43692 -0.89949 -0.89949 0.43692 17.5411 215.6068) scale(1 -1)">
                  662
                </text>
            </g>
            <g id="G3-665" class="Normal EEPCurve stil-3419 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(0.43692 0.89949 0.89949 -0.43692 19.58903 196.93560)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(0.43692 0.89949 0.89949 -0.43692 19.58903 196.93560) scale(1 -1)">
                  665
                </text>
            </g>
            <g id="G3-670" class="Weiche EEPCurve stil-3418 active height=2.63 sichtbar">
                <path d="M 0 0 L 14.10082 0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 4.42023 188.62709)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="7.05041" y="0" transform="matrix(0.43734 0.89929 0.89929 -0.43734 4.42023 188.62709) scale(1 -1)">
                  670
                </text>
            </g>
            <g id="G3-671" class="Normal EEPCurve stil-3419 active height=2.63 sichtbar">
                <path d="M 0 0 L 10 0" transform="matrix(0.89949 -0.43692 -0.43692 -0.89949 24.3352 203.46830)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="5" y="0" transform="matrix(0.89949 -0.43692 -0.43692 -0.89949 24.3352 203.46830) scale(1 -1)">
                  671
                </text>
            </g>
            <g id="G3-739" class="Normal EEPCurve stil-1502 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 5.71589 168.42610)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(-0.43734 -0.89929 -0.89929 0.43734 5.71589 168.42610) scale(1 -1)">
                  739
                </text>
            </g>
            <g id="G3-740" class="Normal EEPCurve stil-1502 active height=1.53 sichtbar">
                <path d="M 0 0 L 5 0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -17.36847 183.2663)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="2.5" y="0" transform="matrix(0.89929 -0.43734 -0.43734 -0.89929 -17.36847 183.2663) scale(1 -1)">
                  740
                </text>
            </g>
            <g id="G3-752" class="3-Weg-Weiche EEPCurve stil-3440 active height=2.63 sichtbar">
                <path d="M 0 0 L 7 0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 10.63265 158.529)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="3.5" y="0" transform="matrix(-0.89929 0.43734 0.43734 0.89929 10.63265 158.529) scale(1 -1)">
                  752
                </text>
            </g>
            <g id="G3-759" class="Normal EEPCurve stil-3450 active height=2.64 sichtbar">
                <path d="M 0 0 L 33.95463 0" transform="matrix(0.89923 -0.43746 -0.43746 -0.89923 -29.2925 170.16)" />
                <text dx="-0.5em" dy="-0.1em" class="GleisID" x="16.97731" y="0" transform="matrix(0.89923 -0.43746 -0.43746 -0.89923 -29.2925 170.16) scale(1 -1)">
                  759
                </text>
            </g>
        </g>
    </g>
</svg>
`;
